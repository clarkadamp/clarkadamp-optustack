class optustack::profile::database {

  class { '::galera::server': 
    wsrep_sst_method => 'rsync'
  }
  
  

  class { 'galera::monitor':
    monitor_username => 'mon_user',
    monitor_password => 'mon_pass'
  }

  @@haproxy::balancermember { "${fqdn}_mysql":
    listening_service => 'mysql_cluster',
    server_names      => $fqdn,
    ipaddresses       => $ipaddress_eth0,
    ports             => '3306',
    options           => 'check port 9200 inter 2000 rise 2 fall 5'
  }

}
