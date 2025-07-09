
# DNS Record
resource "aws_route53_record" "tenant" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.tenant.dns_name
    zone_id                = aws_lb.tenant.zone_id
    evaluate_target_health = true
  }
}