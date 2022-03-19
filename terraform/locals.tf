locals {

  # Logic to use AD name provided by user input on ORM or to lookup for the AD name when running from CLI
  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)

  # local.use_existing_network referenced in network.tf
  use_existing_network = var.vcn_strategy == var.vcn_strategy_enum["USE_VCN"] ? true : false

  # local.is_public_subnet referenced in compute.tf
  is_public_subnet = true

  # Logic to choose a custom image or a marketplace image.
  compute_image_id = var.instance_image_id

  # Logic to use password field or ocid secret password
  admin_pwd = var.use_secrets ? var.admin_pwd_ocid : var.admin_pwd

  # Local to control subscription to Marketplace image.
  mp_subscription_enabled = var.use_marketplace_image ? 1 : 0

  # Marketplace Image listing variables - required for subscription only
  listing_id               = var.mp_listing_id
  listing_resource_id      = local.compute_image_id
  listing_resource_version = var.mp_listing_resource_version

  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard3.Flex",
    "VM.Optimized3.Flex"
  ]

  compute_arm_shapes = [
    "VM.Standard.A1.Flex"
  ]

  # local.is_flex_shape referenced in compute.tf
  is_flex_shape = contains(local.compute_flexible_shapes,var.instance_shape.instanceShape) ? [1] : []
  
  is_arm_shape = contains(local.compute_arm_shapes,var.instance_shape.instanceShape) ? true : false

  # Below check will force out a runtime error if the selected shape is not in the supported oci_images.tf marketplace images' shapes
  compute_shape_check = contains(var.marketplace_source_images.main_mktpl_image.compatible_shapes, var.instance_shape.instanceShape) ? 0 : (
  file("ERROR: Selected compute shape (${var.instance_shape.instanceShape}) not compatible with the Marketplace Image"))

  # Database logic
  is_free_adb = var.adb_type == var.adb_type_enum["ALWAYS_FREE"] ? true : false

  adb_cpu_core_count           = local.is_free_adb ? 1 : var.adb_cpu_core_count
  adb_data_storage_size_in_tbs = local.is_free_adb ? 1 : var.adb_data_storage_size_in_tbs
  adb_enable_auto_scale        = local.is_free_adb ? false : var.adb_enable_auto_scale
  adb_license_model            = local.is_free_adb ? "LICENSE_INCLUDED" : var.adb_license_model
  
}
