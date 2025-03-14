provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.cidr_blocks[0]
  
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.cidr_blocks[1]
  availability_zone = var.aws_az

  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.env_prefix}-myapp-igw" 
  }
}

resource "aws_default_route_table" "myapp-default-rtb"{
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-myapp-main-rtb" 
  }
}

resource "aws_default_security_group" "myapp-sg" {
  vpc_id = aws_vpc.myapp-vpc.id
  
  tags = {
    Name = "myapp-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_default_security_group.myapp-sg.id
  from_port = 8080
  to_port = 8080
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_default_security_group.myapp-sg.id
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  cidr_ipv4 = var.ip_ssh_accsess[0]
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_default_security_group.myapp-sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol       = "-1"
}

data "aws_ami" "latest-amazon-ami" {
  most_recent = true
  owners = var.ami_owner
  filter {
    name = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name = "ssh-myapp-key"
  public_key = file(var.public_key_locaion)
}

resource "aws_instance" "myapp" {
  ami = data.aws_ami.latest-amazon-ami.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.myapp-sg.id]
  availability_zone = var.aws_az
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh_key.key_name
  #key_name = var.key-pair

  user_data = file ("entry-script.sh")
  
  tags = {
    Name = "${var.env_prefix}-myapp-server" 
  }
}

output "ec2_pub_ip" {
  value = aws_instance.myapp.public_ip
}
