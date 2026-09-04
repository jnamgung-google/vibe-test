#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Deployment Script for Looker BigQuery Writeback Action
# Project: eco-shift-478607-e5
# =============================================================================

PROJECT_ID="${GCP_PROJECT_ID:-eco-shift-478607-e5}"
REGION="${GCP_REGION:-us-central1}"
FUNCTION_NAME="demo-bq-insert-action"
SECRET_NAME="LOOKER_SECRET"

echo "=== Deploying Looker Action to ${PROJECT_ID} (${REGION}) ==="

# 1. Enable APIs
echo "1. Enabling required APIs..."
gcloud services enable \
  run.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  secretmanager.googleapis.com \
  bigquery.googleapis.com \
  --project="${PROJECT_ID}"

# 2. Secret Manager
echo "2. Setting up Secret Manager token..."
if ! gcloud secrets describe "${SECRET_NAME}" --project="${PROJECT_ID}" &>/dev/null; then
  SECRET_VAL=$(openssl rand -hex 32)
  echo -n "${SECRET_VAL}" | gcloud secrets create "${SECRET_NAME}" \
    --data-file=- \
    --replication-policy="automatic" \
    --project="${PROJECT_ID}"
  echo ">>> CREATED LOOKER_SECRET: ${SECRET_VAL}"
else
  echo "Secret ${SECRET_NAME} exists."
fi

# 3. Deploy Function
echo "3. Deploying Cloud Run function..."
gcloud functions deploy "${FUNCTION_NAME}" \
  --gen2 \
  --runtime="nodejs20" \
  --region="${REGION}" \
  --source="." \
  --entry-point="httpHandler" \
  --trigger-http \
  --allow-unauthenticated \
  --set-env-vars="GCP_PROJECT_ID=${PROJECT_ID}" \
  --project="${PROJECT_ID}"

URL=$(gcloud functions describe "${FUNCTION_NAME}" --gen2 --region="${REGION}" --project="${PROJECT_ID}" --format="value(serviceConfig.uri)")

echo "4. Setting CALLBACK_URL_PREFIX..."
gcloud functions deploy "${FUNCTION_NAME}" \
  --gen2 \
  --region="${REGION}" \
  --update-env-vars="CALLBACK_URL_PREFIX=${URL}" \
  --project="${PROJECT_ID}"

# 4. IAM
echo "5. Granting IAM permissions..."
SA_EMAIL=$(gcloud functions describe "${FUNCTION_NAME}" --gen2 --region="${REGION}" --project="${PROJECT_ID}" --format="value(serviceConfig.serviceAccountEmail)")
if [ -z "${SA_EMAIL}" ] || [ "${SA_EMAIL}" = "null" ]; then
  PROJECT_NUM=$(gcloud projects describe "${PROJECT_ID}" --format="value(projectNumber)")
  SA_EMAIL="${PROJECT_NUM}-compute@developer.gserviceaccount.com"
fi

gcloud secrets add-iam-policy-binding "${SECRET_NAME}" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/secretmanager.secretAccessor" \
  --project="${PROJECT_ID}" --quiet || true

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/bigquery.dataEditor" \
  --quiet || true

echo "=== DEPLOYMENT COMPLETE ==="
echo "Action Hub URL: ${URL}"
