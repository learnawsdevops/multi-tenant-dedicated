module "tenants" {
  for_each = {
    for tenant in var.tenants : tenant.tenant_name => tenant
  }

  source          = "./modules/tenant"
  tenant_name     = each.value.tenant_name
  domain_name     = each.value.domain_name
  vpc_cidr        = each.value.vpc_cidr
  instance_type   = each.value.instance_type
  certificate_arn = aws_acm_certificate.wildcard.arn
  hosted_zone_id  = var.hosted_zone_id
}