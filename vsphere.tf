
# ############ HTTP VM ############
# #
# #
# resource "vsphere_virtual_machine" "http_vm" {
#   count            = var.vm_desired_capacity
#   name             = "${var.base_hostname}${count.index + 1}"
#   num_cpus         = var.vm_params["vcpu"]
#   memory           = var.vm_params["ram"]
# #   datastore_id     = data.vsphere_datastore.datastore_http.id
# #   host_system_id   = data.vsphere_host.host.id
# #   resource_pool_id = data.vsphere_resource_pool.pool.id
# #   guest_id         = data.vsphere_virtual_machine.template.guest_id
# #   scsi_type        = data.vsphere_virtual_machine.template.scsi_type

#   # Configure network interface
#   network_interface {
#     #network_id = data.vsphere_network.network_http.id
#   }

#   disk {
#     name = "${var.base_hostname}${count.index + 1}.vmdk"
#     size = var.vm_params["disk_size"]
#   }

#   # Define template and customisation params
#   clone {
#     template_uuid = data.vsphere_virtual_machine.template.id

#     customize {
#       linux_options {
#         host_name = "${var.base_hostname}${count.index + 1}"
#         domain    = var.network_params["domain"]
#       }

#       network_interface {
#         ipv4_address    = "${var.network_params["base_address"]}${count.index + 10}"
#         ipv4_netmask    = var.network_params["prefix_length"]
#         dns_server_list = var.dns_servers
#       }

#       ipv4_gateway = var.network_params["gateway"]
#     }
#   }
#   depends_on = [vsphere_host_port_group.http_port]
# }

data "vsphere_datacenter" "datacenter" {
  name = "dc-01"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore-01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "cluster-01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "default" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = "esxi-01.example.com"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "172.16.11.0"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# ## Deployment of VM from Remote OVF
# resource "vsphere_virtual_machine" "vmFromRemoteOvf" {
#   name                 = "remote-foo"
#   datacenter_id        = data.vsphere_datacenter.datacenter.id
#   datastore_id         = data.vsphere_datastore.datastore.id
#   host_system_id       = data.vsphere_host.host.id
#   resource_pool_id     = data.vsphere_resource_pool.default.id

#   wait_for_guest_net_timeout = 0
#   wait_for_guest_ip_timeout  = 0

#   ovf_deploy {
#     allow_unverified_ssl_cert = false
#     remote_ovf_url            = "https://example.com/foo.ova"
#     disk_provisioning         = "thin"
#     ip_protocol               = "IPV4"
#     ip_allocation_policy      = "STATIC_MANUAL"
#     ovf_network_map = {
#       "Network 1" = data.vsphere_network.network.id
#       "Network 2" = data.vsphere_network.network.id
#     }
#   }
#   vapp {
#     properties = {
#       "guestinfo.hostname"     = "remote-foo.example.com",
#       "guestinfo.ipaddress"    = "172.16.11.101",
#       "guestinfo.netmask"      = "255.255.255.0",
#       "guestinfo.gateway"      = "172.16.11.1",
#       "guestinfo.dns"          = "172.16.11.4",
#       "guestinfo.domain"       = "example.com",
#       "guestinfo.ntp"          = "ntp.example.com",
#       "guestinfo.password"     = "VMware1!",
#       "guestinfo.ssh"          = "True"
#     }
#   }
# }