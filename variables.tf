variable "access_key" { 
  description = "AWS access key"
}

variable "secret_key" { 
  description = "AWS secret access key"
}

variable "region"     { 
  description = "AWS region to host your network"
  default     = "us-west-1" 
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.128.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  default     = "10.128.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  default     = "10.128.1.0/24"
}

/* Ubuntu 14.04 amis by region */
variable "amis" {
  type = "map"
  description = "Base AMI to launch the instances with"
  default = {
    us-west-1 = "ami-7790c617"
    us-east-1 = "ami-a6b8e7ce"
    ap-southeast-1 = "ami-21d30f42"
    eu-central-1 = "ami-26c43149"
  }
}
variable "aws_public_key" {
	description = "Value of the public key"
}

variable "aws_private_key_name" {
	description = "Name of the private key to be used for connection"
}

variable "aws_machine_type" {
  default = "t2.large"
}

variable "k8s_node_count" {
  description = "Number of Nodes in k8s cluster including master node"
  default = 4
}

variable "rs_proj_name" {
  description = "Name of the rancher project"
  default = "k8srancher"
}