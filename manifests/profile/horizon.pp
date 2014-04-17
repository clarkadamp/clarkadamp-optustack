class optustack::profile::horizon {

  #class { 'memcached':
  #  listen_ip => '127.0.0.1',
  #  tcp_port  => '11211',
  #  udp_port  => '11211',
  #}

  class { '::horizon':
    keystone_url          => 'http://api-internal.openstack.home:5000/v2.0',
    cache_server_ip       => 'slb01.openstack.home',
    cache_server_port     => '11211',
    secret_key            => '12345',
    swift                 => false,
    django_debug          => 'True',
    api_result_limit      => '2000',
    available_regions => [
      ['http://api-internal.openstack.home:5000/v2.0', 'homelab'],
    ]
 }

  #@@haproxy::balancermember { "${fqdn}_cinder_api_cluster":
  #  listening_service => 'cinder_api_cluster',
  #  server_names      => $fqdn,
  #  ipaddresses       => $ipaddress_eth0,
  #  ports             => '8776',
  #  options           => 'check inter 2000 rise 2 fall 5'
  #}


}
