class optustack::resources::connectors {

  $api_address = hiera('optustack::database::address')
  $password    = hiera('optustack::database::service_password')

  $keystone    = "mysql://keystone:${password}@${api_address}/keystone"
  $cinder      = "mysql://cinder:${password}@${api_address}/cinder"
  $glance      = "mysql://glance:${password}@${api_address}/glance"
  $nova        = "mysql://nova:${password}@${api_address}/nova"
  $neutron     = "mysql://neutron:${password}@${api_address}/neutron"
  $heat        = "mysql://heat:${password}@${api_address}/heat"

}
