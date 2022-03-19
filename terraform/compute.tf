resource "oci_core_instance" "simple-vm" {
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${var.service_name}-instance-${random_string.deploy_id.result}"
  shape               = var.instance_shape.instanceShape

  dynamic "shape_config" {
    for_each = local.is_flex_shape
      content {
        ocpus         = var.instance_shape.ocpus
        memory_in_gbs = var.instance_shape.memory
      }
  }

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.subnet_id : oci_core_subnet.simple_subnet[0].id
    display_name           = "primaryvnic"
    assign_public_ip       = local.is_public_subnet
    hostname_label         = "${var.service_name}-instance-${random_string.deploy_id.result}"
    skip_source_dest_check = false
    nsg_ids                = [oci_core_network_security_group.simple_nsg.id]
  }

  source_details {
    source_type = "image"
    #use a marketplace image or custom image:
    source_id   = local.compute_image_id
  }

  lifecycle {
    ignore_changes = [
      source_details[0].source_id
    ]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("./scripts/bootstrap.sh"))

    server_ssl_port = var.console_ssl_port
    use_secrets     = var.use_secrets
    admin_user = var.admin_user
    admin_pwd = local.admin_pwd
    #This random string will be used for the new database's admin and sgtech users
    dba_password=random_string.autonomous_database_admin_password.result

    #required, to distinguish if DB is new or an existing one will be used, set this to false and pass an empty adb_id 
    #to skip database metadata repository configuration
    create_adb_user = true 
    #optional, if passed a datasource will be configured for studio
    adb_id = oci_database_autonomous_database.sgtech_autonomous_database.id
    #optional, default is low
    adb_level = var.adb_level 
    #optional
    adb_wallet_path = "/u01/oracle/wallet"
    #required when using existing adb, optional for new one and will be defaulted to sgtech
    adb_user = var.adb_user
    #required when using existing adb, optional for new one and will be defaulted to admin's
    adb_user_password_ocid = var.adb_user_password_ocid 
    #required to set max/min connections for studio
    is_free_adb = local.is_free_adb

    debug_enabled=true

  }

  freeform_tags = var.defined_tag.freeformTags
  defined_tags  = var.defined_tag.definedTags

  depends_on = [
    oci_identity_policy.spatial_policy
  ]
}
