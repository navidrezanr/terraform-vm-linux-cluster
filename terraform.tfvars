# Provider
provider_vsphere_host     = "vcenter ip address or FQDN"
provider_vsphere_user     = "vcenter username"
provider_vsphere_password = "vcenter password"

# Infrastructure
deploy_vsphere_datacenter        = "Datacenter Name"
deploy_vsphere_cluster           = "Cluster Name"
deploy_vsphere_datastore_cluster = "Datastore Cluster Name"
deploy_vsphere_folder            = "Path to folder"
deploy_vsphere_network           = "Network"

# Guest
guest_name_prefix  = "TST"
guest_template     = "Template Name"
guest_vcpu         = "8"
cores_per_socket   = "4"
guest_memory       = "2048"
guest_ipv4_netmask = "24"
guest_ipv4_gateway = "192.168.10.254"
guest_dns_servers  = ["10.10.10.1", "10.10.10.2"]


# Worker(s)
worker_ips = {
  "0" = "192.168.10.01"
  "1" = "192.168.10.02"
  "2" = "192.168.10.03"
  "3" = "192.168.10.04"
}
