module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_value = "ami-0a14f53a6fe4dfcd1" # replace this
  instance_type_value = "t2.micro"
  aws_region = "ap-south-1"
  subnet_id_value = "subnet-0ccf3b66e816dfd2a"# replace this
}

module "S3" {
  source = "./modules/S3"
  aws_region = "ap-south-1"
  bucket_name = "my-terraform-bucket-sesha"
  environment = "dev"
}
