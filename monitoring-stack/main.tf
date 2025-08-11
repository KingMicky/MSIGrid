terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

locals {
  cluster_name = var.cluster_name
  region       = var.aws_region

  common_tags = {
    Environment = var.environment
    Project     = "monitoring-stack"
    ManagedBy   = "terraform"
  }
}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

module "eks" {
  source = "./eks"

  cluster_name = var.cluster_name
  environment  = var.environment
  common_tags  = local.common_tags
}

module "helm" {
  source = "./helm"

  cluster_name = local.cluster_name
  environment  = var.environment
  depends_on   = [module.eks]
}

module "ssm" {
  source = "./ssm"

  environment = var.environment
  common_tags = local.common_tags
}
