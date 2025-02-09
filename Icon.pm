package Tags::HTML::Icon;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use Scalar::Util qw(blessed);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_class'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# CSS style for list.
	$self->{'css_class'} = 'icon';

	# Process params.
	set_params($self, @{$object_params_ar});

	# Object.
	return $self;
}

sub _cleanup {
	my $self = shift;

	delete $self->{'_icon'};

	return;
}

sub _init {
	my ($self, $icon) = @_;

	if (! defined $icon || ! blessed($icon) || ! $icon->isa('Data::Icon')) {
		err 'Data object for icon is not valid.';
	}

	$self->{'_icon'} = $icon;

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	if (! exists $self->{'_icon'}) {
		return;
	}

	$self->{'tags'}->put(
		['b', 'span'],
		['a', 'class', $self->{'css_class'}],
	);
	if (defined $self->{'_icon'}->url) {
		$self->{'tags'}->put(
			['b', 'img'],
			defined $self->{'_icon'}->alt ? (
				['a', 'alt', $self->{'_icon'}->alt],
			) : (),
			['a', 'src', $self->{'_icon'}->url],
			['e', 'img'],
		);
	} else {
		my @style;
		if (defined $self->{'_icon'}->bg_color) {
			push @style, 'background-color:'.$self->{'_icon'}->bg_color.';';
		}
		if (defined $self->{'_icon'}->color) {
			push @style, 'color:'.$self->{'_icon'}->color.';';
		}
		$self->{'tags'}->put(
			@style ? (
				['b', 'span'],
				['a', 'style', (join '', @style)],
			) : (),
			['d', $self->{'_icon'}->char],
			@style ? (
				['e', 'span'],
			) : (),
		);
	}
	$self->{'tags'}->put(
		['e', 'span'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_class'}],
		# TODO
		['e'],
	);

	return;
}

1;
