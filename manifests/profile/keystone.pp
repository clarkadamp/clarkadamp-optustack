class optustack::profile::keystone {

  class { '::keystone':
    enabled         => false,
    admin_token     => hiera('optustack::keystone::admin_token'),
    sql_connection  => "mysql://keystone:service_password@db.openstack.home/keystone", 
    mysql_module    => '2.2',
    verbose         => hiera('optustack::keystone::verbose'),
    debug           => hiera('optustack::keystone::debug'),
    rabbit_hosts    => hiera('optustack::rabbitmq::slb'),
    rabbit_userid   => hiera('optustack::rabbitmq::userid'),
    rabbit_password => hiera('optustack::rabbitmq::password'),
  } 
  #package { 'python-paste-deploy':
  #  ensure          => present
  #} ->
  class { 'keystone::wsgi::apache':
    ssl             => false,
  }

  #file { '/var/log/httpd':
  #  ensure          => directory,
  ##  owner           => 'apache',
  #  mode            => 0700,
  #}  

  @@haproxy::balancermember { "${fqdn}_keystone_admin":
    listening_service => 'keystone_admin_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '35357',
    options           => 'check inter 2000 rise 2 fall 5'
  }

  @@haproxy::balancermember { "${fqdn}_keystone_public_internal":
    listening_service => 'keystone_public_internal_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '5000',
    options           => 'check inter 2000 rise 2 fall 5'
  }

}
