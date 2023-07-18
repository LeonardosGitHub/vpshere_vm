data "vsphere_datacenter" "datacenter" {
  name = "dc-01"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = "localhost.localdomain"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "mgmt_network" {
  name          = "Lab249"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "data_network" {
  name          = "Lab248"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "default" {
  name          = "localhost.localdomain/Resources"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# data "vsphere_resource_pool" "default" {
#   name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
#   datacenter_id = data.vsphere_datacenter.datacenter.id
# }


## Deployment of VM from Local OVF
resource "vsphere_virtual_machine" "vmFromLocalOvf" {
  name                 = "local-foo"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "../../BIG-IQ-8.2.0.1-0.0.97-mod.vmware.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.mgmt_network.id
      "Network 2" = data.vsphere_network.data_network.id
    }
  }
  vapp {
    properties = {
      "guestinfo.hostname"     = "local-foo.example.com"
    }
  }
}
