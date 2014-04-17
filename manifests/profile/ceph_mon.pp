class optustack::profile::ceph_mon {

  ceph::mon { $hostname: 
    public_addr  => $::ipaddress_eth0,
    cluster      => hiera('optustack::ceph::test_cluster::name' , undef ),
    key          => hiera('optustack::ceph::test_cluster::mon_key')
  }

}
