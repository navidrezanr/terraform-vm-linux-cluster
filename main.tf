##### Terraform Initialization
terraform {
  required_version = ">= 0.13"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.2.0"
    }
  }
}

##### Provider
provider "vsphere" {
  user           = var.provider_vsphere_user
  password       = var.provider_vsphere_password
  vsphere_server = var.provider_vsphere_host

  # if you have a self-signed cert
  allow_unverified_ssl = true
}


##### Data sources
data "vsphere_datacenter" "target_dc" {
  name = var.deploy_vsphere_datacenter
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = var.deploy_vsphere_datastore_cluster
  datacenter_id = data.vsphere_datacenter.target_dc.id
}

data "vsphere_compute_cluster" "target_cluster" {
  name          = var.deploy_vsphere_cluster
  datacenter_id = data.vsphere_datacenter.target_dc.id
}

data "vsphere_network" "target_network" {
  name          = var.deploy_vsphere_network
  datacenter_id = data.vsphere_datacenter.target_dc.id
}

data "vsphere_virtual_machine" "source_template" {
  name          = var.guest_template
  datacenter_id = data.vsphere_datacenter.target_dc.id
}


# Clones multiple Linux VMs from a template
resource "vsphere_virtual_machine" "kubernetes_workers" {
  count                = length(var.worker_ips)
  name                 = "${var.guest_name_prefix}TST-0${count.index + 1}"
  resource_pool_id     = data.vsphere_compute_cluster.target_cluster.resource_pool_id
  datastore_cluster_id = data.vsphere_datastore_cluster.datastore_cluster.id
  folder               = var.deploy_vsphere_folder
  firmware             = var.guest_firmware

  num_cpus             = var.guest_vcpu
  num_cores_per_socket = var.cores_per_socket
  memory               = var.guest_memory
  guest_id             = data.vsphere_virtual_machine.source_template.guest_id

  scsi_type = data.vsphere_virtual_machine.source_template.scsi_type


  network_interface {
    network_id   = data.vsphere_network.target_network.id
    adapter_type = data.vsphere_virtual_machine.source_template.network_interface_types[0]
  }


  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.source_template.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.source_template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.source_template.disks[0].thin_provisioned

  }

  clone {
    template_uuid = data.vsphere_virtual_machine.source_template.id

    customize {
      linux_options {
        host_name = "${var.guest_name_prefix}TST-0${count.index + 1}"
        domain    = "test.tech"
      }

      network_interface {
        ipv4_address = lookup(var.worker_ips, count.index)
        ipv4_netmask = var.guest_ipv4_netmask
        dns_server_list = var.guest_dns_servers
      }

      ipv4_gateway = var.guest_ipv4_gateway
      dns_server_list = var.guest_dns_servers
    }
  }

  lifecycle {
    ignore_changes = [annotation]
  }
}
