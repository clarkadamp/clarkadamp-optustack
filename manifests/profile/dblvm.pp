class optustack::profile::dblvm(
  $object_prefix   = "mysqldata",
  $physical_device ,
  $fstype          = "ext3",
  $size            = "10G" ,
  $mountpoint      = "/var/lib/mysql"
) {

  # create and mount the volume
  lvm::volume { "${object_prefix}_lv":
    ensure => present,
    vg     => "${object_prefix}_vg",
    pv     => $physical_device,
    fstype => $fstype,
    size   => $size,
  } ->
  file { $mountpoint:
    ensure => directory
  } ->
  mount { $mountpoint:
    ensure  => mounted,
    device  => "/dev/mapper/${object_prefix}_vg-${object_prefix}_lv",
    fstype  => $fstype,
    options => "defaults",
    atboot  => "true",
  }
	

}
