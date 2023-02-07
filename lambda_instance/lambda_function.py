import boto3
import json
import logging
from botocore.exceptions import ClientError
import os

logger = logging.getLogger(__name__)
logger.setLevel(level=f"{os.getenv('LOG_LEVEL','INFO').upper()}")

REGION = os.environ['REGION']
INSTANCE = os.environ['INSTANCE']
RECIPIENT = os.environ['RECIPIENT']
EMAIL_SNS_TOPIC_ARN = os.environ['EMAIL_SNS_TOPIC_ARN']

instance_ids = []
instance_ids.append(INSTANCE)

recipients = []
recipients.append(RECIPIENT)

boto3_session = boto3.Session()
ec2_client = boto3_session.client('ec2', region_name=REGION)


def handler(event, context):
    logger.debug(json.dumps(event))

    state = get_instance_state(ec2_client, instance_ids)
    action = event['action']

    if action == "START_INSTANCE" and not state:
        try:
            ec2_client.start_instances(InstanceIds=instance_ids)
            logger.info(f"started instances: {instance_ids}")
        except ClientError as client_error:
            if len(recipients) == 1 and recipients[0] == "":
              send_mail(recipients, INSTANCE, action, state)
            logger.error(f"client_error: {json.dumps(client_error)}")
            raise client_error

    elif action == "STOP_INSTANCE" and state == "running":
        try:
            ec2_client.stop_instances(InstanceIds=instance_ids)
            logger.info(f"stopped instances: {instance_ids}")
        except ClientError as client_error:
            if len(recipients) == 1 and recipients[0] == "":
              send_mail(recipients, INSTANCE, action, state)
            logger.error(f"client_error: {json.dumps(client_error)}")
            raise client_error

    elif action == "START_INSTANCE" and state == "running":
        logger.info(f"instances: {instance_ids} already running")

    elif action == "STOP_INSTANCE" and not state:
        logger.info(f"instances: {instance_ids} already stopped")

    else:
        logger.error(f"unsupported action({action}) or state({state}) ")


def get_instance_state(ec2_client, instance_ids):
    state = False

    try:
        response = ec2_client.describe_instance_status(InstanceIds=instance_ids)
    except ClientError as client_error:
        logger.error(f"client_error: {json.dumps(client_error)}")
        raise client_error

    logger.debug(f"instance_state - response: {response}")

    if response['InstanceStatuses'] != []:
        state = response['InstanceStatuses'][0]['InstanceState']['Name']

    return state


def send_mail(recipients, INSTANCE, action, state):
    subject = "[remote-development] Scheduled action FAILED"
    body_text = f"WARNING! Remote-development instance {INSTANCE} could not execute action {action}. Instance is in state {state}."
    body_html = f"""<p>WARNING! Remote-development instance <strong>{INSTANCE}</strong> could not execute action <strong>{action}</strong>.<br /> Instance is in state <strong>{state}</strong>.</p>"""
    message = {'recipient': recipients, 'subject': subject, 'body_text': body_text, 'body_html': body_html}

    sns = boto3.client('sns', region_name='eu-central-1')

    try:
        logger.debug(f"message: {json.dumps(message)}")
        sns.publish(TopicArn=EMAIL_SNS_TOPIC_ARN, Message=json.dumps(message))

    except ClientError as client_error:
        logger.error(client_error)
        raise client_error
