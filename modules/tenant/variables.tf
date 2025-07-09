variable "tenant_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "certificate_arn" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}
