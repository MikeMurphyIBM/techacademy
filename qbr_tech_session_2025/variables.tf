variable "pvs_region_a" {
  description = "Where to deploy the Power VS Workspace A"
  default = "wdc06"
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
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxCFkBYYZkECcH0H1yzlu71fh9y26QHNbY7gOUReV5u mikemurphy@Mikes-MBP.attlocal.net"
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
