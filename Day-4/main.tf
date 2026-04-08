provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "sesha_ec2_instance" {
  ami           = "ami-019715e0d74f695be" # replace this
  instance_type = "t2.micro"
  subnet_id     = "subnet-0ccf3b66e816dfd2a" # replace this
  tags = {
    Name        = "sesha-ec2-instance"
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraform-backend-bucket-sesha"

  tags = {
    Name        = "terraform-backend-bucket"
    Environment = "dev"
  }
  
}

resource "aws_dynamodb_table" "my-first-table" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  
}
