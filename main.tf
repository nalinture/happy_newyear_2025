terraform { 
  cloud { 
    
    organization = "newyear" 

    workspaces { 
      name = "newyear" 
    } 
  } 
}

provider "aws" {
  region = "us-east-1"
}

data "aws_s3_bucket" "bucket" {
  bucket = "birthdaybucket05"
}

resource "aws_s3_bucket_object" "object" {
  for_each = fileset("./", "*")
  bucket = data.aws_s3_bucket.bucket.id
  key    = each.value
  source = "./${each.value}"
  acl = "public-read"
  etag   = filemd5("./${each.value}")
}

resource "aws_s3_bucket_website_configuration" "webconfig" {
  bucket = data.aws_s3_bucket.bucket.id

  index_document {
    suffix = "smile.html"
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
