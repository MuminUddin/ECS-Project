terraform {
  backend "s3" {
    bucket = "gatus-muminlabs-s3-bucket"
    key = "gatus/prod/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    use_lockfile = true
  }
}