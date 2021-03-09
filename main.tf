
    // Copyright (c) 2020, Oracle and/or its affiliates. All rights reserved.
    // Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

      terraform {
        required_version = ">= 0.12.0"
      }

      provider "oci" {
        tenancy_ocid     = var.tenancy_ocid
        #user_ocid        = var.user_ocid
        #fingerprint      = var.fingerprint
        #private_key_path = var.private_key_path
        region           = var.region
      }

locals {
    #Networking_Compartment_Id_id   = var.compartment_ocid
    ssh_pub_key = var.ssh_public_key
    Bgl_Oci_Shr_Syd_Vm1_shape = var.Bgl_Oci_Shr_Syd_Vm1_shape[0]
    On_prem_cidr_block = var.on_prem_cidr_block
}

data "oci_identity_availability_domains" "AvailabilityDomains" {
    compartment_id = var.tenancy_ocid
}

data "oci_identity_compartments" "bgl_compartments" {
    #Required
    compartment_id = var.tenancy_ocid
    compartment_id_in_subtree = "true"
}

locals {
Bgl_Oci_Compartments = [for x in data.oci_identity_compartments.bgl_compartments.compartments: x if x.state == "ACTIVE" && x.description == var.network_compartment_name]
Networking_Compartment_Id_id = local.Bgl_Oci_Compartments.0.id

current_compartment_id = var.compartment_ocid
}

#--- Get subnets
data "oci_core_vcns" "bgl_vcns" {
    #Required
    compartment_id      = local.Networking_Compartment_Id_id
}

data "oci_core_vcns" "bgl_vcns_def" {
    #Required
    compartment_id      = local.Networking_Compartment_Id_id
    display_name = var.vcn_name
}


locals {
Bgl_Oci_Cor_Shr_Syd_Vcns = [for x in data.oci_core_vcns.bgl_vcns.virtual_networks: x if x.display_name == var.vcn_name]
Bgl_Oci_Cor_Shr_Syd_Vcn_01_id = local.Bgl_Oci_Cor_Shr_Syd_Vcns.0.id
Bgl_Oci_Cor_Shr_Syd_Vcn_01_def_rt_id = data.oci_core_vcns.bgl_vcns_def.virtual_networks.0.default_route_table_id
}

data "oci_core_route_tables" "bgl_route_tables" {
    #Required
    compartment_id = local.Networking_Compartment_Id_id

    #Optional
    display_name = var.route_table_display_name
    #state = var.route_table_state
    vcn_id = local.Bgl_Oci_Cor_Shr_Syd_Vcn_01_id
}

locals {
    Bgl_Oci_Cor_Shr_Syd_Rt_01_id = data.oci_core_route_tables.bgl_route_tables.route_tables.0.id
}


data "oci_core_security_lists" "bgl_security_lists" {
    #Required
    compartment_id = local.Networking_Compartment_Id_id

    #Optional
    display_name = var.security_list_display_name
    #state = var.security_list_state
    vcn_id = local.Bgl_Oci_Cor_Shr_Syd_Vcn_01_id
}

locals {
   Bgl_Oci_Cor_Shr_Syd_Sl_01_id = data.oci_core_security_lists.bgl_security_lists.security_lists.0.id
}

data "oci_core_dhcp_options" "bgl_dhcp_options" {
    #Required
    compartment_id = local.Networking_Compartment_Id_id

    #Optional
    display_name = var.dhcp_options_display_name
    #state = var.dhcp_options_state
    vcn_id = local.Bgl_Oci_Cor_Shr_Syd_Vcn_01_id
}

locals {
   Bgl_Oci_Cor_Shr_Syd_Vcn_01_dhcp_options_id = data.oci_core_dhcp_options.bgl_dhcp_options.options.0.id
}

# ------ Get List OL7 Images
data "oci_core_images" "Bgl_Oci_Shr_Syd_Vm1Images" {
    compartment_id           = var.tenancy_ocid
    operating_system         = var.Bgl_Oci_Shr_Syd_Vm1_os
    operating_system_version = var.Bgl_Oci_Shr_Syd_Vm1_os_version
    shape                    = local.Bgl_Oci_Shr_Syd_Vm1_shape
}
# ------ Create Subnet
# ---- Create Public Subnet
resource "oci_core_subnet" "Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc" {
    # Required
    compartment_id             = local.Networking_Compartment_Id_id
    vcn_id                     = local.Bgl_Oci_Cor_Shr_Syd_Vcn_01_id
    cidr_block                 = var.Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_cidr_block
    # Optional
    display_name               = var.Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_display_name
    dns_label                  = var.Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_dns_label
    #route_table_id             = local.Bgl_Oci_Cor_Shr_Syd_Rt_01_id
    #dhcp_options_id            = local.Bgl_Oci_Cor_Shr_Syd_Vcn_01_dhcp_options_id
    prohibit_public_ip_on_vnic = var.Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_prohibit_public_ip_on_vnic
    freeform_tags              = var.Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_freeform_tags
    #security_list_ids          = [local.Bgl_Oci_Cor_Shr_Syd_Sl_01_id]
}

