provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
}

data "aws_subnet_ids" "vpc_id" {
  vpc_id = aws_default_vpc.default.id
}

data "aws_subnet" "subnet_ids" {
  for_each = data.aws_subnet_ids.vpc_id.ids
  id       = each.value
}

# Get the list of official Canonical Ubuntu 16.04 AMIs
data "aws_ami" "ubuntu-1604" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-retry-join" {
  name = "${var.namespace}-consul-retry-join"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

}

# Create the policy
resource "aws_iam_policy" "consul-retry-join" {
  name        = "${var.namespace}-consul-retry-join"
  description = "Allows Consul nodes to describe instances for joining."

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    }
  ]
}
POLICY

}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-retry-join" {
  name       = "${var.namespace}-consul-retry-join"
  roles      = [aws_iam_role.consul-retry-join.name]
  policy_arn = aws_iam_policy.consul-retry-join.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-retry-join" {
  name = "${var.namespace}-consul-retry-join"
  role = aws_iam_role.consul-retry-join.name
}

