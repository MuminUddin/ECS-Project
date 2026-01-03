terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}

provider "aws" {
    region = "eu-west-2"
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = "gatus-muminlabs-s3-bucket"
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}