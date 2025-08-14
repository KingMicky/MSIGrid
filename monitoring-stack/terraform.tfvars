aws_region = "us-west-1"

environment = "dev"

cluster_name            = "monitoring-cluster"
node_group_desired_size = 2
node_group_max_size     = 4
node_group_min_size     = 1
node_instance_types     = ["t3.medium"]

prometheus_namespace   = "monitoring"
grafana_namespace      = "monitoring"
grafana_admin_password = "SecurePassword123!"

vpc_cidr             = "10.0.0.0/16"
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
