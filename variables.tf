# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Kristoffer"
    "App"   = "Assignment-1"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  default     = "clo835-assign1"
  type        = string
  description = "Name prefix"
}
variable "vpc_cidr" {
  default     = "10.32.0.0/16"
  type        = string
  description = "Public Subnet CIDR"
}
variable "public_subnet_cidr" {
  default     = "10.32.0.0/24"
  type        = string
  description = "Public Subnet CIDR"
}
variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "EC2 instance type"
}
variable "ecr_name" {
  description = "Assignment 1 ECR"
  type        = string
  default     = "assign1-ecr"
}
variable "image_mutability" {
  description = "Provide image mutability"
  type        = string
  default     = "IMMUTABLE"
}
variable "encrypt_type" {
  description = "Provide type of encryption here"
  type        = string
  default     = "KMS"
}
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}