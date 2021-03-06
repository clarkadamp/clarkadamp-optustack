class optustack::role::database inherits ::optustack::role {

  class { '::optustack::profile::dblvm': }
  class { '::optustack::profile::database': }
#  class { '::optustack::profile::db_keystone': } ->
#  class { '::optustack::profile::db_glance': } ->
#  class { '::optustack::profile::db_neutron': } ->
#  class { '::optustack::profile::db_nova': } ->
#  class { '::optustack::profile::db_cinder': }


  mysql_user { 'aclark@%':
    ensure                   => 'present',
    max_connections_per_hour => '0',
    max_queries_per_hour     => '0',
    max_updates_per_hour     => '0',
    max_user_connections     => '0',
    require                  => Class [ '::optustack::profile::database' ],
  }

  mysql_grant { 'aclark@%/*.*':
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => '*.*',
    user       => 'aclark@%',
    require                  => Class [ '::optustack::profile::database' ],
  }

}
