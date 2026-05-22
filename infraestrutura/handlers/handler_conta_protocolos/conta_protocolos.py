from decimal import Decimal
import uuid
import boto3
import json
from datetime import datetime
import os

#Inicializando variaveis de ambiente

table_name = os.environ.get("DYNAMOBLOG_TABLENAME", "PostsBlog")

#cold start
dynamodb = boto3.resource('dynamodb')
table    = dynamodb.Table(table_name)

#CORS headers
CORS_HEADERS = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE,OPTIONS"
}

#Decvimal encoder para lidar com tipos Decimal do DynamoDB+
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return int(obj) if obj % 1 == 0 else float(obj)
        return super(DecimalEncoder, self).default(obj)

def lambda_handler(event, context):
    
    method = event.get("requestContext", {}).get("http", {}).get("method",
                 event.get("httpMethod", ""))
    
    body = json.loads(event.get("body", "{}"))
    
    numero    = body.get("numero")
    data      = body.get("data")
    
     # Preflight CORS
    if method == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            "body": json.dumps({"message": "CORS OK"})
        }
    
    if method == "POST":
        item = {
                "data"            : data,
                "numero"          : numero
                }
        
        table.put_item(Item=item)
        
        return {
                "statusCode": 200,
                "headers": CORS_HEADERS,
                "body": json.dumps({
                "message": "Numero de protocolos salvo com sucesso",
                "item": item
            }, cls=DecimalEncoder)
        }           
        
    if method == "GET":
        response = table.scan()
        items = response.get("Items", [])
        
        # Ordena os registros pela data mais recente (ano-mes-dia)
        items = sorted(items, key=lambda x: x.get('data', ''), reverse=True)
        
        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            # Importante: adicionado cls=DecimalEncoder para não quebrar com os números do DynamoDB
            "body": json.dumps(items, cls=DecimalEncoder)
        }
    return {
        "statusCode": 405,
        "headers": CORS_HEADERS,
        "body": json.dumps({
            "message": "Método não permitido"
        })
    }