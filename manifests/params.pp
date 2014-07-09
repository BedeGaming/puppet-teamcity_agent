class teamcity_agent::params {

  $user        = 'teamcity'
  $group       = 'teamcity'
  $service     = 'teamcity_agent'

  $server_url  = 'http://localhost/'
  $agent_name  = $::hostname
  $own_address = $::fqdn
  $own_port    = '9090'
  $properties  = { }

  $wget        = '/usr/bin/wget'
  $unzip       = '/usr/bin/unzip'

  $javapackage = 'icedtea-6-jre-jamvm'

}
