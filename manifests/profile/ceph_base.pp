class optustack::profile::ceph_base {

  $admin_key                   = hiera('optustack::ceph::test_cluster::admin_key') 
  $glance_key                  = hiera('optustack::ceph::test_cluster::glance_key') 
  $cinder_key                  = hiera('optustack::ceph::test_cluster::cinder_key') 
  $cinder_backup_key           = hiera('optustack::ceph::test_cluster::cinder_backup_key') 

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

  ceph_config {
    'global/rbd_cache':  value => 'true';
  }


  file { '/etc/ceph/ceph.client.admin.keyring':
    mode        => '0444',
    content     => "[client.admin]\n        key = ${admin_key}\n",
    require     => Package['ceph'],
  }

  file { '/etc/ceph/ceph.client.glance.keyring':
    mode        => '0444',
    content     => "[client.glance]\n        key = ${glance_key}\n",
    require     => Package['ceph'],
  }
 
  file { '/etc/ceph/ceph.client.cinder.keyring':
    mode        => '0444',
    content     => "[client.cinder]\n        key = ${cinder_key}\n",
    require     => Package['ceph'],
  }
 
  file { '/etc/ceph/ceph.client.cinder-backup.keyring':
    mode        => '0444',
    content     => "[client.cinder-backup]\n        key = ${cinder_backup_key}\n",
    require     => Package['ceph'],
  }

} 
