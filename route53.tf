resource "aws_route53_record" "asaghatelyan" {
  zone_id = "Z10299161M47DBD68JOWT"
  name    = "asaghatelyan"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.my_alb.dns_name]
}
