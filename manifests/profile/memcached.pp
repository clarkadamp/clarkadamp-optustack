class optustack::profile::memcached (
  $listen_interface = hiera('optustack::memcached::interface' , 'eth0' ) 
){

  class { '::memcached':
    listen_ip => getvar("ipaddress_${listen_interface}"),
    tcp_port  => '11211',
    udp_port  => '11211',
  }

  @@haproxy::balancermember { "${fqdn}_memcached":
    listening_service => 'memcached_cluster',
    server_names      => $fqdn,
    ipaddresses       => getvar("ipaddress_${listen_interface}"),
    ports             => '11211',
    options           => 'check inter 2000 rise 2 fall 5'
  }

}
