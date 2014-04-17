class optustack::role::message_cache inherits ::optustack::role {
  class { '::openstack::repo::epel': } -> 
  class { '::optustack::profile::rabbitmq': }
  class { '::optustack::profile::memcached': }
}
