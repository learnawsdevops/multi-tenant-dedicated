data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "tenant" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${var.tenant_name}"
  }
}

resource "aws_subnet" "tenant_subnet_1" {
  vpc_id                  = aws_vpc.tenant.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 0)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.tenant_name}-subnet-1"
  }
}

resource "aws_subnet" "tenant_subnet_2" {
  vpc_id                  = aws_vpc.tenant.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.tenant_name}-subnet-2"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "tenant" {
  vpc_id = aws_vpc.tenant.id
  tags = {
    Name = "igw-${var.tenant_name}"
  }
}

# Route Table
resource "aws_route_table" "tenant_public" {
  vpc_id = aws_vpc.tenant.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tenant.id
  }
  tags = {
    Name = "rt-${var.tenant_name}"
  }
}

resource "aws_route_table_association" "tenant_public_1" {
  subnet_id      = aws_subnet.tenant_subnet_1.id
  route_table_id = aws_route_table.tenant_public.id
}

resource "aws_route_table_association" "tenant_public_2" {
  subnet_id      = aws_subnet.tenant_subnet_2.id
  route_table_id = aws_route_table.tenant_public.id
}


