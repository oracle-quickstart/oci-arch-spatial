locals {
  # Group Rule to include all instances that are created in a specific compartment
  # https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managingdynamicgroups.htm#Writing
  compartment = format("instance.compartment.id='%s'", var.compartment_ocid)
}

resource "oci_identity_dynamic_group" "spatial_instance_principal_group" {
  provider    = oci.home
  compartment_id = var.tenancy_ocid
  description    = "dynamic group to allow access to resources"
  matching_rule  = "ALL { ${local.compartment} }"
  name           = "${var.service_name}-spatial-principal-group-${random_string.deploy_id.result}"

  lifecycle {
    ignore_changes = [matching_rule]
  }
}

locals {
  //We need to add this check -----v----- to avoid a Terraform equivalent to NPE in the group name fetching here -----v-----
  ss_policy_statement1 = "Allow dynamic-group ${oci_identity_dynamic_group.spatial_instance_principal_group.name} to use secret-family in tenancy"
  ss_policy_statement2 = "Allow dynamic-group ${oci_identity_dynamic_group.spatial_instance_principal_group.name} to use keys in tenancy"
  ss_policy_statement3 = "Allow service VaultSecret to use keys in tenancy" 
  ss_statements = [local.ss_policy_statement1,local.ss_policy_statement2,local.ss_policy_statement3]

  adb_policy_statement = "Allow dynamic-group ${oci_identity_dynamic_group.spatial_instance_principal_group.name} to manage autonomous-database-family in compartment id ${var.adb_compartment_ocid}" 
  adb_statements = [local.adb_policy_statement] 

  //Get a single list without empty lists, then clear out possible duplicates (eg. add_seclist, vcn_peering are true and both networks are in same compartment)
  statements = distinct(flatten([local.ss_statements,local.adb_statements]))
}

resource "oci_identity_policy" "spatial_policy" {
  provider    = oci.home
  compartment_id = var.tenancy_ocid
  description    = "policy that allows instance principal access to the CLI api from the instance"
  name           = "${var.service_name}-policy-${random_string.deploy_id.result}"
  statements     = local.statements

  freeform_tags = var.defined_tag.freeformTags
  defined_tags  = var.defined_tag.definedTags
}

