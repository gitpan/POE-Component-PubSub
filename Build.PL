
use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
  module_name   => 'POE::Component::PubSub',
  license       => 'gpl',
  dist_abstract => "A\ publish\/subscribe\ component\ for\ the\ POE\ framework",
  dist_name     => "POE\-Component\-PubSub",
  dist_author   => [
"Nicholas\ Perez\ \<nperez\@cpan\.org\>",
  ],
  requires      => {
    "POEx::Role::SessionInstantiation" => '0.01',
    "MooseX::Declare" => '0.22',
    "POE::API::Peek" => '2.15',
    "MooseX::Types::Structured" => '0.14',
    "signatures" => '0.05',
    "perl" => '5.10.0',
    "MooseX::Types::Set::Object" => '0.02',
    "MooseX::Types" => '0.10',
    "POE" => '1.005',
    "Moose" => '0.79',
  },
  script_files => [ qw() ],
);

$build->create_build_script;
