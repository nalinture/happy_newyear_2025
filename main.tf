terraform { 
  cloud { 
    
    organization = "newyear" 

    workspaces { 
      name = "happy_newyear_2025" 
    } 
  } 
}

provider "aws" {
  region = "us-east-1"
}

data "aws_s3_bucket" "bucket" {
  bucket = "happynewyear2025"
}

resource "aws_s3_bucket_object" "object" {
  bucket = data.aws_s3_bucket.bucket.id
  key    = "withaudio.html"
  source = "${path.module}/src/withaudio.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "webconfig" {
  bucket = data.aws_s3_bucket.bucket.id

  index_document {
    suffix = "withaudio.html"
  }

}

resource "aws_s3_bucket_policy" "bucketpolicy" {
  bucket = data.aws_s3_bucket.bucket.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "${data.aws_s3_bucket.bucket.arn}/*"
        }
    ]

  })
}
