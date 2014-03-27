class optustack::role::admin inherits ::optustack::role {

  class { '::optustack::profile::admin': }

}
