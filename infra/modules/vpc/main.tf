resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.common_tags, {
    Name = "gatus-vpc-eu-west-2"
  })
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(var.common_tags, {
    Name = "gatus-public-subnet-1"
  })
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(var.common_tags, {
    Name = "gatus-public-subnet-2"
  })
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(var.common_tags, {
    Name = "gatus-private-subnet-1"
  })
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(var.common_tags, {
    Name = "gatus-private-subnet-2"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "gatus-internet-gateway"
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.all_traffic_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.common_tags, {
    Name = "gatus-public-route-table"
  })
}

resource "aws_route_table_association" "public_rta1" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet1.id
}

resource "aws_route_table_association" "public_rta2" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet2.id
}

resource "aws_eip" "eip1" {
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "gatus-elastic-ip-1"
  })
}

resource "aws_eip" "eip2" {
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "gatus-elastic-ip-2"
  })
}

resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.eip1.allocation_id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = merge(var.common_tags, {
    Name = "gatus-nat-gateway-1"
  })
}

resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.eip2.allocation_id
  subnet_id     = aws_subnet.public_subnet2.id

  tags = merge(var.common_tags, {
    Name = "gatus-nat-gateway-2"
  })
}

resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = var.all_traffic_cidr
    nat_gateway_id = aws_nat_gateway.ngw1.id
  }

  tags = merge(var.common_tags, {
    Name = "gatus-private-route-table-1"
  })
}

resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = var.all_traffic_cidr
    nat_gateway_id = aws_nat_gateway.ngw2.id
  }

  tags = merge(var.common_tags, {
    Name = "gatus-private-route-table-2"
  })
}

resource "aws_route_table_association" "private_rta1" {
  route_table_id = aws_route_table.private_rt1.id
  subnet_id      = aws_subnet.private_subnet1.id
}

resource "aws_route_table_association" "private_rta2" {
  route_table_id = aws_route_table.private_rt2.id
  subnet_id      = aws_subnet.private_subnet2.id
}