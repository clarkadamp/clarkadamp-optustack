class optustack::profile::slb {
 
  include keepalived  

  keepalived::vrrp::script { 'check_haproxy':
    script => '/usr/bin/killall -0 haproxy',
  }

  keepalived::vrrp::instance { 'api':
    interface         => hiera('optustack::slb::api_interface' , 'eth0' ) ,
    state             => hiera('optustack::slb::api_state' ) ,
    virtual_router_id => hiera('optustack::slb::api_virtual_router_id' , '1' ),
    priority          => hiera('optustack::slb::api_priority' ) ,
    auth_type         => 'PASS',
    auth_pass         => hiera('optustack::slb::api_auth_pass:' , 'vrrpauth' ) ,
    virtual_ipaddress => hiera('optustack::slb::api_virtual_ip' ) ,
    track_script      => 'check_haproxy',
  }

}
