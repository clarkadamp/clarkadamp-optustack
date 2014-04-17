class optustack::profile::slbmemcached {

  haproxy::listen { 'memcached_cluster':
    ipaddress => '0.0.0.0',
    ports     => '11211',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }

}
