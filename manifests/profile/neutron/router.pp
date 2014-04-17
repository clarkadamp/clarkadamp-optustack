class optustack::profile::neutron::router {

  Exec { 
    path => '/usr/bin:/usr/sbin:/bin:/sbin', 
    require => Class['havana::profile::neutron::common'],
  } 
  
  ::sysctl::value { 'net.ipv4.ip_forward': 
    value     => '1',
  }

  include 'optustack::profile::neutron::common'

  ### Router service installation
  class { '::neutron::agents::l3':
    debug   => hiera('optustack::neutron::debug'),
    enabled => true,
  }

  class { '::neutron::agents::dhcp':
    debug   => hiera('optustack::neutron::debug'),
    enabled => true,
  }

  class { '::neutron::agents::metadata':
    auth_password => hiera('optustack::neutron::password'),
    shared_secret => hiera('optustack::neutron::shared_secret'),
    auth_url      => "http://api-admin.openstack.home:35357/v2.0",
    debug         => hiera('optustack::neutron::debug'),
    auth_region   => hiera('optustack::region'),
    metadata_ip   => "api-internal.openstack.home",
    enabled       => true,
  }

  vs_bridge { 'br-ex':
    ensure => present,
  }

  vs_port { 'eth2':
    ensure  => present,
    bridge  => 'br-ex',
    keep_ip => true,
  } 
  
}
