# Configure the VMware vSphere Provider
# You can use vcenter login params or simply host esxi login params
provider "vsphere" {
  # If you use a domain set your login like this "MyDomain\\MyUser"
  user           = var.esxi_user
  password       = var.esxi_password
  vsphere_server = var.esxi_vsphere_server

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

#### TEMPLATES

variable "esxi_user" {}
variable "esxi_password" {}
variable "esxi_vsphere_server" {}

# You must add template in vsphere before use it
variable "template_image" {
  default = "centos-7-template-esxi"
}

#### DC AND CLUSTER
# Set vpshere datacenter
variable "dc" {
  default = "my-litle-datacenter"
}

# Set cluster where you want deploy your vm
variable "cluster" {
  default = "my-litle-cluster"
}

# Set host where you want deploy your vm
variable "host" {
  default = "my-litle-host"
}

#### GLOBAL NETWORK PARAMS
# Virtual switch used
variable "vswitch" {
  default = "vSwitch0"
}

variable "dns_servers" {
  default = ["8.8.8.8", "8.8.4.4"]
}

#### PARAMS INSTANCES #####################################
#
#
#
variable "vm_params" {
  default = {
    vcpu = "2"
    ram  = "4096"
    # You can't set a datastore name with interspace
    disk_datastore = "datastore_test"
    disk_size      = "15"
  }
}

variable "network_params" {
  default = {
    domain        = "test.local"
    label         = "http_network"
    vlan_id       = "1"
    base_address  = "192.168.1."
    prefix_length = "24"
    gateway       = "192.168.1.254"
  }
}

# Define the root hostname of http instance
# The root is incrementing for each instance create
# e.g: a root name with "frt0" will give:
# frt01 for the first instance
# ftp02 for the seconde instance etc...
#
variable "base_hostname" {
  default = "frt0"
}

# Set number of instances
# WARNING CHANGING THIS VALUE ON STACK ALREADY CREATE WILL BE REMOVE AND RE-CREATE ALL INSTANCES
variable "vm_desired_capacity" {
  default = "1"
}
