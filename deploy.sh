#!/bin/bash

# 1. Set variables
PROJECT_ID="gudayaswanth-devops"
SERVICE_ACCOUNT="1061499791384@cloudbuild.gserviceaccount.com"
REGION="us-central1"

echo "Step 1: Ensuring IAM permissions for logging..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT" \
    --role="roles/logging.logWriter" --quiet

echo "Step 2: Submitting build to Cloud Build..."
gcloud builds submit --config cloudbuild.yaml .

echo "Step 3: Cleaning up port 8888..."
fuser -k 8888/tcp || true

echo "Step 4: Launching authenticated proxy..."
echo "Once started, click 'Web Preview' -> 'Preview on port 8888'"
gcloud beta run services proxy elevate360-service --region=$REGION --port=8888
