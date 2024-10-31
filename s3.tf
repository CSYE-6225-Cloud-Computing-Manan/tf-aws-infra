# Generate a UUID for the bucket name
resource "random_uuid" "uuid" {}

# Create S3 bucket with private access
resource "aws_s3_bucket" "bucket" {
  bucket        = random_uuid.uuid.result
  force_destroy = true

  tags = {
    Name        = "CSYE-6225-webapp-S3"
    Environment = var.aws_profile
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle_config" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id     = var.s3_rule_id
    status = var.s3_rule_status

    transition {
      days          = 30
      storage_class = var.storage_class
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.s3_encryption_algorithm
    }
  }
}

# Optional: output the bucket name
output "bucket_name" {
  description = "value of the bucket name"
  value       = aws_s3_bucket.bucket.bucket
}
