{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "S3Readonly",
        "Effect": "Allow",
        "Principal": "*",
        "Action": ["S3:GetObject"],
        "Resource": ["arn:aws:s3:::${bucket_name}/*"]
    }]
}
