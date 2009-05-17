package POE::Component::PubSub::Types;
our $VERSION = '0.091370';


#ABSTRACT: Exported Types for use within POE::Component::PubSub


use POE;
use Moose;
use MooseX::Types -declare => [ 'PublishType', 'Subscriber', 'SessionID', 'SessionAlias', 'SessionRef', 'DoesSessionInstantiation' ];
use MooseX::Types::Moose('Int', 'Str');
use MooseX::Types::Structured('Dict');


use constant PUBLISH_OUTPUT => 2;
use constant PUBLISH_INPUT  => -2;

use Sub::Exporter -setup => { exports => [ qw/ PublishType Subscriber SessionID  PUBLISH_INPUT PUBLISH_OUTPUT SessionAlias SessionRef DoesSessionInstantiation to_SessionID /] };

class_type 'POE::Session';


subtype PublishType,
    as Int,
    where { $_ == -2 || $_ == 2 },
    message { 'PublishType is not PublishInput or PublishOutput' };


subtype Subscriber,
    as Dict[session => SessionID, event => Str];


subtype SessionID,
    as Int,
    where { $_ > 0 },
    message { 'Something is horribly wrong with the SessionID.' };


subtype SessionAlias,
    as Str;


subtype SessionRef,
    as 'POE::Session';


subtype DoesSessionInstantiation,
    as 'Moose::Object',
    where { $_->does('POEx::Role::SessionInstantiation') };


coerce SessionID,
    from SessionAlias,
        via { $poe_kernel->alias_resolve($_)->ID },
    from SessionRef,
        via { $_->ID },
    from DoesSessionInstantiation,
        via { $_->ID };

1;




=pod

=head1 NAME

POE::Component::PubSub::Types - Exported Types for use within POE::Component::PubSub

=head1 VERSION

version 0.091370

=head1 DESCRIPTION

This modules exports the needed subtypes, coercions, and constants for PubSub
and is based on Sub::Exporter, so see that module for options on importing.

=head1 CONSTANTS

=head2 PUBLISH_OUTPUT

This indicates the Event is an output event

=head2 PUBLISH_INPUT

This indicates the Event is an input event

=head1 TYPES

=head2 PublishType

The publish type constraint applied to Events. Can either be PUBLISH_INPUT or 
PUBLISH_OUTPUT

=head2 Subscriber

When manipulating subscribers in an Event, except to receive a well formed hash
with the keys 'session' and 'event' corresponding to the subscribers SessionID
and their event handler, respectively

=head2 SessionID

Session IDs in POE are represented as positive integers and this Type 
constrains as such

=head2 SessionAlias

Session aliases are strings in and this is simply an alias for Str

=head2 SessionRef

This sets an isa constraint on POE::Session

=head2 DoesSessionInstantiation

This sets a constraint for an object that does
POEx::Role::SessionInstantiation

=head1 COERCIONS

You can coerce SessionAlias, SessionRef, and DoesSessionInstantiation to a 
SessionID (via to_SessionID)

=head1 AUTHOR

  Nicholas Perez <nperez@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2009 by Nicholas Perez.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut 



__END__
