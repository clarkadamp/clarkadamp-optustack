class optustack::profile::admin {

  class {'galera::repo': } ->
  class { 'mysql::client': 
    package_name => 'mariadb-client'
  }
  
  $extra_packages = hiera( extra_packages , [] )

  class {'optustack::profile::os_base': } -> 
  package { $extra_packages:
        ensure => installed
  }  
 
  class { '::openstack::auth_file':
    admin_password  => hiera('optustack::keystone::admin_password'),
    region_name     => hiera('optustack::region'),
    controller_node => "api.openstack.home",
  }


  class{ 'ceph::repo': } ->
  class{ 'ceph':       
    fsid                       => hiera('optustack::ceph::test_cluster::fsid'),
    osd_pool_default_pg_num    => hiera('optustack::ceph::test_cluster::pg_num'),
    osd_pool_default_pgp_num   => hiera('optustack::ceph::test_cluster::pg_num'),
    osd_pool_default_size      => hiera('optustack::ceph::test_cluster::replicas'),
    osd_pool_default_min_size  => hiera('optustack::ceph::test_cluster::min_replicas'),
    mon_host                   => join( hiera('optustack::ceph::test_cluster::mon_hosts') , "," ),
    mon_initial_members        => join( hiera('optustack::ceph::test_cluster::monitors') , "," ),
    public_network             => hiera('optustack::ceph::test_cluster::nw_public', undef ),
    cluster_network            => hiera('optustack::ceph::test_cluster::nw_cluster', undef ),
    
  }

  include ::glance::client
  include ::nova::client
  include ::cinder::client
  
  
  package{ 'python-neutronclient':
    ensure => present,
  }

}
