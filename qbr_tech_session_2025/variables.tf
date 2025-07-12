variable "pvs_region_a" {
  description = "Where to deploy the Power VS Workspace A"
  default = "us-east"
} 

variable "pvs_zone_a" {
  description = "Zone for PowerVS (e.g., wdc06)"
  type        = string
  default     = "WDC06"
}

variable "image_id" {
  description = "The ID of the IBM Power Virtual Server image to use for the instance." 
  type        = string # An image ID is typically a string value. 
  default     = "91414a26-212a-4780-83cf-330f192f2225" # **This will set the default image ID to the one you provided.**
}


variable "workspace_name_a" {
  description = "The name of the workspace to create in region a"
  default = "murph-qbr-pvs"
}

variable "powervs_workspace_a_instance_name" {
  default = "murph-qbr-aix"
}

variable "storage_type_a" {
  description = "This is the Power VS storage type to use for the server deployed in workspace a"
  default = "tier3"
}

variable "ssh_key_name" {
  description = "Name of the ssh key to be used"
  type        = string
  default     = "murph2"
}

variable "ssh_key_rsa" {
  description = "Public ssh key"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyUGbL9JPJ2/2GB/E5tk/zkEQa3ZDt7+lBi36A+pMF/iMtVBcCTj7lsXxJ+QhCZp4Y5yl3amkTzdNUYZmt0PQN8eAmQBVAKS7H5pkRqk7DLfRYmpLvnrYHF3jekqunFaspJGXvLhmfextKkzzlnppXU/o97Rwwj9MOfSqmlv07YEsUbBDHWHak4s1Cm7aSpCRiO0z2tnAsyllCwB/Ha9xqrDrocJqYcBZTA7rOgH08p75JgsOTW2gjSxOgACW/3lRxlOcyh4uZL3bcZBLpiwn+DMeYFdwIt0kpKW4GPqAjqc0m2zyArSv2XaUkhkuecNTmvXX5yTuheDkbygpAakB3Pyrb+wW4GdGGAuWxnx6LvuhklDMAZGVpzVt3M7QZIwphFtpkeE40Ia7xN4C4O5lka20IaM2fwT1VyeTgjErDoA8mvBU3fb7cDTrjMUdzH8f+II/ekamg9yvM3NprN4mpADD6cDG0mp6YX74rIJEkdq74DyetyWZ2Cf8XoZjyRis= mikemurphy@Mikes-MBP.attlocal.net"
}

variable "vpc_region" {
  description = "IBM Cloud Region where resources will be provisioned"
  type        = string
  default     = "us-east"
  validation {
    error_message = "Region must be in a supported IBM VPC region."
    condition     = contains(["us-south", "us-east", "br-sao", "ca-tor", "eu-gb", "eu-de", "jp-tok", "jp-osa", "au-syd"], var.vpc_region)
  }
}

variable "vpc_name" {
  description = "The name of the VPC"
  type = string
  default = "murph-qbr-vpc"
}

variable "vpc_image_id" {
  default = "r014-2dfb4fd7-2af0-4df0-a8e1-97eaa04b6156"
  description = "The image id used for the VSI in the VPC"
}

variable "vsi_profile" {
  default = "cx2-2x4"
  description = "The default profile to use, a cx2-2x4"
}

variable "vpc_zone" {
  default = "us-east-1"  
}

variable "vsi_instance_name" {
  default = "bcbush-jumpserver"
}

variable "ibmcloud_api_key" {
  description = "IBM Cloud API key used to authenticate with the provider"
  type        = string
  sensitive   = true
}


variable "ssh_public_key" {
  description = "The content of the SSH public key for Power Virtual Server"
  type        = string 
  sensitive   = true # Recommended for security
}
