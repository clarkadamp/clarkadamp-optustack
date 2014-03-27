class optustack::role::slb inherits ::optustack::role {

  class { '::optustack::profile::slb': } 
  class { '::optustack::profile::slbmysqldbc': }

}
