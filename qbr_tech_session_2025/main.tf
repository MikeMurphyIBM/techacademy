# Set the resource group
data "ibm_resource_group" "group" {
  name = "Default"
}

# data "ibm_is_ssh_key" "murph2" {
#   name = "murph2"
#   provider = ibm.vpc
# }

########################################################
# Workspace in data center A
########################################################

#  Create the workspace in the A location
resource "ibm_resource_instance" "pvs_workspace_a" {
  name              = var.workspace_name_a
  service           = "power-iaas"
  location          = var.pvs_region_a
  plan              = "power-virtual-server-group"
  resource_group_id = data.ibm_resource_group.group.id
  provider          = ibm.a
}

# Create a network in the A workspace
resource "ibm_pi_network" "pvs_network_workspace_a" {
  pi_network_name      = "main"
  pi_cloud_instance_id = ibm_resource_instance.pvs_workspace_a.guid
  pi_network_type      = "vlan"
  pi_cidr              = "192.168.0.0/24"
  pi_dns               = ["8.8.8.8"]
  pi_gateway           = "192.168.0.1"
  pi_ipaddress_range {
    pi_starting_ip_address  = "192.168.0.2"
    pi_ending_ip_address    = "192.168.0.254"
  }
  provider             = ibm.a
}

# Create an SSH key 
resource  "ibm_pi_key" "ssh_key_a" {
  pi_key_name          = "murph2"
  pi_cloud_instance_id = ibm_resource_instance.pvs_workspace_a.guid
  provider             = ibm.a
  pi_ssh_key           = /Users/mikemurphy/.ssh/id_ed25519.pub
}

# Create an instance in workspace A
resource "ibm_pi_instance" "test-instance" {
    pi_memory             = "4"
    pi_processors         = "2"
    pi_instance_name      = var.powervs_workspace_a_instance_name
    pi_proc_type          = "shared"
    pi_image_id           = "91414a26-212a-4780-83cf-330f192f2225"
    pi_key_pair_name      = "murph2"
    pi_sys_type           = "s1022"
    pi_cloud_instance_id  = ibm_resource_instance.pvs_workspace_a.guid
    pi_pin_policy         = "none"
    pi_network {
      network_id          = ibm_pi_network.pvs_network_workspace_a.network_id
      ip_address          = "192.168.0.10"
    }
    provider              = ibm.a
}

# ########################################################
# # VPC in us-east-1
# ########################################################

# # Create the VPC
# resource "ibm_is_vpc" "admin_vpc" {
#   name                        = var.vpc_name
#   resource_group              = data.ibm_resource_group.group.id
#   address_prefix_management   = "manual"
#   provider                    = ibm.vpc
# }

# # Create a prefix in the VPC
# resource "ibm_is_vpc_address_prefix" "test_vpc_test_vpc_zone_1_prefix" {
#   name = "${var.vpc_name}-test-vpc-test-vpc-zone-1"
#   vpc  = ibm_is_vpc.admin_vpc.id
#   zone = "${var.vpc_region}-1"
#   cidr = "192.168.2.0/24"
#   provider = ibm.vpc
# }

# # Create the network ACL
# resource "ibm_is_network_acl" "test_vpc_main_acl_acl" {
#   name           = "test-vpc-main-acl-acl"
#   vpc            = ibm_is_vpc.admin_vpc.id
#   resource_group = data.ibm_resource_group.group.id
#   provider = ibm.vpc
#   rules {
#     action      = "allow"
#     destination = "0.0.0.0/0"
#     direction   = "inbound"
#     name        = "inbound"
#     source      = "0.0.0.0/0"
#   }
#   rules {
#     action      = "allow"
#     destination = "0.0.0.0/0"
#     direction   = "outbound"
#     name        = "outbound"
#     source      = "0.0.0.0/0"
#   }
# }

# # # Create the SSH key in the vpc
# # resource "ibm_is_ssh_key" "vpc_ssh_key" {
# #   name          = "murph2"
# #   public_key    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxCFkBYYZkECcH0H1yzlu71fh9y26QHNbY7gOUReV5u mikemurphy@Mikes-MBP.attlocal.net"
# #   type          = "Ed25519"
# #   provider      = ibm.vpc
# # }

# # Create a subnet from the prefix and using the ACL we created
# resource "ibm_is_subnet" "test_vpc_main_zone_1" {
#   vpc             = ibm_is_vpc.admin_vpc.id
#   name            = "test-vpc-main-zone-1"
#   zone            = "${var.vpc_region}-1"
#   resource_group  = data.ibm_resource_group.group.id
#   network_acl     = ibm_is_network_acl.test_vpc_main_acl_acl.id
#   ipv4_cidr_block = "192.168.2.0/24"
#   tags = []
#   depends_on = [
#     ibm_is_vpc_address_prefix.test_vpc_test_vpc_zone_1_prefix
#   ]
#   provider = ibm.vpc
# }

# # Create a VSI
# resource "ibm_is_instance" "instance1" {
#   name                = var.vsi_instance_name
#   image               = var.vpc_image_id
#   profile             = var.vsi_profile
#   primary_network_interface {
#     subnet            = ibm_is_subnet.test_vpc_main_zone_1.id
#   }
#   vpc                 = ibm_is_vpc.admin_vpc.id
#   zone                = var.vpc_zone
#   keys                = [data.ibm_is_ssh_key.murph2.id]
#   resource_group      = data.ibm_resource_group.group.id
#   provider            = ibm.vpc
# }

# # Create the FIP for the VSI
# resource "ibm_is_floating_ip" "vis_fip" {
#   name                = "vsi-fip"
#   target              = ibm_is_instance.instance1.primary_network_interface[0].id
#   provider            = ibm.vpc
# }

# # Create the Transit Gateway
# resource "ibm_tg_gateway" "main_tgw" {
#   name                = "main_tgw"
#   location            = var.vpc_region
#   resource_group      = data.ibm_resource_group.group.id
#   global              = false
#   provider            = ibm.vpc
# }

# # Connection for PowerVS Workspace A
# resource "ibm_tg_connection" "pvs_workspace_a" {
#   gateway             = ibm_tg_gateway.main_tgw.id
#   name                = "powervs_workspace_a"
#   network_type        = "power_virtual_server"
#   network_id          = ibm_resource_instance.pvs_workspace_a.id
#   provider            = ibm.vpc
# }

# # Connection for VPC
# resource "ibm_tg_connection" "vpc" {
#   gateway             = ibm_tg_gateway.main_tgw.id
#   name                = "vpc"
#   network_type        = "vpc"
#   network_id          = ibm_is_vpc.admin_vpc.crn
#   provider            = ibm.vpc
# }

