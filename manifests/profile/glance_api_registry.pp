class optustack::profile::glance_api_registry {

  class { '::glance::api':
    keystone_password     => hiera('optustack::glance::password'),
    auth_host             => "api-internal.openstack.home",
    keystone_tenant       => 'services',
    keystone_user         => 'glance',
    sql_connection        => "mysql://glance:service_password@db.openstack.home/glance",
    registry_host         => "api-internal.openstack.home",
    verbose               => hiera('optustack::glance::verbose'),
    debug                 => hiera('optustack::glance::debug'),
    mysql_module          => '2.2',
    show_image_direct_url => true,
    #pipeline              => '',
  }

  class { '::glance::backend::rbd': }

  class { '::glance::notify::rabbitmq': 
    rabbit_password => hiera('optustack::rabbitmq::password'),
    rabbit_userid   => hiera('optustack::rabbitmq::userid'),
    rabbit_host     => hiera('optustack::rabbitmq::slb'),
  }

  glance_api_config {
    'DEFAULT/rabbit_ha_queues':        value => 'True';
  }

  class { '::glance::registry':
    keystone_password => hiera('optustack::glance::password'),
    sql_connection    => "mysql://glance:service_password@db.openstack.home/glance",
    auth_host         => "api-internal.openstack.home",
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    verbose           => true,
    debug             => true,
    mysql_module      => '2.2',
    #pipeline          => '',
  }

  @@haproxy::balancermember { "${fqdn}_glance_api_cluster":
    listening_service => 'glance_api_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '9292',
    options           => 'check inter 2000 rise 2 fall 5'
  }

  @@haproxy::balancermember { "${fqdn}_glance_registry_cluster":
    listening_service => 'glance_registry_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '9191',
    options           => 'check inter 2000 rise 2 fall 5'
  }

}
