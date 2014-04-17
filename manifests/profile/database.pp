class optustack::profile::database (
  $services_internal_interface = hiera( 'optustack::interface::database::services_internal'                ),
  $master_ips                  = hiera( 'optustack::galera::master_ips'                     , false        ),
  $monitor_username            = hiera( 'optustack::galera::monitor::username'              , 'mon_user'   ),
  $monitor_password            = hiera( 'optustack::galera::monitor::password'              , 'mon_pass'   ),
  $wsrep_sst_username          = hiera( 'optustack::galera::wsrep_sst::username'            , 'wsrep_user' ),
  $wsrep_sst_password          = hiera( 'optustack::galera::wsrep_sst::password'            , 'wsrep_pass' ),
  $wsrep_sst_access            = hiera( 'optustack::galera::wsrep_sst::access'              , '%'          ),
) {

  class { '::galera::server': 
    master_ip           => $master_ips,
    wsrep_sst_username  => $wsrep_sst_username,
    wsrep_sst_password  => $wsrep_sst_password,
    wsrep_sst_access    => $wsrep_sst_access,
  }
  
  class { 'galera::monitor':
    monitor_username => $monitor_username,
    monitor_password => $monitor_password,
  }

  $service_address = getvar("ipaddress_${services_internal_interface}")

  @@haproxy::balancermember { "${fqdn}_mysql":
    listening_service => 'mysql_cluster',
    server_names      => $fqdn,
    ipaddresses       => $service_address,
    ports             => '3306',
    options           => 'check port 9200 inter 2000 rise 2 fall 5'
  }

}
