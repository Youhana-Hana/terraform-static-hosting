variable "bucket_name" {
}

variable "logging_bucket_name" {
}

variable "cors_allowed_headers" {
  default = ["Authorization"]
}

variable "cors_allowed_methods" {
  default = ["GET"]
}

variable "cors_allowed_origins" {
  default = ["*"]
}

variable "cors_expose_headers" {
  default = []
}

variable "cors_max_age_seconds" {
  default = "3000"
}
