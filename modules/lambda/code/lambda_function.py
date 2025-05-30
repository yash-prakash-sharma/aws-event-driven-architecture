import os
import json
import boto3
import logging
from datetime import datetime
from uuid import uuid4
from decimal import Decimal
from fpdf import FPDF
from io import BytesIO

logger = logging.getLogger()
logger.setLevel(logging.INFO)

DYNAMODB_TABLE = os.environ['DYNAMODB_TABLE']
S3_BUCKET = os.environ['S3_BUCKET']
SENDER_EMAIL = os.environ['SENDER_EMAIL']
AWS_REGION = os.environ['REGION_NAME']

dynamodb = boto3.resource('dynamodb', region_name=AWS_REGION)
s3 = boto3.client('s3', region_name=AWS_REGION)
ses = boto3.client('ses', region_name=AWS_REGION)

# Generate receipt content
def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")


def handler(event, context):
    records = event.get('Records', [])
    success_count = 0
    failed_records = []
    for record in records:
        try:
            body = json.loads(record['body'])
            logger.info(f"Processing order: {body}")

            order_id = str(uuid4())
            timestamp = datetime.utcnow().isoformat()
            
            # Save to DynamoDB
            table = dynamodb.Table(DYNAMODB_TABLE)
            total_amount = body.get('total_amount', 0)
            total_amount = Decimal(str(total_amount)) if not isinstance(total_amount, Decimal) else total_amount
            customer_email = body.get('customer_email', 'fallback@example.com')
            item = {
                'order_id': order_id,
                'customer_id': body.get('customer_id', 'unknown'),
                'status': 'processed',
                'created_at': timestamp,
                'total_amount': total_amount,
                'customer_email': customer_email,
                'shipping_address': body.get('shipping_address', ''),
            }
            table.put_item(Item=item)
            
            # Generate PDF receipt content
            pdf = FPDF()
            pdf.add_page()
            pdf.set_font("Arial", size=12)

            pdf.cell(200, 10, txt=f"Order Receipt - {order_id}", ln=True, align='C')
            pdf.ln(10)
            pdf.cell(200, 10, txt=f"Customer ID: {item['customer_id']}", ln=True)
            pdf.cell(200, 10, txt=f"Total Amount: {total_amount}", ln=True)
            pdf.cell(200, 10, txt=f"Shipping Address: {item['shipping_address']}", ln=True)
            pdf.cell(200, 10, txt=f"Status: {item['status']}", ln=True)
            pdf.cell(200, 10, txt=f"Email Address: {item['customer_email']}", ln=True)
            pdf.cell(200, 10, txt=f"Created At: {item['created_at']}", ln=True)

            # Get PDF content as bytes
            pdf_bytes = pdf.output(dest='S').encode('latin1')

            receipt_key = f"receipts/{datetime.utcnow().date()}/{order_id}.pdf"

            # Upload PDF to S3
            s3.put_object(
                Bucket=S3_BUCKET,
                Key=receipt_key,
                Body=pdf_bytes,
                ContentType='application/pdf'
            )
            
            response = ses.send_email(
                Source=SENDER_EMAIL,
                Destination={'ToAddresses': [customer_email]},
                Message={
                    'Subject': {'Data': f"Order Confirmation - {order_id}"},
                    'Body': {
                        'Text': {'Data': f"Your order {order_id} has been processed. Thank you!"},
                        'Html': {'Data': f"<h1>Order Confirmation</h1><p>Your order of value {total_amount} has been processed. Thank you!</p>"}
                    }
                }
            )
            logger.info(f"Email sent to {customer_email}: {response['MessageId']}")

            success_count += 1

        except Exception as e:
            logger.error(f"Error processing record {record.get('messageId', 'unknown')}: {e}")
            failed_records.append({
                'messageId': record.get('messageId', 'unknown'),
                'error': str(e),
                'body': record.get('body')
            })

    result = {
        "status": "partial_success" if failed_records else "success",
        "processed_records": len(records),
        "successful": success_count,
        "failed": len(failed_records),
        "failures": failed_records
    }
    logger.info(f"Processing result: {json.dumps(result)}")
    return result