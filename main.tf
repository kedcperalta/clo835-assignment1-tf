# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
  
} # Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
  
} # Create a new VPC 
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
    var.default_tags,
    {
      Name = "${var.prefix}-vpc"
    },
  )
}