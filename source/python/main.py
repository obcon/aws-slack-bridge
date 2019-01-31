import json
import requests
import os

def handler(event, context):
    print(json.dumps(event))

    for record in event.get('Records', []):
        if "Sns" in record:
            if record.get('Sns').get('Type') == "Notification":

                subject = record.get('Sns').get('Subject')
                message = json.loads(record.get('Sns').get('Message'))
    
                slack_data = {
                    "username": "Cloudwatch Events",
                    "channel": "#general",
                    "icon_emoji": ":sdicactus2:",
                    "text": subject,
                    "attachments": [{
                      "text": message.get('NewStateReason'),
                      "color": "good" if message.get('NewStateValue') == "OK" else "danger",
                      "fields": [{
                        "title": 'Time',
                        "value": message.get('StateChangeTime'),
                        "short": True,
                      }, {
                        "title": 'Alarm',
                        "value": message.get('AlarmName'),
                        "short": True,
                      }, {
                        "title": 'Account',
                        "value": message.get('AWSAccountId'),
                        "short": True,
                      }, {
                        "title": 'Region',
                        "value": message.get('Region'),
                        "short": True,
                      }]
                    }]
                }
    
                post(slack_data)


    slack_data_example = {
        "username": "obcon",
        "channel": "#general",
        "icon_emoji": ":obcon:",
        "attachments": [
            {
                "title": "obcon status event",
                "text": "state"
            }
        ]
    }
 

def post(slack_data):
    response = requests.post(
        os.environ['webhook'], data=json.dumps(slack_data),
        headers={'Content-Type': 'application/json'}
    )
