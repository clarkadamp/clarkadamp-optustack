class optustack::profile::nova::compute {
 
  class { '::nova':
    sql_connection     => "mysql://nova:service_password@db.openstack.home/nova",
    glance_api_servers => "http://api-internal.openstack.home:9292",
    memcached_servers  => ["slb01.openstack.home:11211","slb02.openstack.home:11211"],
    rabbit_hosts       => hiera('optustack::rabbitmq::slb'),
    rabbit_userid      => hiera('optustack::rabbitmq::userid'),
    rabbit_password    => hiera('optustack::rabbitmq::password'),
    debug              => hiera('optustack::nova::debug'),
    verbose            => hiera('optustack::nova::verbose'),
    mysql_module       => '2.2',
  } 

  class { '::nova::api':
    admin_password                       => hiera('optustack::nova::password'),
    auth_host                            => "api-internal.openstack.home",
    enabled                              => false,
    neutron_metadata_proxy_shared_secret => hiera('optustack::neutron::shared_secret'),
  }

  class { '::nova::vncproxy':
    enabled => false,
  } 

  class { [
    'nova::scheduler',
    'nova::objectstore',
    'nova::cert',
    'nova::consoleauth',
    'nova::conductor'
  ]:
    enabled => false,
  }

  class { '::nova::compute':
    enabled                       => true,
    vnc_enabled                   => true,
    vncserver_proxyclient_address => $ipaddress_eth0,
    vncproxy_host                 => "vnc.openstack.home",
  }

  class { '::nova::compute::neutron': }

  class { '::nova::network::neutron':
    neutron_admin_password => hiera('optustack::neutron::password'),
    neutron_region_name    => hiera('optustack::region'),
    neutron_admin_auth_url => "http://api-internal.openstack.home:35357/v2.0",
    neutron_url            => "http://api-internal.openstack.home:9696",
  }

  class { '::nova::compute::libvirt':
    libvirt_type     => hiera('optustack::nova::libvirt_type'),
    vncserver_listen => "0.0.0.0",
  }

  file { '/etc/libvirt/qemu.conf':
    ensure => present,
    source => 'puppet:///modules/optustack/qemu.conf',
    mode   => '0644',
    notify => Service['libvirt'],
  }

  file { '/etc/default/libvirt-bin':
    ensure => present,
    source => 'puppet:///modules/optustack/libvirt-bin',
    mode   => '0644',
    notify => Service['libvirt'],
  }

  file { '/etc/libvirt/libvirtd.conf':
    ensure => present,
    source => 'puppet:///modules/optustack/libvirtd.conf',
    mode   => '0644',
    notify => Service['libvirt'],
  }

  Package['libvirt'] -> File['/etc/libvirt/qemu.conf']

  nova_config { 'DEFAULT/libvirt_images_type':          value => 'rbd' }
  nova_config { 'DEFAULT/libvirt_images_rbd_pool':      value => 'volumes' }
  nova_config { 'DEFAULT/libvirt_images_rbd_ceph_conf': value => '/etc/ceph/ceph.conf' }
  nova_config { 'DEFAULT/rbd_user':                     value => 'cinder' }
  nova_config { 'DEFAULT/rbd_secret_uuid':              value => '457eb676-33da-42ec-9a8c-9293d545c337' }

  
  nova_config { 'DEFAULT/libvirt_inject_password':      value => 'false' }
  nova_config { 'DEFAULT/libvirt_inject_key':           value => 'false' }
  nova_config { 'DEFAULT/libvirt_inject_partition':     value => '-2' }

  # Deal with https://bugs.launchpad.net/nova/+bug/1233188
  file { '/usr/share/pyshared/nova/virt/libvirt/imagebackend.py':
    ensure  => present,
    source  => 'puppet:///modules/optustack/imagebackend.py',
    mode    => '0644',
    require => Package ['python-nova'],
    before  => Service['nova-compute'], 
  }

  $SECRET_UUID = hiera('optustack::ceph::cinder::rbd_secret_uuid') 
  $CINDER_KEY  = hiera('optustack::ceph::test_cluster::cinder_key')
  exec { "virsh_secret_${SECRET_UUID}":
    path      => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
    command   => "/bin/true # comment to satisfy puppet syntax requirements
cat > /tmp/secret.xml <<EOF
<secret ephemeral='no' private='no'>
  <uuid>${SECRET_UUID}</uuid>
  <usage type='ceph'>
    <name>client.cinder secret</name>
  </usage>
</secret>
EOF
virsh secret-define --file /tmp/secret.xml
virsh secret-set-value --secret ${SECRET_UUID} --base64 ${CINDER_KEY}",
    logoutput => true,
    before  => Service['nova-compute'],
    unless  => "virsh secret-get-value ${SECRET_UUID} | grep ${CINDER_KEY}"
  }

}
