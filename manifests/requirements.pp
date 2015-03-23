class teamcity_agent::requirements inherits teamcity_agent {

  if ! defined(Package['wget'])                { package { 'wget':                ensure => installed, } }
  if ! defined(Package['unzip'])               { package { 'unzip':               ensure => installed, } }

}
