

variable "hosted_zone_id" {
  default = "Z03974802KSTVYZHLB3HN"

}

variable "tenants" {
  type = list(object({
    tenant_name    = string
    domain_name    = string
    vpc_cidr       = string
    instance_type  = string
  }))
}