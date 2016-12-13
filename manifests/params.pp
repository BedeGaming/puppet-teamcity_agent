class teamcity_agent::params {

  $user        = 'teamcity'
  $service     = 'teamcity_agent'

  $server_url  = 'http://localhost/'
  $agent_name  = $hostname
  $own_address = 'localhost'
  $own_port    = '9090'
  $properties  = { }
  $limitnofile = '20142'

  $wget        = '/usr/bin/wget'
  $unzip       = '/usr/bin/unzip'

  case $::osfamily {
    'RedHat': {
        $service_path = $::operatingsystemmajrelease ? {
            /(5|6)/ => '/etc/init.d',
            /(7)/   => '/lib/systemd/system',
        }
        $service_file = $::operatingsystemmajrelease ? {
            /(5|6)/ => "${service}",
            /(7)/   => "${service}.service",
        }
        $service_template = $::operatingsystemmajrelease ? {
            /(5|6)/ => 'teamcity_agent/init_script.erb',
            /(7)/   => 'teamcity_agent/systemd_script.erb'
        }
    }
  }
}
