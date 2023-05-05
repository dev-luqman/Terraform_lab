

#############################################################
## Variable Section Only
#############################################################

variable "vpc_id" {
  description = "Specify VPC id to modify"
  type        = string
}



#############################################################
## Data Section Only
#############################################################
data "aws_vpc" "main_vpc" {
  id = var.vpc_id

}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["false"]
  }
}


data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }
}


#############################################################
## Resources Created
#############################################################

### Count : base on public_subnets
resource "aws_eip" "nat_ip" {
  # EIP may require IGW to exist prior to association for .  
  count      = length(data.aws_subnets.public_subnets.ids)
  depends_on = [data.aws_internet_gateway.default]
}

resource "aws_nat_gateway" "gw" {
  count         = length(data.aws_subnets.public_subnets.ids)
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = data.aws_subnets.public_subnets.ids[count.index]

  tags = {
    Name = "nat-gateway-${count.index}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = data.aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }
  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private_route_table" {
  count  = length(resource.aws_nat_gateway.gw)
  vpc_id = data.aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = resource.aws_nat_gateway.gw[count.index].id
  }

  tags = {
    Name = "private_route_table-${count.index}"
  }
}

### Public Routing Association
resource "aws_route_table_association" "Public_Route_TA" {
  count          = length(data.aws_subnets.public_subnets.ids)
  subnet_id      = data.aws_subnets.public_subnets.ids[count.index]
  route_table_id = aws_route_table.public_route_table.id
}

### Private Routing Association
resource "aws_route_table_association" "Private_Route_TA" {
  count          = length(data.aws_subnets.private_subnets.ids)
  subnet_id      = data.aws_subnets.private_subnets.ids[count.index]
  route_table_id = resource.aws_route_table.private_route_table[count.index].id
}
