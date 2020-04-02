![Terraform GitHub Actions](https://github.com/mtharpe/consul-aws-demo/workflows/Terraform%20GitHub%20Actions/badge.svg)

# consul-aws
A simple terraform module to spin up a consul cluster on aws.

## Requirements

The following requirements are needed by this module:

- terraform (>= 0.12)

## Providers

The following providers are used by this module:

- aws

- template

## Required Inputs

The following input variables are required:

### subnet\_ids

Description: n/a

Type: `list(string)`

## Optional Inputs

The following input variables are optional (have default values):

### consul\_server\_count

Description: n/a

Type: `string`

Default: `"3"`

### consul\_version

Description: Consul variables

Type: `string`

Default: `"1.1.0"`

### datacenter

Description: n/a

Type: `string`

Default: `"dc1"`

### instance\_type

Description: n/a

Type: `string`

Default: `"c5.large"`

### key\_name

Description: n/a

Type: `string`

Default: `""`

### namespace

Description: Project specific variables

Type: `string`

Default: `"demo"`

### region

Description: AWS specific variables

Type: `string`

Default: `"us-east-1"`

### retry\_join\_tag

Description: n/a

Type: `string`

Default: `"consul"`

### username

Description: n/a

Type: `string`

Default: `"ubuntu"`

### vpc\_security\_group\_ids

Description: n/a

Type: `string`

Default: `""`

## Outputs

The following outputs are exported:

### server\_instance\_ids

Description: n/a

### server\_ips

Description: Outputs

