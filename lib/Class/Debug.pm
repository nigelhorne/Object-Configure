package Class::Debug;

use strict;
use warnings;

use Carp;
use Config::Abstraction 0.20;
use Log::Abstraction 0.11;

=head1 NAME

Class::Debug - Add Runtime Debugging to a Class

=head1 VERSION

0.01

=cut

our $VERSION = 0.01;

sub setup
{
	my $class = shift;
	my $params = shift;

	# Load the configuration from a config file, if provided
	if(exists($params->{'config_file'})) {
		# my $config = YAML::XS::LoadFile($params->{'config_file'});
		my $config_dirs = $params->{'config_dirs'};
		if((!$config_dirs) && (!-r $params->{'config_file'})) {
			croak("$class: ", $params->{'config_file'}, ': File not readable');
		}

		if(my $config = Config::Abstraction->new(config_dirs => $config_dirs, config_file => $params->{'config_file'}, env_prefix => "${class}::")) {
			$params = $config->merge_defaults(defaults => $params, section => $class);
		} else {
			croak("$class: Can't load configuration from ", $params->{'config_file'});
		}
	} elsif(my $config = Config::Abstraction->new(env_prefix => "${class}::")) {
		$params = $config->merge_defaults(defaults => $params, section => $class);
	}

	# Load the default logger, which may have been defined in the config file or passed in
	if(my $logger = $params->{'logger'}) {
		if((ref($logger) eq 'HASH') && $logger->{'syslog'}) {
			$params->{'logger'} = Log::Abstraction->new(carp_on_warn => 1, syslog => $logger->{'syslog'});
		} else {
			$params->{'logger'} = Log::Abstraction->new(carp_on_warn => 1, logger => $logger);
		}
	} else {
		$params->{'logger'} = Log::Abstraction->new(carp_on_warn => 1);
	}
}

1;
