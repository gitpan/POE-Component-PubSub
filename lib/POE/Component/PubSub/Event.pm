package POE::Component::PubSub::Event;
our $VERSION = '0.091370';


#ABSTRACT: An event abstraction for POE::Component::PubSub

use 5.010;
use MooseX::Declare;

class POE::Component::PubSub::Event
{
    use MooseX::Types::Set::Object;
    use POE::Component::PubSub::Types(':all');
    use signatures;

    has name =>
    (
        is          => 'rw',
        isa         => 'Str',
        required    => 1,
    );





    has subscribers =>
    (
        is          => 'rw', 
        isa         => 'Set::Object', 
        default     => sub { [] },
        lazy        => 1,
        coerce      => 1,
        clearer     => 'clear_subscribers',
        handles     =>
        {
            all_subscribers     => 'members',
            has_subscribers     => 'size',
            add_subscriber      => 'insert',
            remove_subscriber   => 'delete',
        }
    );


    has publisher =>
    (
        is          => 'rw',
        isa         => 'Str',
        predicate   => 'has_publisher',
    );


    has publishtype =>
    (
        is          => 'rw',
        isa         => PublishType,
        default     => +PUBLISH_OUTPUT,
        trigger     => sub ($self, $type) 
        { 
            confess 'Cannot set publishtype to INPUT if there is no publisher' 
                if $type == +PUBLISH_INPUT and not $self->has_publisher;
        }
    );


    has input =>
    (
        is          => 'rw',
        isa         => 'Str',
        predicate   => 'has_input',
        trigger     => sub ($self, $input)
        {
            confess 'Cannot set input on Event if publishtype is OUTPUT'
                if $self->publishtype == +PUBLISH_OUTPUT;
            confess 'Cannot set inout if there is no publisher'
                if not $self->has_publisher;
        },
    );


    method find_subscriber(SessionID $session) returns (Maybe[Subscriber])
    {
        my $subscriber;
        map { $_->{'session'} == $session ? $subscriber = $_ : undef } $self->subscribers->all;
        return $subscriber;
    }
}

1;




=pod

=head1 NAME

POE::Component::PubSub::Event - An event abstraction for POE::Component::PubSub

=head1 VERSION

version 0.091370

=head1 DESCRIPTION

POE::Component::PubSub::Event is a simple abstraction for published and 
subscribed events within PubSub. When using the find_event method or the
listing method from PubSub, you will receive this object.

=head1 ATTRIBUTES

=head2 name

The name of the event.

=head2 subscribers, predicate => 'has_subscribers', clearer => 'clear_subscribers

The event's subscribers stored in a Set::Object

=head2 publisher, predicate => 'has_publisher'

The event's publisher.

=head2 publishtype, isa => PublishType

The event's publish type. 

=head2 input, predicate => 'has_input'

If the publishtype is set to PUBLISH_INPUT, this will indicate the input
handling event that belongs to the publisher

=head1 METHODS

=head2 all_subscribers()

This method is delegated to the subscribers attribute to return all of the
subscribers for this event

=head2 add_subscriber(Subscriber $sub)

Add the supplied subscriber to the event

=head2 remove_subscriber(Subscriber $sub)

Remove the supplied subscriber from the event

=head2 find_subscriber(SessionID $session) returns (Maybe[Subscriber])

This method will search for a particular subscriber by their SessionID. Returns
undef if none was found.

=head1 AUTHOR

  Nicholas Perez <nperez@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2009 by Nicholas Perez.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut 



__END__

