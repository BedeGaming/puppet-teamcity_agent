class teamcity_agent::install (

  $wget       = $teamcity_agent::wget,
  $unzip      = $teamcity_agent::unzip,
  $server_url = $teamcity_agent::server_url,
  $user       = $teamcity_agent::user,

) {

  $download_command = "${wget} ${server_url}/update/buildAgent.zip"
  $unzip_command    = "${unzip} buildAgent.zip -d buildAgent"

  exec { $download_command:
    cwd     => "/home/${user}",
    creates => "/home/${user}/buildAgent.zip",
    require => [ Package['wget'], User[$user] ],
    user    => $user,
  }

  exec { $unzip_command:
    cwd     => "/home/${user}",
    creates => "/home/${user}/buildAgent",
    require => [ Package['unzip'], User[$user] ],
    user    => $user,
  }

  Exec[$download_command] ->
    Exec[$unzip_command]

  file { "/home/${user}/buildAgent/logs":
    ensure  => directory,
    mode    => '0775',
    owner   => $user,
    group   => $user,
    require => Exec[$unzip_command],
  }

}
