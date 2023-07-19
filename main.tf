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
