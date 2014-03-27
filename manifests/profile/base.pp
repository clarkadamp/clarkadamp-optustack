# The base profile for OpenStack. Installs the repository and ntp
class optustack::profile::base {
  # everyone also needs to be on the same clock
  class { '::ntp': }

  # Create the admins group and sysadmin users
  group { "admins":
    ensure => present,
    gid    => 500
  } ->
  users { sysadmins: }

  # allow users in the admins group sudo access
  sudo::conf { 'admins':
    priority => 10,
    content  => "%admins ALL=(ALL) NOPASSWD: ALL",
  }

  Package["ruby-augeas"] -> Augeas <| |>

  # Install additional package that help make life easier
  $extra_packages = hiera( optustack::extra_packages , [] )
  package { $extra_packages: 
	ensure => installed 
  }  

  service { 'iptables':
    ensure => stopped
  }

}
