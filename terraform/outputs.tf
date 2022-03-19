locals {
  instance_ip     = local.is_public_subnet ? oci_core_instance.simple-vm.public_ip : oci_core_instance.simple-vm.private_ip
  app_url         = format("https://%s:%s/spatialstudio", local.instance_ip, var.console_ssl_port)
}

###
# compute.tf outputs
###

output "instance_id" {
  value = oci_core_instance.simple-vm.id
}

output "instance_name" {
  value = oci_core_instance.simple-vm.display_name
}

output "instance_public_ip" {
  value = oci_core_instance.simple-vm.public_ip
}

output "instance_private_ip" {
  value = oci_core_instance.simple-vm.private_ip
}

output "instance_https_url" {
  value = local.app_url
}

###
# network.tf outputs
###

output "vcn_id" {
  value = ! local.use_existing_network ? join("", oci_core_vcn.simple.*.id) : var.existing_vcn_id
}

output "subnet_id" {
  value = ! local.use_existing_network ? join("", oci_core_subnet.simple_subnet.*.id) : var.subnet_id
}

output "vcn_cidr_block" {
  value = ! local.use_existing_network ? join("", oci_core_vcn.simple.*.cidr_block) : var.vcn_cidr
}

output "nsg_id" {
  value = join("", oci_core_network_security_group.simple_nsg.*.id)
}

###
# database.tf outputs
###

output "adb_password" {
  value = random_string.autonomous_database_admin_password.result
  sensitive = true
}

output "adb_id" {
  value = oci_database_autonomous_database.sgtech_autonomous_database.id
}

###
# Comments
###

output "certificates_note" {
  value = "To configure your HTTPS certificate, see https://www.eclipse.org/jetty/documentation/jetty-9/index.html#loading-keys-and-certificates."
}

output "comments" {
  value = "Please wait 3-4 minutes after the deployment job has succeded before launching Spatial Studio"
}

