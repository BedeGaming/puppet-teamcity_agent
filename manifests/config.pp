#
class teamcity_agent::config inherits teamcity_agent {

  # TODO(tlimoncelli): store the port number in
  # /home/${user}/buildAgent/logs/buildAgent.port
  # so that /home/teamcity/buildAgent/bin/agent.sh works.

  $propfile = "/home/${user}/buildAgent/conf/buildAgent.properties"

  # Install the default unconfigured configuration file if missing
  file { $propfile:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    replace => 'no',
    source  => 'puppet:///modules/teamcity_agent/buildAgent.properties',
    require => Class['teamcity_agent::install'],
  }
  # FIXME(tlimoncelli): Consider creating $propfile file by copying
  #   /home/teamcity/buildAgent/conf/buildAgent.dist.properties

  # Have the latest properties augeas lens available for configuring properties files
  $lens = '/usr/share/augeas/lenses/propertieslatest.aug'
  file { $lens:
    ensure => file,
    owner  => $user,
    group  => $group,
    mode   => '0644',
    source => 'puppet:///modules/teamcity_agent/propertieslatest.aug',
  }

  augeas { $propfile:
    lens    => 'propertieslatest.lns',
    incl    => $propfile,
    changes => [
      "set serverUrl ${server_url}",
      "set name ${agent_name}",
      "set ownAddress ${own_address}",
      "set ownPort ${own_port}",
      'set teamcity.git.use.local.mirrors true',
      'set teamcity.git.use.shallow.clone true',
    ],
    require => [ File[$propfile], File[$lens] ],
  }

  # This is possibly a better way to convert the $properties hash to "set property value" strings for augeas:
  # https://groups.google.com/forum/#!topic/puppet-users/e4B9V8u-YZw
  augeas { "${propfile}-custom-properties":
    lens    => "propertieslatest.lns",
    incl    => $propfile,
    changes => suffix(prefix(join_keys_to_values($properties, ' "'), 'set '), '"'),
    require => [ File[$propfile], File[$lens] ],
  }

  file { "/home/${user}/buildAgent/bin/agent.sh":
    mode => '0755',
  }

  file { "/etc/init.d/${service}":
    ensure  => file,
    content => template('teamcity_agent/init_script.erb'),
    mode    => '0755',
  }

}
