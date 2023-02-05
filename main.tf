# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
  
} # Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
} 
# Create a new VPC 
resource "aws_vpc" "assign1_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
    var.default_tags,
    {
      Name = "${var.prefix}-vpc"
    },
  )
}

# Add provisioning of the public subnet1 in the custom VPC
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.assign1_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(
    var.default_tags,
    {
      Name = "${var.prefix}-subnet1"
    },
  )
} 
# Create Internet Gateway
resource "aws_internet_gateway" "assign1_igw" {
  vpc_id = aws_vpc.assign1_vpc.id
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.assign1_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.assign1_igw.id
  }
} 
# Associate subnets with the custom route table
resource "aws_route_table_association" "public_route_table_association-1" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_cidr.id
}
# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
resource "aws_instance" "my_amazon" {
  ami                         = aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.my_key.key_name
  subnet_id                   = aws_subnet.public_subnet1
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = "LabInstanceProfile"
  user_data                   = file("${path.module}/preparexdocker.sh")
  tags = merge(
    var.default_tags,
    {
      Name = "${var.prefix}-ec2"
    },
  )
  lifecycle {
    create_before_destroy = true
  }
}