resource "aws_s3_bucket" "conta_protocolos_website" {
  bucket = "conta-protocolos-website"

}

resource "aws_s3_bucket_public_access_block" "conta_protocolos_website" {
  bucket = aws_s3_bucket.conta_protocolos_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "conta_protocolos_website" {
  bucket = aws_s3_bucket.conta_protocolos_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.conta_protocolos_website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_versioning" "conta_protocolos_website" {
  bucket = aws_s3_bucket.conta_protocolos_website.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "conta_protocolos_website" {
  bucket = aws_s3_bucket.conta_protocolos_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "arquivos_aplicacao" {
  for_each = fileset("${path.module}/../aplicacao", "**/*")

  bucket = aws_s3_bucket.conta_protocolos_website.id
  key    = each.value
  source = "${path.module}/../aplicacao/${each.value}"

  # ESTA LINHA DIZ AO TERRAFORM PARA CHECAR O CONTEÚDO DO ARQUIVO PARA EVENTUAIS MUDANÇAS, EM VEZ DE APENAS CHECAR O TIMESTAMP
  etag = filemd5("${path.module}/../aplicacao/${each.value}")

  content_type = lookup(
    {
      "html" = "text/html",
      "css"  = "text/css",
      "js"   = "application/javascript",
      "png"  = "image/png",
      "jpg"  = "image/jpeg",
      "jpeg" = "image/jpeg",
      "svg"  = "image/svg+xml",
      "json" = "application/json"
    },
    element(split(".", each.value), length(split(".", each.value)) - 1),
    "binary/octet-stream"
  )
}