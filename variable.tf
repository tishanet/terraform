variable cidr_blocks {
  description = "cidr block for vpc and subnets"
  type = list(string)
  default = ["10.0.0.0/16", "10.0.1.0/24", "172.32.3.0/24"]
}

/*variable dev-vpc_cidr_block {
  type    = string
  default = "10.0.0.0/16"
  description = "CIDR block for dev-vpc"
}

variable dev-subnet-1_cidr_block {
  type    = string
  default = "10.0.1.0/24"
  description = "CIDR block for vpc_dev-subnet"
}

variable app-dev-subnet-1_cidr_block {
  type    = string
  default = "172.32.3.0/24"
  description = "CIDR block for vpv_app-dev "
}*/