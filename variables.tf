###########################################
########## Common variables ###############
###########################################

variable "aws_region" {
  type        = string
  description = "AWS region where resources will be deployed"
}

variable "environment" {
  type        = string
  description = "Environment where resources will be deployed (e.g. dev, qa, prod)"
}

variable "client" {
  type        = string
  description = "Client name (e.g. pragma)"
}

variable "project" {
  type        = string
  description = "Project name (e.g. store)"
}

###########################################
############ VPC variables ################
###########################################

variable "cidr_block" {
  type        = string
  description = "The IPv4 CIDR block for the VPC"

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "Must be valid CIDR"
  }
}

variable "instance_tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"

  validation {
    condition     = can(regex("^(default|dedicated)$", var.instance_tenancy))
    error_message = "Invalid tenancy, must be default or dedicated"
  }
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable/disable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable/disable DNS support in the VPC"
  default     = true
}

###########################################
############### IGW variables #############
###########################################

variable "create_igw" {
  type        = bool
  description = "Enable internet gateway creation"
  default     = true
}

###########################################
############### NAT variables #############
###########################################

variable "create_nat" {
  type        = bool
  description = "Enable NAT gateway creation (leave false for free tier)"
  default     = false
}

###########################################
############# subnet variables ############
###########################################

variable "subnet_config" {
  type = map(object({
    custom_routes = list(object({
      destination_cidr_block    = string
      carrier_gateway_id        = optional(string)
      core_network_arn          = optional(string)
      egress_only_gateway_id    = optional(string)
      nat_gateway_id            = optional(string)
      local_gateway_id          = optional(string)
      network_interface_id      = optional(string)
      transit_gateway_id        = optional(string)
      vpc_endpoint_id           = optional(string)
      vpc_peering_connection_id = optional(string)
    }))
    public      = bool
    include_nat = optional(bool, false)
    subnets = list(object({
      cidr_block        = string
      availability_zone = string
    }))
  }))

  description = <<EOF
    Custom subnet and route configuration. It is a map where each key represents a group of subnets (e.g. 'public', 'private', 'service', 'database') and the value is an object with:
    - custom_routes: list of custom routes (destination_cidr_block + optional gateway IDs)
    - public: bool, if true adds 0.0.0.0/0 -> igw on its route table when create_igw = true
    - include_nat: bool, if true adds 0.0.0.0/0 -> nat when create_nat = true
    - subnets: list of subnets with cidr_block and availability_zone suffix (e.g. "a", "b")
  EOF
}

###########################################
############ flow log variables ###########
###########################################

variable "flow_log_retention_in_days" {
  type        = number
  description = "Retention in days for VPC flow logs log group"

  validation {
    condition     = can(regex("^[0-9]*$", var.flow_log_retention_in_days))
    error_message = "Must be a number"
  }
}
