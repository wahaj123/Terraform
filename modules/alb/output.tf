output "alb_sg" {
  value = aws_security_group.alb_sg.id
}
output "alb_dns" {
  value = aws_elb.alb.dns_name
}
output "zone_id" {
  value = aws_elb.alb.zone_id
}
