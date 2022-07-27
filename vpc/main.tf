resource "aws_vpc" "ECS_VPC" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "Public_Subnet01" {
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.ECS_VPC.id
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "Public_Subnet02" {
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.ECS_VPC.id
  availability_zone = "ap-south-1b"
}

resource "aws_route_table" "Public_RouteTable" {
  vpc_id = aws_vpc.ECS_VPC.id
}

resource "aws_internet_gateway" "IGW" {}

resource "aws_internet_gateway_attachment" "IGW_Attachment" {
  internet_gateway_id = aws_internet_gateway.IGW.id
  vpc_id              = aws_vpc.ECS_VPC.id
}

resource "aws_route" "IGW_Route" {
  route_table_id         = aws_route_table.Public_RouteTable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IGW.id
}

resource "aws_route_table_association" "RouteTableAssoication01" {
  route_table_id = aws_route_table.Public_RouteTable.id
  subnet_id      = aws_subnet.Public_Subnet01.id
}

resource "aws_route_table_association" "RouteTableAssoication02" {
  route_table_id = aws_route_table.Public_RouteTable.id
  subnet_id      = aws_subnet.Public_Subnet02.id
}


resource "aws_security_group" "ELB_SG" {
  name        = "allow http & https"
  description = "Allow HTTP & HTTPS inbound traffic"
  vpc_id      = aws_vpc.ECS_VPC.id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ELB_SG"
  }
}

resource "aws_security_group" "ECS_SG" {
  name        = "allow http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.ECS_VPC.id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ECS_Cluster_SG"
  }
}