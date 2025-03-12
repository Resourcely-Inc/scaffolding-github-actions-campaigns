# main.tf

resource "aws_s3_bucket" "campaigns-resource_ckaMshbmm94dxCHA" {
  bucket = "campaigns-resource-test-bucket"
}

resource "aws_s3_bucket_public_access_block" "campaigns-resource_ckaMshbmm94dxCHA" {
  bucket                  = aws_s3_bucket.campaigns-resource_ckaMshbmm94dxCHA.id
  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "campaigns-resource_ckaMshbmm94dxCHA" {
  bucket = aws_s3_bucket.campaigns-resource_ckaMshbmm94dxCHA.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "campaigns-resource_ckaMshbmm94dxCHA" {
  bucket = aws_s3_bucket.campaigns-resource_ckaMshbmm94dxCHA.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_db_instance" "campaigns-resource_ckaMshbmm94dxCHA" {
  allocated_storage    = 75
  db_name              = "my-database"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  storage_encrypted    = false

  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}

resource "aws_vpc" "campaigns-resource_ckaMshbmm94dxCHA" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "campaigns-subnet-resource_ckaMshbmm94dxCHA" {
  vpc_id            = aws_vpc.campaigns-resource_ckaMshbmm94dxCHA.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "tf-example"
  }
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "c6a.2xlarge"
  subnet_id     = aws_subnet.campaigns-subnet-resource_ckaMshbmm94dxCHA.id

  cpu_options {
    core_count       = 2
    threads_per_core = 2
  }

  tags = {
    Name = "tf-example"
  }
}
