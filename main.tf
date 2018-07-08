data "template_file" "force_encrpyt_json" {
  template = "${file("${path.module}/files/force_encrpyt.json")}"

  vars {
    s3_bucket_arn = "${aws_s3_bucket.bucket.arn}"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "${var.name}"
  acl           = "private"

  versioning {
    enabled = true
  }

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.mykey.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "force_encrpyt" {
  bucket = "${aws_s3_bucket.bucket.id}"
  policy = "${data.template_file.force_encrpyt_json.rendered}"
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 30
}
