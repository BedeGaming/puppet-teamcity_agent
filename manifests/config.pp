class teamcity_agent::config (
  
  $wget             = $teamcity_agent::wget,
  $unzip            = $teamcity_agent::unzip,
  $server_url       = $teamcity_agent::server_url,
  $user             = $teamcity_agent::user,
  $agent_name       = $teamcity_agent::agent_name,
  $own_address      = $teamcity_agent::own_address,
  $own_port         = $teamcity_agent::own_port,
  $service          = $teamcity_agent::service,
  $service_path     = $teamcity_agent::service_path,
  $service_file     = $teamcity_agent::service_file,
  $service_template = $teamcity_agent::service_template,
  $properties       = $teamcity_agent::properties,
  
) {

  $propfile = "/home/${user}/buildAgent/conf/buildAgent.properties"

  # Install the default unconfigured configuration file if missing
  file { $propfile:
    ensure  => 'present',
    replace => 'no',
    source  => 'puppet:///modules/teamcity_agent/buildAgent.properties',
    owner   => $user,
  }

  # Have the latest properties augeas lens available for configuring properties files
  $lens = '/usr/share/augeas/lenses/propertieslatest.aug'
  file { $lens:
    ensure => file,
    source => 'puppet:///modules/teamcity_agent/propertieslatest.aug',
  }

  augeas { $propfile:
    lens    => "propertieslatest.lns",
    incl    => $propfile,
    changes => [
      "set serverUrl ${server_url}",
      "set name ${agent_name}",
      "set ownAddress ${own_address}",
      "set ownPort ${own_port}"
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

  file { "${service_path}/${service_file}":
    ensure  => 'present',
    content => template($service_template),
    mode    => '0755',
  }

}
