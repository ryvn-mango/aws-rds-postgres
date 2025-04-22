# AWS RDS PostgreSQL Terraform Module

This Terraform module provisions a PostgreSQL database instance on Amazon RDS with configurable settings and security groups.

## Features

- Creates a PostgreSQL RDS instance with customizable configuration
- Sets up a dedicated VPC security group with configurable access rules
- Configures subnet groups for the RDS instance
- Supports encryption, backups, and maintenance windows
- Generates random pet names for resource identification

## Usage

```hcl
module "postgres" {
  source = "github.com/ryvn-technologies/aws-rds-postgres"

  # Required variables
  vpc_id        = "vpc-xxxxxxxx"
  subnet_ids    = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
  database_name = "myapp"
  username      = "dbadmin"
  password      = "your-secure-password"

  # Optional variables
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  
  # Configure access rules
  ingress_cidr_blocks = ["10.0.0.0/8"]  # Restrict access to internal network
  
  tags = {
    Environment = "production"
    Project     = "myapp"
  }
}
```

## Requirements

- Terraform >= 1.0.0
- AWS Provider >= 4.0.0
- Random Provider >= 3.0.0

## Providers

| Name   | Version |
|--------|---------|
| aws    | >= 4.0.0 |
| random | >= 3.0.0 |

## Inputs

### Required Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| vpc_id | VPC ID where RDS will be deployed | `string` | - |
| subnet_ids | A list of VPC subnet IDs | `list(string)` | - |
| database_name | The name of the database to create | `string` | - |
| username | Username for the master DB user | `string` | - |
| password | Password for the master DB user | `string` | - |

### Optional Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region for the provider configuration | `string` | - |
| engine_version | PostgreSQL engine version | `string` | `"17.4"` |
| instance_class | The instance type of the RDS instance | `string` | `"db.t3.micro"` |
| allocated_storage | The allocated storage in gigabytes | `number` | `20` |
| storage_type | Storage type (standard, gp2, or io1) | `string` | `"gp2"` |
| storage_encrypted | Specifies whether the DB instance is encrypted | `bool` | `true` |
| multi_az | Specifies if the RDS instance is multi-AZ | `bool` | `false` |
| backup_retention_period | The days to retain backups for | `number` | `7` |
| backup_window | The daily time range for automated backups | `string` | `"03:00-04:00"` |
| maintenance_window | The window to perform maintenance in | `string` | `"Mon:04:00-Mon:05:00"` |
| skip_final_snapshot | Skip final snapshot before deletion | `bool` | `false` |
| ingress_cidr_blocks | List of CIDR blocks to allow access to the database | `list(string)` | `["0.0.0.0/0"]` |
| egress_cidr_blocks | List of CIDR blocks to allow egress traffic from the database | `list(string)` | `["0.0.0.0/0"]` |
| tags | A mapping of tags to assign to all resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_id | The RDS instance ID |
| db_instance_address | The address of the RDS instance |
| db_instance_endpoint | The connection endpoint |
| db_instance_port | The database port |
| db_subnet_group_id | The db subnet group name |
| db_security_group_id | The security group ID |

## Security Considerations

- By default, the security group allows inbound access on port 5432 from all IP addresses (0.0.0.0/0). It's strongly recommended to restrict this using the `ingress_cidr_blocks` variable in production environments.
- Database encryption is enabled by default using AWS KMS.
- Final snapshots are created by default when destroying the database (skip_final_snapshot = false).
- The module uses Kubernetes backend configuration. Ensure your Terraform environment is properly configured for this.

## License

This module is maintained by Ryvn Technologies.