terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.4.1"
    }
  }
}
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