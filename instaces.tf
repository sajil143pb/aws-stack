#----------------------
# ssh-keypair
#-----------------------

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(".terrakey.pub")
  tags = {
    Name = "${var.project}-key"
  }
}


#----------------------
# aws-security groups
#-----------------------

resource "aws_security_group" "webserver" {
  name        = "webserver"
  description = "Allow TLS inbound traffic"
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0"]
    ipv6_cidr_blocks = [ "::/0" ]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0"]
    ipv6_cidr_blocks = [ "::/0" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

#----------------------
# aws-instances
#-----------------------

resource "aws_instance" "dove-inst" {
  ami                    = var.AMIS[var.REGION]
  instance_type           = "t2.micro"
  availability_zone      = var.zone
  key_name               = "aws_key_pair.deployer.id"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  user_data = file("${path.module}/app1-install.sh")
  tags = {
    Name = "dove_instaces"
  }
}

