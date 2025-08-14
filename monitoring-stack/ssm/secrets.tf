resource "aws_ssm_parameter" "grafana_admin_password" {
  name        = "/${var.environment}/monitoring/grafana/admin-password"
  description = "Grafana admin password"
  type        = "SecureString"
  value       = var.grafana_admin_password

  tags = merge(var.common_tags, {
    Name = "grafana-admin-password"
  })
}

resource "aws_ssm_parameter" "prometheus_config" {
  name        = "/${var.environment}/monitoring/prometheus/config"
  description = "Prometheus configuration"
  type        = "String"
  value = jsonencode({
    retention_days = 15
    storage_size   = "50Gi"
    resources = {
      limits = {
        cpu    = "2000m"
        memory = "8Gi"
      }
      requests = {
        cpu    = "1000m"
        memory = "4Gi"
      }
    }
  })

  tags = merge(var.common_tags, {
    Name = "prometheus-config"
  })
}

resource "aws_ssm_parameter" "alertmanager_config" {
  name        = "/${var.environment}/monitoring/alertmanager/config"
  description = "Alert Manager configuration"
  type        = "String"
  value = jsonencode({
    storage_size = "10Gi"
    resources = {
      limits = {
        cpu    = "100m"
        memory = "128Mi"
      }
      requests = {
        cpu    = "50m"
        memory = "64Mi"
      }
    }
  })

  tags = merge(var.common_tags, {
    Name = "alertmanager-config"
  })
}

resource "aws_ssm_parameter" "monitoring_endpoints" {
  name        = "/${var.environment}/monitoring/endpoints"
  description = "Monitoring service endpoints"
  type        = "String"
  value = jsonencode({
    prometheus_url   = "http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090"
    grafana_url      = "http://grafana.monitoring.svc.cluster.local"
    alertmanager_url = "http://prometheus-kube-prometheus-alertmanager.monitoring.svc.cluster.local:9093"
  })

  tags = merge(var.common_tags, {
    Name = "monitoring-endpoints"
  })
}

resource "aws_kms_key" "ssm" {
  description             = "KMS key for SSM parameter encryption"
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "ssm-encryption-key"
  })
}

resource "aws_kms_alias" "ssm" {
  name          = "alias/${var.environment}-monitoring-ssm"
  target_key_id = aws_kms_key.ssm.key_id
}

data "aws_caller_identity" "current" {}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
  default     = "admin123"
}

output "grafana_admin_secret_name" {
  description = "Name of the SSM parameter containing Grafana admin password"
  value       = aws_ssm_parameter.grafana_admin_password.name
}

output "prometheus_config_secret_name" {
  description = "Name of the SSM parameter containing Prometheus configuration"
  value       = aws_ssm_parameter.prometheus_config.name
}

output "alertmanager_config_secret_name" {
  description = "Name of the SSM parameter containing Alert Manager configuration"
  value       = aws_ssm_parameter.alertmanager_config.name
}

output "monitoring_endpoints_secret_name" {
  description = "Name of the SSM parameter containing monitoring endpoints"
  value       = aws_ssm_parameter.monitoring_endpoints.name
}

output "ssm_kms_key_id" {
  description = "KMS key ID for SSM encryption"
  value       = aws_kms_key.ssm.key_id
}

output "ssm_kms_key_arn" {
  description = "KMS key ARN for SSM encryption"
  value       = aws_kms_key.ssm.arn
}