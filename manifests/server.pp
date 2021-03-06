# Class: openldap::server
#
# This class manages OpenLDAP server configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class openldap::server(
  $rootdn   = undef,
  $rootpw   = undef,
  $tls_ca   = undef,
  $tls_cert = undef,
  $tls_key  = undef,
  $options  = {},
) {
  package { $::openldap::params::package:
    ensure => present,
  } ->
  file { "${::openldap::params::confdir}/slapd.d":
    ensure  => absent,
    force   => true,
  } ~>
  file { "${::openldap::params::confdir}/schema":
    ensure  => directory,
    owner => root,
    group => $::openldap::params::group,
    mode  => '0640',
  } ~>
  file { "${::openldap::params::confdir}/slapd.conf":
    content => template('openldap/server/slapd.conf.erb'),
    owner => root,
    group => $::openldap::params::group,
    mode  => '0640',
  } ~>
  concat { 'openldap-schemas':
    path => "${::openldap::params::confdir}/schemas.conf",
    force => true,
    owner => root,
    group => $::openldap::params::group,
    mode  => '0640',
  } ~>
  concat { 'openldap-accesses':
    path => "${::openldap::params::confdir}/accesses.conf",
    force => true,
    owner => root,
    group => $::openldap::params::group,
    mode  => '0640',
  } ~>
  concat { 'openldap-domains':
    path => "${::openldap::params::confdir}/domains.conf",
    force => true,
    owner => root,
    group => $::openldap::params::group,
    mode  => '0640',
  } ~>
  service { $::openldap::params::service:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  } ->
  rsyslog::snippet { 'slapd':
    content => 'local4.*  /var/log/slapd.log',
  }
}
