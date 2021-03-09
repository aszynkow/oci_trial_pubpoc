output "BGL-OCI-SHR-SYD-VM1PublicIP" {
    value = local.Bgl_Oci_Shr_Syd_Vm1_public_ip
}

output "BGL-OCI-SHR-SYD-VM1PrivateIP" {
    value = local.Bgl_Oci_Shr_Syd_Vm1_private_ip
}

output "Networking_Compartment_Id_id" {
  description = "Network Compartment id"
 value       = local.Networking_Compartment_Id_id
} 

output "build_compartment_id" {
  description = "Network Compartment id"
 value       = local.current_compartment_id
} 

output "vcn_id" {
  description = "Vcn id"
  value       = local.Bgl_Oci_Cor_Shr_Syd_Vcn_01_id
}
