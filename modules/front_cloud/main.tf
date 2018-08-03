locals {
  s3_origin_id = "origin_bucket_${var.bucket_name}"
}

resource "aws_cloudfront_distribution" "s3_static_hosting" {
  origin {
    domain_name = "${var.bucket_regional_domain_name}"
    origin_id = "${local.s3_origin_id}"
  }
  
  enabled = true

  default_cache_behavior {
    allowed_methods = ["GET", "OPTIONS", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "${local.s3_origin_id}"

  forwarded_values {
    query_string = false
    cookies {
      forward = "none"
    }
  }

  min_ttl = 0
  default_ttl = 3600
  max_ttl = 86400
  compress = true
  viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = "${merge("${var.tags}", map("Name", "${var.environment}", "Environment", "${var.environment}"))}"
}
