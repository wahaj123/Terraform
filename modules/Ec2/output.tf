output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}
output "ec2_instance" {
  value = aws_instance.web.*.id
}

