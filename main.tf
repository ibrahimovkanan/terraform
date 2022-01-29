terraform {
  backend "s3" {
      bucket = "terraformbucket30"
      encrypt = true
      key = "terraform.tfstate"
      region = "us-east-1"
  }
}