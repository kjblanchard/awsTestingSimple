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
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  key_name             = aws_key_pair.ec2.key_name
  subnet_id            = local.private_subnet_ids[0]
  # subnet_id            = local.public_subnet_ids[0]
  iam_instance_profile = aws_iam_instance_profile.dev-resources-iam-profile.name
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
  vpc_id = local.vpc_id

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "TCP"
  #   cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  # }
  # ingress {
  #   from_port   = 8095
  #   to_port     = 8095
  #   protocol    = "UDP"
  #   cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  # }

  ingress {
    from_port   = 8095
    to_port     = 8095
    protocol    = "UDP"
    security_groups = [ aws_security_group.lb.id]
    # self = true
    # cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
