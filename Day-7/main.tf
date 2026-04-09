provider "aws" {
  region = "ap-south-1"
}

provider "vault" {
  address = "http://3.110.102.28:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "7431cd02-4a00-eea6-3fc0-73bbec1dbd04"
      secret_id = "d417922f-7135-4a73-6d12-896957277a1e"
    }
  }
}

# Now initialize the providers , comment down the below code before running terraform init command

data "vault_kv_secret_v2" "example" {
  mount = "my-key-value" // change it according to your mount
  name  = "test-secret1" // change it according to your secret
}

# Now execute terraform apply command to see the output of the secret value, comment down the below code before running terraform apply command.

resource "aws_instance" "my_instance" {
  ami           = "ami-0a14f53a6fe4dfcd1"
  instance_type = "t2.micro"

  tags = {
    Name = "my-vault-instance"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}
