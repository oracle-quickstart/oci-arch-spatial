variable "marketplace_source_images" {
  type = map(object({
    ocid = string 
    is_pricing_associated = bool 
    compatible_shapes = set(string)
  }))

  default = {
    main_mktpl_image = {
      ocid = "ocid1.image.oc1..aaaaaaaadeywf3clwo5kf6xdvyrpfayh66fmuwws3onopvpnodd7wkuh6dna"
      is_pricing_associated = false
      compatible_shapes = ["VM.Standard1.1", "VM.Standard1.16", "VM.Standard1.2", "VM.Standard1.4", "VM.Standard1.8", "VM.Standard2.1", "VM.Standard2.16", "VM.Standard2.2", "VM.Standard2.24", "VM.Standard2.4", "VM.Standard2.8", "VM.Standard.B1.1", "VM.Standard.B1.16", "VM.Standard.B1.2", "VM.Standard.B1.4", "VM.Standard.B1.8", "VM.Standard.E2.1", "VM.Standard.E2.1.Micro", "VM.Standard.E2.2", "VM.Standard.E2.4", "VM.Standard.E2.8", "VM.Standard3.Flex", "VM.Optimized3.Flex", "VM.Standard.E3.Flex", "VM.Standard.E4.Flex"]
    }
  }
}