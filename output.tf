output "nlb_arn" {
  description = "NLB created"
  value       = aws_lb.this.arn
}

output "endpoint_service_arn" {
  description = "Endpoint service created"
  value = aws_vpc_endpoint_service.this.arn
}