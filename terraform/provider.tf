/* 
 * This provider and variables are not required when running from ORM
 */

provider "oci" {
  region           = var.region
  ### Enable below variables if running this from local terraform installation
  #tenancy_ocid     = var.tenancy_ocid
  #user_ocid        = var.user_ocid
  #fingerprint      = var.fingerprint
  #private_key_path = var.private_key_path
  
}

# Enable below variables required by the OCI Provider when running Terraform CLI locally with standard user based Authentication
#variable "user_ocid" {
#}
#variable "fingerprint" {
#}
#variable "private_key_path" {
#}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_regions" "home-region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenancy.home_region_key]
  }
}

provider "oci" {
  alias            = "home"
  region           = data.oci_identity_regions.home-region.regions[0]["name"]
  ### Enable below variables if running this from local terraform installation
  #tenancy_ocid     = var.tenancy_ocid 
  #user_ocid        = var.user_ocid
  #fingerprint      = var.fingerprint
  #private_key_path = var.private_key_path
}