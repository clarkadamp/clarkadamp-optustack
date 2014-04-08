class optustack::role::slb inherits ::optustack::role {

  class { '::optustack::profile::slb': } ->  
  class { '::optustack::profile::slbmysqldbc': } ->
  class { '::optustack::profile::slbmemcached': } ->
  class { '::optustack::profile::slbrabbitmq': } ->
  class { '::optustack::profile::slbosapi': }

}
