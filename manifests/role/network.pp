class optustack::role::network inherits ::optustack::role {

  class { '::optustack::profile::os_base':          } ->
  class { '::optustack::profile::neutron::router':  }

}
