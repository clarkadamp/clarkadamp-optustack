class optustack::profile::nova::api {
 
  class { '::nova':
    sql_connection     => "mysql://nova:service_password@db.openstack.home/nova",
    glance_api_servers => "http://api-internal.openstack.home:9292",
    memcached_servers  => ["slb01.openstack.home:11211","slb02.openstack.home:11211"],
    rabbit_hosts       => hiera('optustack::rabbitmq::slb'),
    rabbit_userid      => hiera('optustack::rabbitmq::userid'),
    rabbit_password    => hiera('optustack::rabbitmq::password'),
    debug              => hiera('optustack::nova::debug'),
    verbose            => hiera('optustack::nova::verbose'),
    mysql_module       => '2.2',
  } 

  class { '::nova::api':
    admin_password                       => hiera('optustack::nova::password'),
    auth_host                            => "api-internal.openstack.home",
    enabled                              => true,
    neutron_metadata_proxy_shared_secret => hiera('optustack::neutron::shared_secret'),
  }

  class { '::nova::vncproxy':
    enabled => true,
  } 

  class { [
    'nova::scheduler',
    'nova::objectstore',
    'nova::cert',
    'nova::consoleauth',
    'nova::conductor'
  ]:
    enabled => true,
  }

  class { '::nova::compute':
    enabled                       => false,
    vnc_enabled                   => true,
    vncserver_proxyclient_address => $ipaddress_eth0,
    vncproxy_host                 => "vnc.openstack.home",
  }

 class { '::nova::compute::neutron': }

  class { '::nova::network::neutron':
    neutron_admin_password => hiera('optustack::neutron::password'),
    neutron_region_name    => hiera('optustack::region'),
    neutron_admin_auth_url => "http://api-internal.openstack.home:35357/v2.0",
    neutron_url            => "http://api-internal.openstack.home:9696",
  }

  @@haproxy::balancermember { "${fqdn}_nova_ec2_api_cluster":
    listening_service => 'nova_ec2_api_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '8773',
    options           => 'check inter 2000 rise 2 fall 5'
  } 

  @@haproxy::balancermember { "${fqdn}_nova_metadata_api_cluster":
    listening_service => 'nova_metadata_api_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '8775',
    options           => 'check inter 2000 rise 2 fall 5'
  } 

  @@haproxy::balancermember { "${fqdn}_nova_osapi_cluster":
    listening_service => 'nova_osapi_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '8774',
    options           => 'check inter 2000 rise 2 fall 5'
  } 

  @@haproxy::balancermember { "${fqdn}_novnc_cluster":
    listening_service => 'novnc_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '6080',
    options           => 'check inter 2000 rise 2 fall 5'
  } 

}
