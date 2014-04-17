class optustack::profile::slbrabbitmq {

  haproxy::listen { 'rabbitmq_cluster':
    ipaddress => '0.0.0.0',
    ports     => '5672',
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
