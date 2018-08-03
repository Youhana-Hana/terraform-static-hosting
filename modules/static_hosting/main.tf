data "template_file" "static_hosting_policy" {
  template = "${file("${path.module}/policy.tpl")}"
  vars {
    bucket_name = "${var.bucket_name}"
 }
}

resource "aws_s3_bucket" "static_hosting_logging" {
  bucket = "${var.logging_bucket_name}"
  acl ="log-delivery-write"
}

resource "aws_s3_bucket" "static_hosting" {
  bucket = "${var.bucket_name}"
  acl = "public-read"
  policy = "${data.template_file.static_hosting_policy.rendered}"

  cors_rule {
    allowed_headers = "${var.cors_allowed_headers}"
    allowed_methods = "${var.cors_allowed_methods}"
    allowed_origins = "${var.cors_allowed_origins}"
    expose_headers = "${var.cors_expose_headers}"
    max_age_seconds = "${var.cors_max_age_seconds}"
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.static_hosting_logging.id}"
    target_prefix = "log/"
  }
} 

