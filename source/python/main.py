import json
import requests

def handler(event, context):
    print(json.dumps(event))
