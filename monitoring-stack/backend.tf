terraform {
  backend "s3" {
    bucket         = "jo-bucket-131798512935"
    key            = "monitoring-stack/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}