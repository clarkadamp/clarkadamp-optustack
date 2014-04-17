class optustack::role::ceph_monitor inherits ::optustack::role {

  class { '::optustack::profile::ceph_base': } -> 
  class { '::optustack::profile::ceph_mon': } 

}
