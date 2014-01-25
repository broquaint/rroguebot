package Bot::M::Config;

=head1 NAME

Bot::M::Config - A singleton that stores configuration data.

=head1 SYNOPSIS

    use Bot::M::Config;

    my $config = Bot::M::Config->instance();
    $config->parse_config('/opt/botconfig.json');
    my $nick = $config->get_key('irc_nick');

=cut

use common::sense;

use base 'Class::Singleton';

use Carp;
use JSON::PP;

use Bot::V::Log;

=head1 METHODS

=cut

=head2 parse_config($file)

Parses the configuration file $file and stores configuration data internally.
Returns a true value if the parse is successful or false otherwise.

=cut

sub parse_config
{
    my ($self, $file) = @_;

    my $config = eval {
      local(@ARGV, $/) = $file;
      JSON::PP->new->decode(<>);
    };

    if ($config)
    {
        $self->{config} = $config;
        Bot::V::Log->instance()->log('Parsed configuration');
    }
    else
    {
        Bot::V::Log->instance()->log("Failed to parse configuration '$file' - $@");
    }

    return $config;
}

=head2 get_key($key)

Retrieves a value for the specified configuration key or undef if the key does
not exist.

The parse_config() method should be called before any keys are retrieved.

=cut
sub get_key
{
    my ($self, $key) = @_;

    carp 'Configuration not available yet' and return unless $self->{config};
    return $self->{config}->{$key};
}

1;

=head1 AUTHOR

Colin Wetherbee <cww@denterprises.org>

=head1 COPYRIGHT

Copyright (c) 2011 Colin Wetherbee

=head1 LICENSE

See the COPYING file included with this distribution.

=cut
