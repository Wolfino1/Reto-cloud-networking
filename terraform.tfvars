aws_region  = "us-east-1"
environment = "dev"

cidr_block           = "10.0.0.0/16"
instance_tenancy     = "default"
enable_dns_support   = true
enable_dns_hostnames = true

# Gateways
create_igw = true
create_nat = false

# VPC Flow Logs
flow_log_retention_in_days = 30

# 4 grupos lógicos: public / service / database / reserved
subnet_config = {
  public = {
    public      = true
    include_nat = false

    subnets = [
      {
        cidr_block        = "10.0.0.0/24"
        availability_zone = "a" # us-east-1a
      },
      {
        cidr_block        = "10.0.1.0/24"
        availability_zone = "b" # us-east-1b
      }
    ]

    custom_routes = []
  }

  service = {
    public      = false
    include_nat = true  # pensado para futuro NAT si activas create_nat = true

    subnets = [
      {
        cidr_block        = "10.0.10.0/24"
        availability_zone = "a"
      },
      {
        cidr_block        = "10.0.11.0/24"
        availability_zone = "b"
      }
    ]

    custom_routes = []
  }

  database = {
    public      = false
    include_nat = false

    subnets = [
      {
        cidr_block        = "10.0.20.0/24"
        availability_zone = "a"
      },
      {
        cidr_block        = "10.0.21.0/24"
        availability_zone = "b"
      }
    ]

    custom_routes = []
  }

  reserved = {
    public      = false
    include_nat = false

    subnets = [
      {
        cidr_block        = "10.0.30.0/24"
        availability_zone = "a"
      },
      {
        cidr_block        = "10.0.31.0/24"
        availability_zone = "b"
      }
    ]

    custom_routes = []
  }
}
