variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "on" {
  type    = bool
  default = true
}

variable "service_account_annotations" {
  type    = map(any)
  default = {}
}

variable "deployment_annotations" {
  type    = map(any)
  default = {}
}

variable "replica_count" {
  type    = number
  default = 2
}

variable "chart_version" {
  type    = string
  default = "1.4.2"
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "createIngressClassResource" {
  type        = string
  description = "Choose to create IngressClass resource"
  default     = false
}

variable "priority_class" {
  type        = string
  description = "ALB Priority Class"
  default     = "system-cluster-critical"
}

variable "ingress_class" {
  type        = string
  description = "Ingress class name for the controller"
  default     = "alb"
}

variable "tags" {
  type    = map(string)
  default = {}
}
