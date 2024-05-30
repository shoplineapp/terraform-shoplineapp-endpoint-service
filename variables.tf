variable "service_name" {
  type        = string
  description = "The name of the endpoint service name."
}

variable "alb_arn" {
  type        = string
  description = "The name of target application load balancer."
}

variable "nlb_tags" {
  type        = map(string)
  description = "A map of tags for the network load balancer."
}

variable "endpoint_service_tags" {
  type        = map(string)
  description = "A map of tags for the endpoint service."
}

variable "principal_arn" {
  type        = string
  description = "A principal arn for the endpoint service."
}

variable "nlb_health_check_path" {
  type        = string
  description = "THe HTTP health check path sent from network load balancer."
}