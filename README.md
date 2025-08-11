# Monitoring Stack for EKS

This Terraform project sets up a comprehensive monitoring solution for Amazon EKS using Prometheus, Grafana, and AlertManager.

## Directory Structure

```
monitoring-stack/
├── main.tf                     
├── providers.tf               
├── variables.tf               
├── outputs.tf                 
├── terraform.tfvars           
├── backend.tf                 
├── README.md                  
├── eks/
│   └── eks-cluster.tf         
├── helm/
│   ├── prometheus.tf          
│   └── grafana.tf             
├── ssm/
│   └── secrets.tf             
├── dashboards/
│   └── custom-dashboard.json  
└── alert-rules/
    └── custom-alert-rules.yaml 
```

## Getting Started

### 1. Configure Variables

Edit `terraform.tfvars`:

```hcl
aws_region = "us-west-2"
environment = "production"
cluster_name = "my-monitoring-cluster"
node_group_desired_size = 3
node_group_max_size = 6
node_group_min_size = 1
node_instance_types = ["t3.large"]
prometheus_namespace = "monitoring"
grafana_namespace = "monitoring"
grafana_admin_password = "YourSecurePassword123!"
vpc_cidr = "10.0.0.0/16"
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
```

### 2. Configure Backend

Update `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "monitoring-stack/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

### 3. Deploy

```bash
terraform init
terraform plan
terraform apply
```

### 4. Access Services

```bash
kubectl get svc -n monitoring prometheus-kube-prometheus-prometheus
kubectl get svc -n monitoring grafana
kubectl get svc -n monitoring prometheus-kube-prometheus-alertmanager
```

## Components

- **EKS Cluster**: Kubernetes cluster with worker nodes
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **AlertManager**: Alert routing and notifications
- **AWS Systems Manager**: Secure parameter storage
- **Custom Dashboards**: Pre-configured monitoring dashboards
- **Alert Rules**: Comprehensive alerting for cluster health
