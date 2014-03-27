class optustack::profile::slbmysqldbc {

  class {'galera::repo': } ->
  class { 'mysql': } ->

  class { 'haproxy': 
    http_stats_enable => true,
  }

  haproxy::listen { 'mysql_dbc':
    ipaddress => $ipaddress_eth0,
    ports     => '3306',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'httpchk',
      ],
      'balance' => 'leastconn'
    },
  }

}
