class teamcity_agent::service (

  $service = $teamcity_agent::service,
  
) {

  service { $service:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
