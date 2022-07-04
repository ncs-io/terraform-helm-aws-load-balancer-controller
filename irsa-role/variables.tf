variable "oidc_eks_url" {
  type = string
}

variable "namespace" {
  type = string
}

variable "serviceaccount" {
  type = string
}

variable "oidc_eks_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "aws_role_name" {
  type    = string
  default = ""
}
