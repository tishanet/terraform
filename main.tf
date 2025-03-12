provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "dev-vpc" {
  cidr_block = var.cidr_blocks[0]
  
  tags = {
    Name = "dev_vpc"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.cidr_blocks[1]
  availability_zone = "us-east-1a"

  tags = {
    Name = "dev_subnet-1"
  }
}

data "aws_vpc" "existing-vpc" {
  filter {
    name   = "tag:Name"
    values = ["app-vpc"]
  }
}

resource "aws_subnet" "app-dev-subnet-1" {
  vpc_id = data.aws_vpc.existing-vpc.id
  cidr_block = var.cidr_blocks[2]
  availability_zone = "us-east-1a"

  tags = {
    Name = "app-dev-subnet-1"
  }
}

output dev-vpc-id {
  value       = aws_vpc.dev-vpc.id
}

output existing-vpc-id {
  value       = data.aws_vpc.existing-vpc.id
}

output app-dev-subnet-1 {
  value       = aws_subnet.app-dev-subnet-1.id
}
