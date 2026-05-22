data "archive_file" "lambdaContaProtocolos_zip" {
  type        = "zip"
  source_dir  = "${path.module}/handlers/handler_conta_protocolos/"
  output_path = "${path.module}/handlers/payload/lambda_conta_protocolos_payload.zip"
}

resource "aws_lambda_function" "contaProtocolos" {
  function_name                  = "contaProtocolos"
  filename                       = data.archive_file.lambdaContaProtocolos_zip.output_path
  handler                        = "conta_protocolos.lambda_handler"
  memory_size                    = 128
  package_type                   = "Zip"
  region                         = "us-east-1"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.lambda_role.arn
  runtime                        = "python3.10"
  timeout                        = 3

  source_code_hash = data.archive_file.lambdaContaProtocolos_zip.output_base64sha256

  ephemeral_storage {
    size = 512
  }

  logging_config {
    application_log_level = null
    log_format            = "Text"
    log_group             = "/aws/lambda/contaProtocolos"
    system_log_level      = null
  }

  tracing_config {
    mode = "PassThrough"
  }

  environment {

    variables = {
      DYNAMOBLOG_TABLENAME = aws_dynamodb_table.conta_protocolos.name
    }
  }
}