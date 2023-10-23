output "datacenter_id" {
  value = data.vsphere_datacenter.target_dc.id
}

output "cluster_id" {
  value = data.vsphere_compute_cluster.target_cluster.id
}

output "datastore_cluster_id" {
  value = data.vsphere_datastore_cluster.datastore_cluster.id
}

output "portgroup_id" {
  value = data.vsphere_network.target_network.id
}