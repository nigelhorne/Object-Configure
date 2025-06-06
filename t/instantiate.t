use strict;
use warnings;

use Test::Most tests => 5;

BEGIN { use_ok('Object::Configure') }

# Dummy class to test instantiation
{
	package My::Dummy;

	sub new {
		my ($class, $params) = @_;
		return bless $params, $class;
	}

	sub get_logger {
		my $self = shift;
		return $self->{logger};
	}
}

# Set up test
my $obj = Object::Configure::instantiate(
	class => 'My::Dummy',
	logger => { syslog => 'local0' } # simulate logger config
);

isa_ok($obj, 'My::Dummy', 'Object is instance of My::Dummy');
ok(exists $obj->{logger}, 'Logger is defined');
isa_ok($obj->{logger}, 'Log::Abstraction', 'Logger is a Log::Abstraction object');
ok($obj->{logger}->can('warn'), 'Logger can call warn method');
