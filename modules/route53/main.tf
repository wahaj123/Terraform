# resource "aws_route53_zone" "main" {
#   name = "eurustechnologies.info"
# }

# resource "aws_route53_record" "www" {
#   zone_id = "aws_route53_zone.main.zone_id" #Z04575642YVQH8TQL105H"
#   name    = "www.${aws_route53_zone.main.name}"
# type    = "A"
# alias {
#   name                   = var.alb_dns
#   zone_id                = var.zone_id
#   evaluate_target_health = false
# }
# }
# data "aws_route53_zone" "main" {
#   #provider = "aws.dns_zones"
#   name         = "eurustechnologies.info" # Notice the dot!!!
#   private_zone = false
# }

# resource "aws_route53_record" "www" {
#   zone_id = "${data.aws_route53_zone.main.zone_id}"
#   name    = "wahaj.${data.aws_route53_zone.main.name}"
#   type    = "A"
#   alias {
#     name                   = var.alb_dns
#     zone_id                = var.zone_id
#     evaluate_target_health = false
#   }

# }
# data "aws_route53_zone" "selected" {
#   name         = "test.com."
# }

# resource "aws_route53_record" "www" {
#   zone_id = data.aws_route53_zone.selected.zone_id 
#   name    = "dev.${data.aws_route53_zone.selected.name}"
#   type    = "A"
#   alias {
#     name                   = var.alb_dns
#     zone_id                = var.zone_id
#     evaluate_target_health = false
#   }
# }
data "aws_route53_zone" "zone" {
  name         = "eurustechnologies.info"
  private_zone = false #important otherwise vpcid is required error
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "wahaj-${terraform.workspace}.eurustechnologies.info"
  type    = "A"
  alias {
    name                   = var.alb_dns
    zone_id                = var.zone_id
    evaluate_target_health = false
  }
}
