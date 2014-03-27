class optustack::profile::database {

  class { 'galera::server': 
    require => Class['galera::repo'],
  } 
  class {'galera::monitor':
    monitor_username => 'mon_user',
    monitor_password => 'mon_pass'
  }

  @@haproxy::balancermember { $fqdn:
    listening_service => 'mysql_dbc',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '3306',
    options           => 'check port 9200 inter 2000 rise 2 fall 5'
  }

}
