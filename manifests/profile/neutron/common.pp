class optustack::profile::neutron::common {
 
  $data_device  = hiera('optustack::api::interface::data')
  $data_address = getvar("ipaddress_${data_device}")

 
  class { '::neutron':
    verbose               => hiera('optustack::keystone::verbose'),
    debug                 => hiera('optustack::keystone::debug'),
    rabbit_hosts          => hiera('optustack::rabbitmq::slb'),
    rabbit_user           => hiera('optustack::rabbitmq::userid'),
    rabbit_password       => hiera('optustack::rabbitmq::password'),
    allow_overlapping_ips => true,
    core_plugin           => 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2',
  }

  $tunnel_type = hiera('optustack::neutron::tunnel_type')

  class { '::neutron::agents::ovs':
    enable_tunneling => 'True',
    local_ip         => $data_address,
    enabled          => true,
    tunnel_types     => [$tunnel_type,],
  }

  class  { '::neutron::plugins::ovs':
    tenant_network_type => $tunnel_type,
  }

}
