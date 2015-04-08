class teamcity_agent::requirements {

  if ! defined(Package['wget'])                { package { 'wget':                ensure => installed, } }
  if ! defined(Package['unzip'])               { package { 'unzip':               ensure => installed, } }
  if ! defined(Package[$javapackage])          { package { $javapackage:          ensure => installed, } }

}
