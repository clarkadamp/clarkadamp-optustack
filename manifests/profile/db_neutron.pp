class optustack::profile::db_neutron {

  class { 'neutron::db::mysql':
    password      => hiera('optustack::database::service_password'),
    allowed_hosts => '%',
    mysql_module  => '2.2',
  }
 

}
