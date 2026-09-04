/**
 * Looker Action API Server for BigQuery Writeback
 * Best Practice: https://cloud.google.com/looker/docs/best-practices/bigquery-writeback-actions
 */

const crypto = require("crypto");
const { SecretManagerServiceClient } = require("@google-cloud/secret-manager");
const { BigQuery } = require("@google-cloud/bigquery");

const projectId = process.env.GCP_PROJECT_ID || process.env.GOOGLE_CLOUD_PROJECT || "eco-shift-478607-e5";
const datasetId = process.env.DATASET_ID || "demo_dataset";
const tableId = process.env.TABLE_ID || "demo_table";

const secrets = new SecretManagerServiceClient();
const bigquery = new BigQuery({ projectId });

let cachedSecret = null;

async function getLookerSecret() {
  if (process.env.LOOKER_SECRET) {
    return process.env.LOOKER_SECRET;
  }
  if (cachedSecret) {
    return cachedSecret;
  }
  try {
    const name = `projects/${projectId}/secrets/LOOKER_SECRET/versions/latest`;
    const [version] = await secrets.accessSecretVersion({ name });
    cachedSecret = version.payload.data.toString("utf8").trim();
    return cachedSecret;
  } catch (err) {
    console.warn("LOOKER_SECRET not available in Secret Manager yet:", err.message);
    return null;
  }
}

function timingSafeEqual(a, b) {
  if (typeof a !== "string" || typeof b !== "string") return false;
  const aLen = Buffer.byteLength(a);
  const bLen = Buffer.byteLength(b);
  const bufA = Buffer.allocUnsafe(aLen);
  bufA.write(a);
  const bufB = Buffer.allocUnsafe(aLen);
  bufB.write(b);
  return crypto.timingSafeEqual(bufA, bufB) && aLen === bLen;
}

async function requireInstanceAuth(req) {
  const lookerSecret = await getLookerSecret();
  if (!lookerSecret) {
    console.warn("LOOKER_SECRET is not set. Bypassing token auth for initialization test.");
    return null;
  }
  const expectedAuthHeader = `Token token="${lookerSecret}"`;
  const incomingAuth = req.headers.authorization || "";
  if (!timingSafeEqual(incomingAuth, expectedAuthHeader)) {
    return {
      status: 401,
      body: { error: "Looker instance authentication failed: invalid token" }
    };
  }
  return null;
}

const routes = {
  "/": [hubListing],
  "/status": [hubStatus],
  "/action-0/form": [requireInstanceAuth, action0Form],
  "/action-0/execute": [requireInstanceAuth, action0Execute]
};

exports.httpHandler = async function httpHandler(req, res) {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  try {
    const normalizedPath = req.path.replace(/\/$/, "") || "/";
    const routeHandlerSequence = routes[normalizedPath] || [routeNotFound];

    for (let handler of routeHandlerSequence) {
      let handlerResponse = await handler(req);
      if (!handlerResponse) continue;
      return res
        .status(handlerResponse.status || 200)
        .json(handlerResponse.body || handlerResponse);
    }
  } catch (err) {
    console.error("Unhandled error:", err);
    res.status(500).json({ error: "Unhandled error. See logs for details.", details: err.message });
  }
};

function routeNotFound(req) {
  return {
    status: 404,
    body: { error: `Path '${req.path}' not found` }
  };
}

async function hubListing(req) {
  const baseUrl = process.env.CALLBACK_URL_PREFIX || `https://${req.headers.host}`;
  return {
    integrations: [
      {
        name: "demo-bq-insert",
        label: "Demo BigQuery Insert",
        description: "Appends selected query/cell rows to BigQuery demo_table",
        supported_action_types: ["cell", "query", "dashboard"],
        form_url: `${baseUrl}/action-0/form`,
        url: `${baseUrl}/action-0/execute`,
        supported_formats: ["inline_json"],
        supported_formattings: ["unformatted"],
        params: [
          { name: "email", label: "Email", user_attribute_name: "email", required: true }
        ]
      }
    ]
  };
}

async function hubStatus(req) {
  const secret = await getLookerSecret();
  return {
    status: 200,
    body: {
      status: "healthy",
      service: "looker-bigquery-writeback",
      projectId,
      datasetId,
      tableId,
      hasSecret: !!secret,
      timestamp: new Date().toISOString()
    }
  };
}

async function action0Form(req) {
  return [
    {
      name: "choice",
      label: "Choose",
      type: "select",
      options: [
        { name: "Yes", label: "Yes" },
        { name: "No", label: "No" },
        { name: "Maybe", label: "Maybe" }
      ],
      default: "Yes"
    },
    {
      name: "note",
      label: "Note",
      type: "textarea"
    }
  ];
}

async function action0Execute(req) {
  const formParams = req.body.form_params || {};
  const actionParams = req.body.data || {};
  const scheduledPlanId = req.body.scheduled_plan ? req.body.scheduled_plan.scheduled_plan_id : null;
  const queryData = req.body.attachment && req.body.attachment.data ? req.body.attachment.data : [];

  const row = {
    invoked_at: new Date().toISOString(),
    invoked_by: actionParams.email || req.headers["x-looker-user-email"] || "looker-user@example.com",
    scheduled_plan_id: scheduledPlanId ? String(scheduledPlanId) : null,
    query_result_size: Array.isArray(queryData) ? queryData.length : 1,
    choice: formParams.choice || actionParams.choice || "Yes",
    note: formParams.note || actionParams.note || ""
  };

  await insertRowToBigQuery(datasetId, tableId, row);

  return {
    status: 200,
    body: {
      looker: { success: true, refresh_query: false },
      message: `Successfully inserted row into ${datasetId}.${tableId}`
    }
  };
}

async function insertRowToBigQuery(targetDataset, targetTable, row) {
  try {
    const dataset = bigquery.dataset(targetDataset);
    const table = dataset.table(targetTable);

    const [tableExists] = await table.exists();
    if (!tableExists) {
      console.log(`Table ${targetDataset}.${targetTable} missing. Auto-creating table...`);
      const schema = [
        { name: "invoked_at", type: "TIMESTAMP" },
        { name: "invoked_by", type: "STRING" },
        { name: "scheduled_plan_id", type: "STRING" },
        { name: "query_result_size", type: "INTEGER" },
        { name: "choice", type: "STRING" },
        { name: "note", type: "STRING" }
      ];
      await dataset.createTable(targetTable, { schema });
    }

    await table.insert([row]);
    console.log(`Appended row to ${targetDataset}.${targetTable}:`, row);
  } catch (err) {
    if (err.name === "PartialFailureError") {
      console.error("Partial failure inserting into BigQuery:", JSON.stringify(err.errors));
    } else {
      console.error("BigQuery insert error:", err);
    }
    throw err;
  }
}
