class optustack::profile::cinder {


  class { '::cinder':
    sql_connection    => "mysql://cinder:service_password@db.openstack.home/cinder",
    rabbit_hosts      => hiera('optustack::rabbitmq::slb'),
    rabbit_userid     => hiera('optustack::rabbitmq::userid'),
    rabbit_password   => hiera('optustack::rabbitmq::password'),
    debug             => hiera('optustack::cinder::debug'),
    verbose           => hiera('optustack::cinder::verbose'),
    mysql_module      => '2.2'
  }

  class { '::cinder::api':
    keystone_password  => hiera('optustack::cinder::password'),
    keystone_auth_host => "api-internal.openstack.home",
    enabled            => true,
  }

  class { '::cinder::scheduler':
    scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
    enabled          => true,
  }

  class { '::cinder::volume':  }

  class { '::cinder::backends':
    enabled_backends    => ['rbd'],
    default_volume_type => 'rbd',
  }

  ::cinder::backend::rbd{ 'rbd':
    rbd_pool         => 'volumes',
    rbd_user         => 'cinder',
    rbd_secret_uuid  => hiera('optustack::ceph::cinder::rbd_secret_uuid'),
  } 
   


  @@haproxy::balancermember { "${fqdn}_cinder_api_cluster":
    listening_service => 'cinder_api_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '8776',
    options           => 'check inter 2000 rise 2 fall 5'
  }


}
