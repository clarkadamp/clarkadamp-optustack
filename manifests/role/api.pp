class optustack::role::api inherits ::optustack::role {

  class { '::optustack::profile::os_base':              } ->
  class { '::optustack::profile::ceph_base':            } ->
  class { '::optustack::profile::keystone':             } ->
  class { '::optustack::profile::keystone_roles_users': } ->
  class { '::optustack::profile::glance_api_registry':  } ->
  class { '::optustack::profile::neutron::server':      } ->
  class { '::optustack::profile::nova::api':            } ->
  class { '::optustack::profile::cinder':               } ->
  class { '::optustack::profile::horizon':              }

}
