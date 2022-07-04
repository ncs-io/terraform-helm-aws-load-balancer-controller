data "aws_iam_policy_document" "oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_eks_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.serviceaccount}"]
    }

    principals {
      identifiers = [var.oidc_eks_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_iam_service_role" {
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role_policy.json
  name               = "${var.cluster_name}-${var.namespace}-${var.aws_role_name}"
  tags               = var.tags
}

output "arn" {
  value = aws_iam_role.eks_iam_service_role.arn
}

output "name" {
  value = aws_iam_role.eks_iam_service_role.name
}

