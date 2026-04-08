# Define the AWS provider configuration.
provider "aws" {
  region = "ap-south-1" # Replace with your desired AWS region.
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "example" {
  key_name   = "terraform-demo-sesha"    # Replace with your desired key name
  public_key = file("~/.ssh/id_rsa.pub") # Replace with the path to your public key file
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_instance" "server" {
  ami                    = "ami-019715e0d74f695be"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id

  # We are telling terraform to connect to the instance using ssh and execute some commands on the remote instance after it is created. 
  connection {
    type        = "ssh"
    user        = "ubuntu"              # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa") # Rceplace with the path to your private key
    host        = self.public_ip        # Self indicates that we want to connect to the instance we are creating, and we are using the public IP address of the instance to connect.
  }

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "app.py"              # Replace with the path to your local file
    destination = "/home/ubuntu/app.py" # Replace with the path on the remote instance
  }
  # Remote-exec provisioner to execute commands on the remote EC2 instance
  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",                               # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip python3-venv", # Install python3-pip and python3-venv packages
      "cd /home/ubuntu",
      # Note: Below commands won't work, so once ec2 is created. login to it and run below commands one by one to run the flask app.
      /*python3 -m venv myenv
      source myenv/bin/activate
      pip install flask
      python app.py*/
      "python3 -m venv myenv", # Create a virtual environment
      # Install flask using venv pip
      "/home/ubuntu/myenv/bin/pip install flask",
      # Run app using venv python (NOT sudo, NOT system python)
      "nohup /home/ubuntu/myenv/bin/python /home/ubuntu/app.py > app.log 2>&1 &"
    ]
  }

  provisioner "local-exec" {
    command = "echo Instance ready at ${self.public_ip}"
  }
}

