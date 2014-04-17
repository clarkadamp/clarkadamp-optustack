class optustack::profile::db_nova {

  class { 'nova::db::mysql':
    password      => hiera('optustack::database::service_password'),
    allowed_hosts => '%',
    mysql_module  => '2.2',
  }
 

}
