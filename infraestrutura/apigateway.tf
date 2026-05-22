#aqui eu vou importar tanto a api gateway quanto a integração com a lambda, e também irei importar as rotas
resource "aws_apigatewayv2_api" "contaProtocolos-API" {

  description     = "Created by AWS Lambda"
  ip_address_type = "ipv4"
  name            = "contaProtocolos-API"
  protocol_type   = "HTTP"
  region          = "us-east-1"

  cors_configuration {
    allow_credentials = false
    allow_headers = [
      "authorization",
      "content-type",
    ]
    allow_methods = [
      "GET",
      "OPTIONS",
      "POST",
      "PUT",
      "DELETE",
    ]
    allow_origins = [
      "*",
    ]
    expose_headers = []
    max_age        = 0
  }
}

#============ INTEGRAÇÕES  LAMBDA ============
resource "aws_apigatewayv2_integration" "contaProtocolos-integration" {
  api_id                 = aws_apigatewayv2_api.contaProtocolos-API.id
  integration_uri        = aws_lambda_function.contaProtocolos.invoke_arn
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0"
  region                 = "us-east-1"
  timeout_milliseconds   = 30000
}




#============ ROTAS DEPOIMENTOS============
resource "aws_apigatewayv2_route" "route_protocolos_post" {
  api_id    = aws_apigatewayv2_api.contaProtocolos-API.id
  route_key = "POST /protocolos"
  target    = "integrations/${aws_apigatewayv2_integration.contaProtocolos-integration.id}"
}

resource "aws_apigatewayv2_route" "route_protocolos_get" {
  api_id    = aws_apigatewayv2_api.contaProtocolos-API.id
  route_key = "GET /protocolos"
  target    = "integrations/${aws_apigatewayv2_integration.contaProtocolos-integration.id}"
}


resource "aws_apigatewayv2_route" "route_protocolos_put" {
  api_id    = aws_apigatewayv2_api.contaProtocolos-API.id
  route_key = "PUT /protocolos"
  target    = "integrations/${aws_apigatewayv2_integration.contaProtocolos-integration.id}"
}


resource "aws_apigatewayv2_route" "route_protocolos_delete" {
  api_id    = aws_apigatewayv2_api.contaProtocolos-API.id
  route_key = "DELETE /protocolos"
  target    = "integrations/${aws_apigatewayv2_integration.contaProtocolos-integration.id}"
}


#============ STAGES ============

#criando um no stage por questões de padronização, ainda que o stage "default" já exista
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.contaProtocolos-API.id
  name        = "production"
  auto_deploy = true
}

#esse estage possui os 4 metodos, portanto é necessario dar permissao para todos os metodos
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contaProtocolos.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.contaProtocolos-API.execution_arn}/production/*"
}