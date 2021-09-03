provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "devvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "new-vpc"
  }
}

resource "aws_subnet" "privateA" {
  vpc_id     = aws_vpc.devvpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "private-subnetA"
  }
}

resource "aws_subnet" "publicA" {
  vpc_id     = aws_vpc.devvpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnetA"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.devvpc.id

  tags = {
    Name = "Devgw"
  }
}

resource "aws_route_table" "routetb" {
  vpc_id = aws_vpc.devvpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
  }
	  
  tags = {
    Name = "devrtb"
  }
}

resource "aws_route_table_association" "assotable1" {
  subnet_id      = aws_subnet.privateA.id
  route_table_id = aws_route_table.routetb.id
}

resource "aws_route_table_association" "assotable2" {
  subnet_id      = aws_subnet.publicA.id
  route_table_id = aws_route_table.routetb.id
}