locals {
    Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_id              = oci_core_subnet.Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc.id
    Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_domain_name     = oci_core_subnet.Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc.subnet_domain_name
}

# ------ Create Internet Gateway
resource "oci_core_internet_gateway" "Bgl_Oci_Cor_Shr_Syd_Igw_01" {
    # Required
    compartment_id = local.Networking_Compartment_Id_id
    vcn_id         = local.Bgl_Oci_Cor_Shr_Syd_Vcn_01_id
    # Optional
    enabled        = var.Bgl_Oci_Cor_Shr_Syd_Igw_01_enabled
    display_name   = var.Bgl_Oci_Cor_Shr_Syd_Igw_01_display_name
    freeform_tags  = var.Bgl_Oci_Cor_Shr_Syd_Igw_01_freeform_tags
}

locals {
    Bgl_Oci_Cor_Shr_Syd_Igw_01_id = oci_core_internet_gateway.Bgl_Oci_Cor_Shr_Syd_Igw_01.id
}

# ------ Create Route Table
resource "oci_core_default_route_table" "Bgl_Oci_Cor_Shr_Syd_Rtn_Igw_01" {
    manage_default_resource_id = local.Bgl_Oci_Cor_Shr_Syd_Vcn_01_def_rt_id
    # Required
    #compartment_id = local.Networking_Compartment_Id_id
    #vcn_id         = local.Bgl_Oci_Cor_Shr_Syd_Vcn_01_id
    # Optional
    #display_name   = var.Bgl_Oci_Cor_Shr_Syd_Rtn_Igw_01_display_name
    freeform_tags  = var.Bgl_Oci_Cor_Shr_Syd_Rtn_Igw_01_freeform_tags

     route_rules {
        network_entity_id = local.Bgl_Oci_Cor_Shr_Syd_Igw_01_id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
    }

     route_rules {
        network_entity_id = local.Bgl_Oci_Cor_Shr_Syd_Drg_01_id
        destination       = local.On_prem_cidr_block
        destination_type  = "CIDR_BLOCK"
    }
}

/*locals {
    Bgl_Oci_Cor_Shr_Syd_Rtn_Igw_01_id = oci_core_route_table.Bgl_Oci_Cor_Shr_Syd_Rtn_Igw_01.id
}*/

# ------ Create Instance
resource "oci_core_instance" "Bgl_Oci_Shr_Syd_Vm1" {
    # Required
    compartment_id      = local.current_compartment_id
    shape               = local.Bgl_Oci_Shr_Syd_Vm1_shape
    # Optional
    display_name        = var.Bgl_Oci_Shr_Syd_Vm1_display_name
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains[var.Bgl_Oci_Shr_Syd_Vm1_availability_domain - 1]["name"]
    agent_config {
        # Optional
    }
    create_vnic_details {
        # Required
        subnet_id        = local.Bgl_Oci_Cor_Shr_Syd_Sub_Publicpoc_id
        # Optional
        assign_public_ip = var.Bgl_Oci_Shr_Syd_Vm1_assign_public_ip
        display_name     = var.Bgl_Oci_Shr_Syd_Vm1_display_name_vnic
        hostname_label   = var.Bgl_Oci_Shr_Syd_Vm1_hostname_label
        skip_source_dest_check = var.Bgl_Oci_Shr_Syd_Vm1_skip_source_dest_check
        freeform_tags    = var.Bgl_Oci_Shr_Syd_Vm1_freeform_tags
    }
#    extended_metadata {
#        some_string = "stringA"
#        nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
#    }
    metadata = {
        ssh_authorized_keys = local.ssh_pub_key
        #user_data           = base64encode(var.Bgl_Oci_Shr_Syd_Vm1_user_data)
    }
    source_details {
        # Required
        source_id               = data.oci_core_images.Bgl_Oci_Shr_Syd_Vm1Images.images[0]["id"]
        source_type             = var.Bgl_Oci_Shr_Syd_Vm1_source_type
        # Optional
        boot_volume_size_in_gbs = var.Bgl_Oci_Shr_Syd_Vm1_boot_volume_size_in_gbs
#        kms_key_id              = 
    }

     shape_config {
      memory_in_gbs = var.memory
      ocpus = var.ocpus
  }

    preserve_boot_volume = var.Bgl_Oci_Shr_Syd_Vm1_preserve_boot_volume
    freeform_tags              = var.Bgl_Oci_Shr_Syd_Vm1_freeform_tags
}

locals {
    Bgl_Oci_Shr_Syd_Vm1_id            = oci_core_instance.Bgl_Oci_Shr_Syd_Vm1.id
    Bgl_Oci_Shr_Syd_Vm1_public_ip     = oci_core_instance.Bgl_Oci_Shr_Syd_Vm1.public_ip
    Bgl_Oci_Shr_Syd_Vm1_private_ip    = oci_core_instance.Bgl_Oci_Shr_Syd_Vm1.private_ip
}

