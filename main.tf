data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

locals {
  oidc_eks_url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  oidc_eks_arn = data.aws_iam_openid_connect_provider.this.arn
  tags = merge(var.tags,
  {
    "module" = "terraform-helm-aws-load-balancer-controller"
  })
}

module "alb_role" {
  source         = "./irsa-role"
  oidc_eks_url   = local.oidc_eks_url
  oidc_eks_arn   = local.oidc_eks_arn
  serviceaccount = "aws-load-balancer-controller"
  cluster_name   = var.cluster_name

  namespace     = var.namespace
  aws_role_name = "alb"

  tags = local.tags
}

module "alb_policy" {
  source    = "./policy"
  role_name = module.alb_role.name
}

resource "helm_release" "aws_load_balancer_controller" {
  count      = var.on == true ? 1 : 0
  name       = "aws-load-balancer-controller"
  namespace  = var.namespace
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  atomic     = true
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "replicaCount"
    value = var.replica_count
  }
  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "ingressClass"
    value = var.ingress_class
  }

  set {
    name  = "priorityClassName"
    value = var.priority_class
  }

  set {
    name  = "createIngressClassResource"
    value = var.createIngressClassResource
  }

  dynamic "set" {
    for_each = module.alb_policy.service_account_annotations
    content {
      name  = "serviceAccount.annotations.${replace(set.key, ".", "\\.")}" # https://medium.com/@nitinnbisht/annotation-in-helm-with-terraform-3fa04eb30b6e
      value = set.value
    }
  }
}
