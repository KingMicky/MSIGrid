output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  value       = module.eks.cluster_version
}

output "node_groups" {
  description = "EKS node groups"
  value       = module.eks.node_groups
}

output "prometheus_service_url" {
  description = "URL for Prometheus service"
  value       = module.helm.prometheus_service_url
}

output "grafana_service_url" {
  description = "URL for Grafana service"
  value       = module.helm.grafana_service_url
}

output "grafana_admin_credentials_secret" {
  description = "Name of the secret containing Grafana admin credentials"
  value       = module.ssm.grafana_admin_secret_name
  sensitive   = true
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.eks.vpc_id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.eks.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.eks.public_subnets
}
