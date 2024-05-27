
module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = module.vpc.vpc_cidr_block
  networks = [
    {
      name     = "private-a"
      new_bits = 2
    },
    {
      name     = "private-b"
      new_bits = 2
    },
    {
      name     = "private-c"
      new_bits = 2
    },
    {
      name     = "public-a"
      new_bits = 8
    },
    {
      name     = "public-b"
      new_bits = 8
    },
    {
      name     = "public-c"
      new_bits = 8
    },
    {
      name     = "database-a"
      new_bits = 8
    },
    {
      name     = "database-b"
      new_bits = 8
    },
    {
      name     = "database-c"
      new_bits = 8
    },
  ]
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "task2-vpc"
    cidr = var.vpc_cidr

    azs = data.aws_availability_zones.available.names

    enable_nat_gateway = true
    single_nat_gateway = false
    one_nat_gateway_per_az = true

    private_subnets = [
        lookup(module.subnet_addrs.network_cidr_blocks, "private-a", "default"),
        lookup(module.subnet_addrs.network_cidr_blocks, "private-b", "default"),
        lookup(module.subnet_addrs.network_cidr_blocks, "private-c", "default")
    ] 
    public_subnets = [
        lookup(module.subnet_addrs.network_cidr_blocks, "public-a", "default"),
        lookup(module.subnet_addrs.network_cidr_blocks, "public-b", "default"),
        lookup(module.subnet_addrs.network_cidr_blocks, "public-c", "default")
    ]
    database_subnets = [
        lookup(module.subnet_addrs.network_cidr_blocks, "database-a", "default"),
        lookup(module.subnet_addrs.network_cidr_blocks, "database-b", "default"),
        lookup(module.subnet_addrs.network_cidr_blocks, "database-c", "default")
    ]

    create_igw = true

    tags = { Owner = var.owner }
}