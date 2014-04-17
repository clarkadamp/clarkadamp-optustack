class optustack::profile::neutron::server {
 
  include ::optustack::profile::neutron::common
  
  class { '::neutron::server':
    auth_host           => hiera('optustack::endpoint::address:internal'),
    auth_password       => hiera('optustack::neutron::password'),
    database_connection => "mysql://neutron:service_password@db.openstack.home/neutron",
    enabled             => true,
    mysql_module       => '2.2',
  }

  @@haproxy::balancermember { "${fqdn}_neutron_api_cluster":
    listening_service => 'neutron_api_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '9696',
    options           => 'check inter 2000 rise 2 fall 5'
  } 
  
}
