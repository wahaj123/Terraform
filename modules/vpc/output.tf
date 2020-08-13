output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnets_ids" {
  value = "${aws_subnet.public_subnet.*.id}"
}
output "private_subnets_ids" {
  value = "${aws_subnet.private_subnet.*.id}"
}
# output "public_subnet_1" {
#   value = aws_subnet.public_subnet_1.id
# }

# output "public_subnet_2" {
#   value = aws_subnet.public_subnet_2.id
# }

# output "private_subnet_1" {
#   value = aws_subnet.private_subnet_1.id
# }

# output "private_subnet_2" {
#   value = aws_subnet.private_subnet_2.id
# }
