provider "aws" {
  region = "${var.region}"
}

module "web_hosting" {
  source = "./modules/static_hosting"

  bucket_name = "${var.bucket_name}"
  logging_bucket_name = "${var.logging_bucket_name}"
}

module "front_cloud" {
  source = "./modules/front_cloud"

  bucket_name = "${var.bucket_name}"
  bucket_regional_domain_name = "${module.web_hosting.bucket_regional_domain_name}"
}

output "cloud_front_domain_name" {
  value = "${module.front_cloud.domain_name}"
}

output "s3_bucket_name" {
  value = "${module.web_hosting.bucket_regional_domain_name}"
}

