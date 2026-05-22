output "website_url" {
  description = "URL pública do site estático no S3"
  value       = "http://${aws_s3_bucket_website_configuration.conta_protocolos_website.website_endpoint}"
}

output "api_gateway_url" {
  description = "URL do endpoint da API Gateway"
  value       = aws_apigatewayv2_api.contaProtocolos-API.api_endpoint
}