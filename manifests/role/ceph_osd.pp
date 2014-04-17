class optustack::role::ceph_osd inherits ::optustack::role {

  class { '::optustack::profile::ceph_base': } -> 
  class { '::optustack::profile::ceph_osd': } 

}
