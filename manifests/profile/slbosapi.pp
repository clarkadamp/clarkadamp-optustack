class optustack::profile::slbosapi {

  haproxy::listen { 'keystone_admin_cluster':
    ipaddress => '0.0.0.0',
    ports     => '35357',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'httpchk',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }

  haproxy::listen { 'keystone_public_internal_cluster':
    ipaddress => '0.0.0.0',
    ports     => '5000',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'httpchk',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }

  haproxy::listen { 'glance_api_cluster':
    ipaddress => '0.0.0.0',
    ports     => '9292',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'httpchk',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }

  haproxy::listen { 'glance_registry_cluster':
    ipaddress => '0.0.0.0',
    ports     => '9191',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }


  haproxy::listen { 'neutron_api_cluster':
    ipaddress => '0.0.0.0',
    ports     => '9696',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'httpchk',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }

  haproxy::listen { 'nova_ec2_api_cluster':
    ipaddress => '0.0.0.0',
    ports     => '8773',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }

  haproxy::listen { 'nova_metadata_api_cluster':
    ipaddress => '0.0.0.0',
    ports     => '8775',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }

  haproxy::listen { 'nova_osapi_cluster':
    ipaddress => '0.0.0.0',
    ports     => '8774',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'httpchk',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }

  haproxy::listen { 'novnc_cluster':
    ipaddress => '0.0.0.0',
    ports     => '6080',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }

  haproxy::listen { 'cinder_api_cluster':
    ipaddress => '0.0.0.0',
    ports     => '8776',
    mode      => 'tcp',
    options   => {
      'option'  => [
        'tcpka',
        'httpchk',
        'tcplog',
      ],
      'balance' => 'source'
    },
  }

}
