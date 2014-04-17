class optustack::profile::db_glance {

  class { 'glance::db::mysql':
    password      => hiera('optustack::database::service_password'),
    allowed_hosts => '%',
    mysql_module  => '2.2',
  }
 

}
