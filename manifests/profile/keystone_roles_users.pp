class optustack::profile::keystone_roles_users {

  class { '::keystone::roles::admin':
    email        => hiera('optustack::keystone::admin_email'),
    password     => hiera('optustack::keystone::admin_password'),
    admin_tenant => 'admin',
  }

  class { 'keystone::endpoint':
    public_address   => hiera('optustack::endpoint::address:public'),
    admin_address    => hiera('optustack::endpoint::address:admin'),
    internal_address => hiera('optustack::endpoint::address:internal'),
    region           => hiera('optustack::region'),
  }

  class  { '::glance::keystone::auth':
    password         => hiera('optustack::glance::password'),
    public_address   => hiera('optustack::endpoint::address:public'),
    admin_address    => hiera('optustack::endpoint::address:admin'),
    internal_address => hiera('optustack::endpoint::address:internal'),
    region           => hiera('optustack::region'),
  }


  class { '::neutron::keystone::auth':
    password         => hiera('optustack::neutron::password'),
    public_address   => hiera('optustack::endpoint::address:public'),
    admin_address    => hiera('optustack::endpoint::address:admin'),
    internal_address => hiera('optustack::endpoint::address:internal'),
    region           => hiera('optustack::region'),
  }

  class { '::nova::keystone::auth':
    password         => hiera('optustack::nova::password'),
    public_address   => hiera('optustack::endpoint::address:public'),
    admin_address    => hiera('optustack::endpoint::address:admin'),
    internal_address => hiera('optustack::endpoint::address:internal'),
    region           => hiera('optustack::region'),
  }

  class { '::cinder::keystone::auth':
    password         => hiera('optustack::cinder::password'),
    public_address   => hiera('optustack::endpoint::address:public'),
    admin_address    => hiera('optustack::endpoint::address:admin'),
    internal_address => hiera('optustack::endpoint::address:internal'),
    region           => hiera('optustack::region'),
  }


  $tenants = hiera('optustack::tenants')
  $users = hiera('optustack::users')
  create_resources('optustack::resources::tenant', $tenants)
  create_resources('optustack::resources::user', $users)

}
