variable "region" {
  description = "The AWS region to create resources in."
  default = "eu-west-1"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default = "social-microservices"
}


/* ECS optimized AMIs per region */
variable "amis" {
  default = {
    ap-northeast-1 = "ami-8aa61c8a"
    ap-southeast-2 = "ami-5ddc9f67"
    eu-west-1      = "ami-809f84e6"
    us-east-1      = "ami-b540eade"
    us-west-1      = "ami-5721df13"
    us-west-2      = "ami-cb584dfb"
  }
}

variable "instance_type" {
  default = "t2.nano"
}

variable "key_name" {
  description = "The aws ssh key name."
  default = "social-microservices"
}

variable "vpc_id" {
  description = "The aws vpc id."
  default = "vpc-******"
}

variable "subnet_id" {
  description = "The aws subnet id."
  default = "subnet-*******"
}

variable "env" {
  description = "The aws environment."
  default = "prod"
}

variable "project_name" {
  default = "social-microservices"
}

variable "project_billing_id" {
  default = "social-microservices"
}

variable "subnets" {
  default = "subnet-********,subnet-********,subnet-********"
}