class optustack::role::compute inherits ::optustack::role {

  class { '::optustack::profile::os_base':              } ->
  class { '::optustack::profile::ceph_base':            } ->
  class { '::optustack::profile::neutron::agent':       } ->
  class { '::optustack::profile::nova::compute':        } 
}
