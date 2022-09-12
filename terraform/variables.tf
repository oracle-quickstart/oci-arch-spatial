/* 
 * Variables file with defaults. These can be overridden from environment variables TF_VAR_<variable name>
 *
 * Following are generally configured in environment variables - please use env_vars_template to create env_vars and source it as:
 * source ./env_vars
 * before running terraform init
 */

/*
********************
* Instance Config
********************
*/

variable "service_name" {
  default = "sgtech"
}

variable "instance_shape" {
  type = map(any)
  default = {
    "instanceShape" = "VM.Standard.E4.Flex"
    "ocpus" = 1
    "memory" = 16
  }
  #Default in instance creation page is {"instanceShape"="VM.Standard.E4.Flex","ocpus"=1,"memory"=16}
}

// Note: This is the opc user's SSH public key text and not the key file path.
variable "ssh_public_key" { }

variable "availability_domain_name" {}

variable "console_ssl_port" {
  default = "4040"
}

variable "use_secrets" {
  default = true
}

variable "admin_user" {
  default = "studio_admin"
}

//Add value and set use_secrets=false if you want to use a plain password for Spatial Studio user
variable "admin_pwd" {
  default = ""
  sensitive = true
}

//By default with use_secrets=true this Secret OCID will be decoded and used as Spatial Studio password
variable "admin_pwd_ocid" {
  default = ""
}


/*
********************
* Network Config
********************
*/

variable "network_compartment_id" {}

variable "vcn_strategy_enum" {
  type = map
  default = {
    CREATE_VCN = "Create New VCN"
    USE_VCN    = "Use Existing VCN"
  }
}

variable "vcn_strategy" {
  default = "Create New VCN"
}

variable "existing_vcn_id" {
  default = ""
}

variable "vcn_name" {
  default = "vcn"
}

variable "subnet_name" {
  default = "subnet"
}

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_id" {
  default = ""
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}

/*
********************
* ADB Config
********************
*/
variable "adb_type_enum" {
  type = map
  default = {
    ALWAYS_FREE = "Always Free Oracle Autonomous Data Warehouse (1 OCPU 20 GB Storage)"
    PAID        = "Paid Oracle Autonomous Data Warehouse"
  }
}

variable "adb_type" {
  default = "Always Free Oracle Autonomous Data Warehouse (1 OCPU 20 GB Storage)"
}

variable "adb_compartment_ocid" {
}

variable "adb_level" {
  default = "low"
}

variable "adb_user" {
  default = "studio_repo"
}

variable "adb_user_password_ocid" { }
   
variable "adb_name" {
  default = "adw"
}

variable "adb_version" {
  default = "19c"
}
variable "adb_license_model" {
  default = "LICENSE_INCLUDED" # LICENSE_INCLUDED or BRING_YOUR_OWN_LICENSE
}
variable "adb_cpu_core_count" {
  default = 2
}
variable "adb_data_storage_size_in_tbs" {
  default = 1
}
variable "adb_enable_auto_scale" {
  default = false
}

/*
********************
* Tag Config
********************
*/

variable "show_tag_options" {
  default = true
}

variable  "defined_tag" {
  type = map(map(string))
  default = {
    "freeformTags" = {
      "oracle-quickstart" = "oci-spatialstudio"
    }
  }
}

/*
********************
* Hidden Variables
********************
*/
variable "tenancy_ocid" {}

variable "region" {}

variable "compartment_ocid" {}

variable "use_marketplace_image" {
  default = true
}

# Published Spatial Studio Image Listing OCID
variable "mp_listing_id" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaaxfsimxy72yxnm4zllryolsjyrgaczimlyyahbmryga3nyehxythq"
}

# Package version Reference
variable "mp_listing_resource_version" {
  default = "22.2.0.1"
}

# Use this variable along the use_marketplace_image to specify either the
# Image artifact ocid to use the latest official marketplace image or your custom image ocid
variable "instance_image_id" {
  default = "ocid1.image.oc1..aaaaaaaalrslmrm5tx6eitzqs46usxmpyddj3yzmxrp63pb5ij4ibx4vyw5q"
}
