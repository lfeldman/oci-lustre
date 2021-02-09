# Variables required by the OCI Provider only when running Terraform CLI with standard user based Authentication
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "availablity_domain_name" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# Bastion
variable bastion_shape { default = "VM.Standard2.2" }
variable bastion_node_count { default = 1 }
variable bastion_hostname_prefix { default = "bastion-" }


# MDS server count
variable "lustre_mds_count" { default = "1" }
# MDS server shape
variable "lustre_mds_server_shape" { default = "VM.Standard2.2" }
# size in GiB for each MDT disk. 800 GB
variable "mdt_block_volume_size" { default = "50" }
#eg: 2 block storage volume per MDS node.
variable "lustre_mdt_count" { default = "1" }
variable "enable_mdt_raid0" { default = "false" }


variable "mgs_hostname_prefix_nic0" { default = "lustre-mds-server-nic0-" }
variable "mgs_hostname_prefix_nic1" { default = "lustre-mds-server-nic1-" }
variable "mgs_hostname_nic0" { default = "lustre-mds-server-nic0-1" }
variable "mgs_hostname_nic1" { default = "lustre-mds-server-nic1-1" }

variable "mds_hostname_prefix_nic0" { default = "lustre-mds-server-nic0-" }
variable "mds_hostname_prefix_nic1" { default = "lustre-mds-server-nic1-" }

variable "oss_hostname_prefix_nic0" { default = "lustre-oss-server-nic0-" }
variable "oss_hostname_prefix_nic1" { default = "lustre-oss-server-nic1-" }

variable "lustre_client_hostname_prefix" { default = "lustre-client-" }


# OSS server count.
variable "lustre_oss_count" { default = "1" }
# OSS server shape
variable "lustre_oss_server_shape" { default = "VM.Standard2.2" }
# size in GiB for each OST disk.
variable "ost_block_volume_size" { default = "50" }
#eg: 4 block storage volume per OSS node.
variable "lustre_ost_count" { default = "2" }
variable "enable_ost_raid0" { default = "false" }


# Lustre Client server count   
variable "lustre_client_count" { default = "1" }
# Lustre Client server shape
variable "lustre_client_shape" { default = "VM.Standard2.2" }


variable "scripts_directory" { default = "scripts" }

locals {
  mds_dual_nics = (length(regexall("^BM", var.lustre_mds_server_shape)) > 0 ? true : false)
  oss_dual_nics = (length(regexall("^BM", var.lustre_oss_server_shape)) > 0 ? true : false)
}


# For instances created using Oracle Linux and CentOS images, the user name opc is created automatically.
# For instances created using the Ubuntu image, the user name ubuntu is created automatically.
# The opc/ubuntu user has sudo privileges and is configured for remote access over the SSH v2 protocol using RSA keys. The SSH public keys that you specify while creating instances are added to the /home/<opc or ubuntu>/.ssh/authorized_keys file.
# For more details: https://docs.cloud.oracle.com/iaas/Content/Compute/References/images.htm#one
variable "ssh_user" {
  default = "opc"
}

# For Ubuntu images,  set to ubuntu.
# variable "ssh_user" { default = "ubuntu" }


#-------------------------------------------------------------------------------------------------------------
# Marketplace variables
# ------------------------------------------------------------------------------------------------------------
# Based on Oracle Linux 7.6 UEK Image for Lustre filesystem (hpc-filesystem-Lustre-OL76_4.14.35-1902.3.2.el7uek.x86_64) marketplace image.

variable "mp_listing_id" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaaveqtwusi5tiuph3j5lbeddgs337yiug5seah326z57x744sphmyq"
}
variable "mp_listing_resource_id" {
  default = "ocid1.image.oc1..aaaaaaaagbswqa23ufl6v6ssxq5yqs5mjkxbbcarcnpokqfm3kseouinlrba"
}
variable "mp_listing_resource_version" {
 default = "1.0"
}

variable "use_marketplace_image" {
  default = true
}
# ------------------------------------------------------------------------------------------------------------


# Oracle-Linux-7.6-2019.05.28-0
# https://docs.cloud.oracle.com/iaas/images/image/6180a2cb-be6c-4c78-a69f-38f2714e6b3d/
variable "images" {
  type = map(string)
  default = {
    /*
      See https://docs.us-phoenix-1.oraclecloud.com/images/ or https://docs.cloud.oracle.com/iaas/images/
      Oracle-provided image "CentOS-7-2018.11.16-0"
      https://docs.cloud.oracle.com/iaas/images/image/66a17669-8a67-4b43-924a-78d8ae49f609/
    */
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaaj6pcmnh6y3hdi3ibyxhhflvp3mj2qad4nspojrnxc6pzgn2w3k5q"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaa2wadtmv6j6zboncfobau7fracahvweue6dqipmcd5yj6s54f3wpq"
  }
}

/*
variable "imagesCentos76" {
  type = map(string)
  default = {
    // https://docs.cloud.oracle.com/iaas/images/image/96ad11d8-2a4f-4154-b128-4d4510756983/
    // See https://docs.us-phoenix-1.oraclecloud.com/images/ or https://docs.cloud.oracle.com/iaas/images/
    // Oracle-provided image "CentOS-7-2018.08.15-0"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaavsw2452x5psvj7lzp7opjcpj3yx7or4swwzl5vrdydxtfv33sbmqa"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaahhgvnnprjhfmzynecw2lqkwhztgibz5tcs3x4d5rxmbqcmesyqta"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaa3iltzfhdk5m6f27wcuw4ttcfln54twkj66rsbn52yemg3gi5pkqa"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaaa2ph5vy4u7vktmf3c6zemhlncxkomvay2afrbw5vouptfbydwmtq"
  }
}
*/

