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
echo "[1/6] Enabling required APIs..."
gcloud services enable \
  run.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  secretmanager.googleapis.com \
  bigquery.googleapis.com \
  --project="${PROJECT_ID}"

# 2. Setup BigQuery Table
echo "[2/6] Setting up BigQuery demo_dataset.demo_table..."
bq --project_id="${PROJECT_ID}" mk --dataset --location=US demo_dataset 2>/dev/null || true
bq --project_id="${PROJECT_ID}" mk --table demo_dataset.demo_table \
  invoked_at:TIMESTAMP,invoked_by:STRING,scheduled_plan_id:STRING,query_result_size:INTEGER,choice:STRING,note:STRING 2>/dev/null || true

# 3. Secret Manager
echo "[3/6] Setting up Secret Manager token..."
SECRET_VAL=""
if ! gcloud secrets describe "${SECRET_NAME}" --project="${PROJECT_ID}" &>/dev/null; then
  SECRET_VAL=$(openssl rand -hex 32)
  echo -n "${SECRET_VAL}" | gcloud secrets create "${SECRET_NAME}" \
    --data-file=- \
    --replication-policy="automatic" \
    --project="${PROJECT_ID}"
  echo ">>> CREATED NEW LOOKER_SECRET: ${SECRET_VAL}"
else
  echo "Secret ${SECRET_NAME} already exists."
  SECRET_VAL=$(gcloud secrets versions access latest --secret="${SECRET_NAME}" --project="${PROJECT_ID}" 2>/dev/null || echo "Check Secret Manager for value")
fi

# 4. Deploy Function
echo "[4/6] Deploying Cloud Run function..."
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

echo "[5/6] Setting CALLBACK_URL_PREFIX..."
gcloud functions deploy "${FUNCTION_NAME}" \
  --gen2 \
  --region="${REGION}" \
  --update-env-vars="CALLBACK_URL_PREFIX=${URL}" \
  --project="${PROJECT_ID}"

# 5. IAM Permissions
echo "[6/6] Granting IAM permissions..."
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

echo "================================================================="
echo "✅ DEPLOYMENT TO GCP COMPLETE!"
echo ""
echo "1. Cloud Run Function URL:"
echo "   ${URL}"
echo ""
echo "2. Your LOOKER_SECRET Token:"
echo "   ${SECRET_VAL}"
echo ""
echo "NEXT STEPS (Just 3 clicks in Looker Admin):"
echo "1. Open: https://7933da4d-406b-4c80-af6d-4721b2b6580c.looker.app/admin/actions"
echo "2. Scroll down and click 'Add Action Hub' -> Paste the URL above."
echo "3. Click 'Configure Authorization' -> Paste your LOOKER_SECRET."
echo "4. Toggle 'Demo BigQuery Insert' to ENABLED, and click Save!"
echo "================================================================="
