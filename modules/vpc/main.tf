locals {
  name_prefix = "${var.project}-${var.environment}"

  tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      Terraform   = "true"
      Module      = "vpc"
    },
    var.tags
  )
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-igw"
  })
}

# Route table publique
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-rt-public"
  })
}

# Subnets publics
resource "aws_subnet" "public" {
  for_each = {
    for idx, cidr in var.public_subnets :
    idx => {
      cidr = cidr
      az   = var.azs[idx]
    }
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-public-${each.value.az}"
    Tier = "public"
  })
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway (un seul pour simplifier, AZ[0])
resource "aws_eip" "nat" {
  vpc = true

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-nat"
  })
}

# Route table privée (App / EKS)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-rt-private"
  })
}

# Subnets privés (App / EKS)
resource "aws_subnet" "private" {
  for_each = {
    for idx, cidr in var.private_subnets :
    idx => {
      cidr = cidr
      az   = var.azs[idx]
    }
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-private-${each.value.az}"
    Tier = "private-app"
  })
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# Subnets DB (sans accès direct Internet)
resource "aws_subnet" "db" {
  for_each = {
    for idx, cidr in var.db_subnets :
    idx => {
      cidr = cidr
      az   = var.azs[idx]
    }
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-db-${each.value.az}"
    Tier = "db"
  })
}

# Route table DB (option : NAT ou pas, ici NAT pour patchs)
resource "aws_route_table" "db" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-rt-db"
  })
}

resource "aws_route_table_association" "db" {
  for_each       = aws_subnet.db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.db.id
}

# Subnets EFS (multi-AZ)
resource "aws_subnet" "efs" {
  for_each = {
    for idx, cidr in var.efs_subnets :
    idx => {
      cidr = cidr
      az   = var.azs[idx]
    }
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-efs-${each.value.az}"
    Tier = "efs"
  })
}

# Route table EFS (NAT pour gestion/patchs si besoin)
resource "aws_route_table" "efs" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-rt-efs"
  })
}

resource "aws_route_table_association" "efs" {
  for_each       = aws_subnet.efs
  subnet_id      = each.value.id
  route_table_id = aws_route_table.efs.id
}
