# Create a Virtual Private Cloud (VPC) with specified CIDR block and enable DNS support and DNS hostnames.
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Create an Internet Gateway (IGW) and attach it to the VPC for internet access.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# Create a NAT Gateway (NGW) with an Elastic IP (EIP) allocation and associate it with the first public subnet.
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nateip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_internet_gateway.igw]
}

# Allocate an Elastic IP (EIP) for the NAT Gateway in the VPC.
resource "aws_eip" "nateip" {
  domain = "vpc"
}

# Create the first private subnet within the VPC with the specified CIDR block and availability zone.
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_1
  availability_zone = var.availability_zone_1
}

# Create the second private subnet within the VPC with the specified CIDR block and availability zone.
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_2
  availability_zone = var.availability_zone_2
}

# Create the first public subnet within the VPC with the specified CIDR block, availability zone, and enable public IP assignment.
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true
}

# Create the second public subnet within the VPC with the specified CIDR block, availability zone, and enable public IP assignment.
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true
}

# Create a route table for the public subnets and define a default route to the Internet Gateway (IGW) for internet access.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}

# Create a default route in the public route table to route all traffic to the Internet Gateway (IGW) for public subnets.
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate the public route table with the first public subnet.
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

# Associate the public route table with the second public subnet.
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

# Create a route table for the private subnets and define a default route to the NAT Gateway (NGW) for internet access.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
}

# Create a default route in the private route table to route all traffic to the NAT Gateway (NGW) for private subnets.
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

# Associate the private route table with the first private subnet.
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

# Associate the private route table with the second private subnet.
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}
