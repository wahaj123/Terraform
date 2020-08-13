data "template_file" "init" {
  template = "${file("${path.module}/template/userdata.sh")}"
  vars = {
    rds_endpoint = "${var.rds_endpoint}"
    name         = "${var.name}"
    username     = "${var.username}"
    password     = "${var.password}"
  }
}
resource "aws_instance" "web" {
  count                       = var.ec2_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet_id, count.index)
  key_name                    = var.key_name
  source_dest_check           = false
  associate_public_ip_address = false
  security_groups             = [aws_security_group.ec2_sg.id]
  user_data                   = "${data.template_file.init.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.s3access_profile.name}"
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {
    Name = "wahaj-Webserver-${terraform.workspace}-${count.index + 1}"
  }
}
resource "aws_iam_role" "s3access_role" {
  name = "s3access_role-${terraform.workspace}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_instance_profile" "s3access_profile" {
  name = "s3access_profile-${terraform.workspace}"
  role = "${aws_iam_role.s3access_role.name}"
}
resource "aws_iam_role_policy" "s3access_policy" {
  name = "s3access_policy"
  role = "${aws_iam_role.s3access_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg-${terraform.workspace}"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "incoming for ec2-instance"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "incoming for ec2-instance"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}
#https://medium.com/@devopslearning/aws-iam-ec2-instance-role-using-terraform-fa2b21488536
