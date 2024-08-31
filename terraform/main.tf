data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.ec2.key_name
  subnet_id     = var.private_subnet
  user_data = templatefile("./userdata.sh", {
    path    = var.path
    git_url = var.git_url
  })
  vpc_security_group_ids = [aws_security_group.example.id]
  security_groups        = []

  tags = {
    Name = "HelloWorld"
  }
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

resource "aws_key_pair" "ec2" {
  key_name   = "kjb-ec2-key-web"
  public_key = file("/Users/kevin/.ssh/id_rsa_ec2.pub")
}

resource "aws_security_group" "example" {
  vpc_id = var.vpc
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}