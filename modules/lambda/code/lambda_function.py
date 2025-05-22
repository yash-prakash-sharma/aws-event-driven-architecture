import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    """
    AWS Lambda entrypoint for SQS events.
    Logs each message body to CloudWatch Logs.
    """
    records = event.get("Records", [])
    logger.info(f"Received {len(records)} record(s)")
    
    for record in records:
        # SQS wraps your message in `body`
        body = record.get("body", "")
        
        # If your message is JSON, you can parse it:
        try:
            payload = json.loads(body)
            logger.info(f"Message payload: {json.dumps(payload)}")
        except json.JSONDecodeError:
            # Plain-text body
            logger.info(f"Message body: {body}")
    
    return {
        "status": "processed",
        "count": len(records)
    }