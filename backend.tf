terraform {
  backend "s3" {
    bucket         = "wahaj-webserver"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraformstate"
  }
}
