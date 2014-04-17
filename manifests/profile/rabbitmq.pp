class optustack::profile::rabbitmq (
  $userid             = hiera('optustack::rabbitmq::userid',   'guest'),
  $password           = hiera('optustack::rabbitmq::password', 'guest'),
  $port               ='5672',
  $virtual_host       ='/',
  $cluster_disk_nodes = hiera('optustack::rabbitmq::cluster_nodes', 'false'),
  $enabled            = true,
) {

  if ($enabled) {
    if $userid == 'guest' {
      $delete_guest_user = false
    } else {
      $delete_guest_user = true
      rabbitmq_user { $userid:
        admin     => true,
        password  => $password,
        provider  => 'rabbitmqctl',
        require   => Class['rabbitmq::server'],
      }
      # I need to figure out the appropriate permissions
      rabbitmq_user_permissions { "${userid}@${virtual_host}":
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
      }
    }
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  if $cluster_disk_nodes {
    class { 'rabbitmq::server':
      service_ensure           => $service_ensure,
      port                     => $port,
      delete_guest_user        => $delete_guest_user,
      config_cluster           => true,
      cluster_disk_nodes       => $cluster_disk_nodes,
      wipe_db_on_cookie_change => true,
    }
  } else {
    class { 'rabbitmq::server':
      service_ensure    => $service_ensure,
      port              => $port,
      delete_guest_user => $delete_guest_user,
    }
  }

  if ($enabled) {
    rabbitmq_vhost { $virtual_host:
      provider => 'rabbitmqctl',
      require  => Class['rabbitmq::server'],
    }
  }

  @@haproxy::balancermember { "${fqdn}_rabbitmq":
    listening_service => 'rabbitmq_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => $port,
    options           => 'check inter 2000 rise 2 fall 5'
  }
 
}
