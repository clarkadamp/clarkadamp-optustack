class optustack::role::database inherits ::optustack::role {

  class { '::optustack::profile::dblvm': } ->
  class { '::optustack::profile::database': } 

}
