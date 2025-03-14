variable aws_region {
  type        = string
  default     = "us-east-1"
}
variable aws_az {
  type        = string
  default     = "us-east-1a"
}
variable cidr_blocks {
  description = "cidr block for vpc and subnets"
  type = list(string)
}
variable env_prefix {
  type        = string
  default     = "test"
  description = "testing env"
}

variable ip_ssh_accsess {
  type = list(string)
  description = "list of IPs for SSH access"
}

variable ami_owner {
   type = list(string)
   description = "AMI owner"
}

variable instance_type {
  type = string
}

variable key-pair {
  type    = string
  default     = "my-server"
}

variable public_key_locaion {
  type = string
}

