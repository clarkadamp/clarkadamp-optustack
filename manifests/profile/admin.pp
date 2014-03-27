class optustack::profile::admin {

  class {'galera::repo': } ->
  class { 'mysql': }

}
