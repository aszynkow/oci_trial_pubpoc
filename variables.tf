variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "region" {}
variable "Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_display_name" {}
variable "Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_cidr_block" {}
variable "Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_dns_label" {}
variable "Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_prohibit_public_ip_on_vnic" {}
variable "Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_freeform_tags" {}
variable "Bgl_Oci_Shr_Syd_Vm1_availability_domain" {}
variable "Bgl_Oci_Shr_Syd_Vm1_display_name" {}
variable "Bgl_Oci_Shr_Syd_Vm1_shape" {}
variable "Bgl_Oci_Shr_Syd_Vm1_source_type" {}
variable "Bgl_Oci_Shr_Syd_Vm1_os" {}
variable "Bgl_Oci_Shr_Syd_Vm1_os_version" {}
variable "Bgl_Oci_Shr_Syd_Vm1_boot_volume_size_in_gbs" {}
variable "Bgl_Oci_Shr_Syd_Vm1_display_name_vnic" {}
variable "Bgl_Oci_Shr_Syd_Vm1_hostname_label" {}
variable "Bgl_Oci_Shr_Syd_Vm1_assign_public_ip" {}
variable "Bgl_Oci_Shr_Syd_Vm1_skip_source_dest_check" {}
variable "Bgl_Oci_Shr_Syd_Vm1_authorized_keys" {}
variable "Bgl_Oci_Shr_Syd_Vm1_user_data" {}
variable "Bgl_Oci_Shr_Syd_Vm1_preserve_boot_volume" {}
variable "Bgl_Oci_Shr_Syd_Vm1_freeform_tags" {}
variable "vcn_name" {
   type = string
   description = "Vm1 Subnet name"
   default = "BGL-OCI-COR-SHR-SYD-VCN-01"
}

variable "ssh_public_key" {
   type = string
   description = "PublicPOC VM1 Ssh key"
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAhz9n8B4f8ctCs7MZP20QtgVa7uFH6t8K0+p+1DHD7N5A7rXIuezYqZxiWZ1KWw0cgA2wy8ZotD0mivZk06mYHnwi6HN/4L732/5iVb23iemLcqXTJDtl0mFqN3h/u+VM3yE+9cpX4ZmGembIsqKHo1+lUJp27sBgSWalcs/jkzoQcKFq5o5StAgeiNCn6jmiuI/3e10k7TjJ/Uc9FiHrtGth93MBO/oFQvFBGHP+lrP8wymt7lEg5EKk6lE6fA+DsfNfGlgbsy7lLnw/Dm3WFATE1QWVjTwby8/V6KyqIAahwf3QU+w17WrEIH4rcd4UFFK0hJgxZaUqls2RkBH/UQ== rsa-key-20201022"
}

variable "network_compartment_name" {
   type = string
   description = "Networking compartment name"
   default = "BGL-OCI-NET"
}

variable "route_table_display_name" {}
variable "security_list_display_name" {}
variable "dhcp_options_display_name" {}

variable "memory" {
type = string
description = "Flex RAM"
default = "15"
}

variable "ocpus" {
type = string
description = "Flex OCPUS"
default = "1"
}

variable "Bgl_Oci_Cor_Shr_Syd_Igw_01_display_name" {}
variable "Bgl_Oci_Cor_Shr_Syd_Igw_01_enabled" {}
variable "Bgl_Oci_Cor_Shr_Syd_Igw_01_freeform_tags" {}
variable "Bgl_Oci_Cor_Shr_Syd_Igw_01_display_name" {}
variable "Bgl_Oci_Cor_Shr_Syd_Igw_01_enabled" {}
variable "Bgl_Oci_Cor_Shr_Syd_Igw_01_freeform_tags" {}