output "id" {
  value = "${aws_s3_bucket.bucket.id}"
}

output "aws_kms_key" {
  value = "${aws_kms_key.mykey.arn}"
}
