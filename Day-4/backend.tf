# state.tf
terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-sesha" 
    key    = "sesha/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}
