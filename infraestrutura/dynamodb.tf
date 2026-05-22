resource "aws_dynamodb_table" "conta_protocolos" {
  name         = "conta-protocolos"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "data"

  attribute {
    name = "data"
    type = "S"
  }
}