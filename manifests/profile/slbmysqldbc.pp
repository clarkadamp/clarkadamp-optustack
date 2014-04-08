class optustack::profile::slbmysqldbc {

  class {'galera::repo': } ->
  class { 'mysql::client': 
    package_name => 'MariaDB-client'
  } ->

  haproxy::listen { 'mysql_cluster':
    ipaddress => '0.0.0.0',
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
