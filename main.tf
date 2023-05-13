// TODO: add terraform for creating VPC/subnet, for now create manually
// TODO: add certificate, route53, ssl
variable "awsprops" {
    type = map
    default = {
    region = "us-east-1"
    vpc = "vpc-7d627119"
    ami = "ami-007855ac798b5175e"
    itype = "t2.micro"
    subnet = "subnet-f9cfb38f"
    publicip = true
    keyname = "Instance-1-Key-Pair"
    secgroupname = "whatsmyip-sg"
  }
}

provider "aws" {
  region = lookup(var.awsprops, "region")
  profile = "bohalloran"
}

resource "aws_security_group" "whatsmyip-sg-ref" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id = lookup(var.awsprops, "vpc")

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 8080 Transport
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = false
  }
}


resource "aws_instance" "whatsmyip-instance-ref" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = lookup(var.awsprops, "subnet")
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")
  user_data = file("docker-httpd-image.sh")


  vpc_security_group_ids = [
    aws_security_group.whatsmyip-sg-ref.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 50
    volume_type = "gp2"
  }
  tags = {
    Name ="whatsmyip server"
    Environment = "dev"
    OS = "ubuntu"
  }

  depends_on = [ aws_security_group.whatsmyip-sg-ref ]
}


output "external-ip"{
  value = aws_instance.whatsmyip-instance-ref.public_ip
}
