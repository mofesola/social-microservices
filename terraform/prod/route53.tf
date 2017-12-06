resource "aws_route53_record" "prod-app-url" {
  zone_id = "${var.ZONE_ID}"
  name    = "${var.prod-app-url-name}"
  type    = "A"
  ttl     = "300"
  records = ["${var.records}"]
}