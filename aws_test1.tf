provider "aws" {
   region = "us-east-1"
   access_key = "AKIAQO2RQHGXRMST7FOI"
   secret_key = "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"
}


resource "aws_vpc" "main" {
  cidr_block       = "192.158.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags={
    Name = "main vpc"
    Env = "Development"
  }
}

 ################# Subnets #############
resource "aws_subnet" "subnet1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "192.158.1.0/24"
  map_public_ip_on_launch = true


  tags={
    Name = "Pub"
    }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "192.158.2.0/24"
  map_public_ip_on_launch = true



  tags={
    Name = "Priv"
  }
}

######## IGW ###############
resource "aws_internet_gateway" "main-igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags={
    Name = "main-igw"
    Env = "Development"
  }
}


############# Route Tables ##########

resource "aws_default_route_table" "test" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "example"
  }
}


resource "aws_security_group" "test" {
  name        = "test"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 22   
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80   
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 3306  
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}




