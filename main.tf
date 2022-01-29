terraform {
  backend "s3" {
      bucket = "terraformbucket30"
      encrypt = true
      key = "path/to/my/key"
      region = "us-east-1"
  }
}
