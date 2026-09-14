/**
 * Looker Action API Server for BigQuery Writeback (Monthly Sales Price Target)
 * Best Practice: https://cloud.google.com/looker/docs/best-practices/bigquery-writeback-actions
 * Blog Reference: https://discuss.google.dev/t/beyond-dashboards-act-on-your-data-with-looker-actions/256997
 */

const crypto = require("crypto");
const { SecretManagerServiceClient } = require("@google-cloud/secret-manager");
const { BigQuery } = require("@google-cloud/bigquery");

const projectId = process.env.GCP_PROJECT_ID || process.env.GOOGLE_CLOUD_PROJECT || "eco-shift-478607-e5";
const datasetId = process.env.DATASET_ID || "demo_dataset";
const tableId = process.env.TABLE_ID || "demo_table";
const targetsTableId = process.env.TARGETS_TABLE_ID || "monthly_sales_targets";

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
  const bufB = Buffer.allocUnsafe(bLen);
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
  const defaultBaseUrl = `https://us-central1-${projectId}.cloudfunctions.net/demo-bq-insert-action`;
  const baseUrl = (process.env.CALLBACK_URL_PREFIX || defaultBaseUrl).replace(/\/$/, "");
  return {
    label: "Looker BigQuery Writeback Action Hub",
    integrations: [
      {
        name: "demo-bq-insert",
        label: "Update Monthly Sales Target ($)",
        description: "Update the monthly sales_price target for the selected month in BigQuery with live Looker refresh",
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
      service: "looker-bigquery-monthly-sales-target-writeback",
      projectId,
      datasetId,
      targetsTableId,
      hasSecret: !!secret,
      timestamp: new Date().toISOString()
    }
  };
}

async function action0Form(req) {
  const data = (req.body && req.body.data) ? req.body.data : {};
  const clickedValue = data.value ? String(data.value).trim() : "";
  const paramMonth = data.target_month ? String(data.target_month).trim() : "";
  const monthMatch = paramMonth.match(/(\d{4}-\d{2})/) || clickedValue.match(/(\d{4}-\d{2})/);
  const defaultMonth = monthMatch ? monthMatch[1] : new Date().toISOString().slice(0, 7);

  let defaultTarget = data.target_amount ? String(data.target_amount).replace(/[^0-9.]/g, "") : "150000";
  if (!defaultTarget || isNaN(parseFloat(defaultTarget))) {
    defaultTarget = "150000";
  }

  return [
    {
      name: "target_month",
      label: "Target Month (YYYY-MM)",
      type: "string",
      default: defaultMonth,
      description: "수정할 타겟 연월 (예: 2024-05, 2026-09)",
      required: true
    },
    {
      name: "target_amount",
      label: "New Sales Price Target ($)",
      type: "string",
      default: defaultTarget,
      description: "새로운 월간 Sales Price 목표 금액 ($) 입력 (예: 200000)",
      required: true
    },
    {
      name: "note",
      label: "Adjustment Reason / Note",
      type: "textarea",
      default: "월별 매출 타겟 조정",
      description: "타겟 수정 사유 (예: 프로모션 반영 상향 조정)"
    }
  ];
}

async function action0Execute(req) {
  const formParams = req.body.form_params || {};
  const actionParams = req.body.data || {};

  const rawMonthStr = String(
    formParams.target_month || actionParams.target_month || actionParams.value || formParams.choice || ""
  ).trim();
  const execMonthMatch = rawMonthStr.match(/(\d{4}-\d{2})/);
  const targetMonth = execMonthMatch ? execMonthMatch[1] : new Date().toISOString().slice(0, 7);

  const rawAmount = formParams.target_amount || actionParams.target_amount || "150000";
  const cleanedAmount = parseFloat(String(rawAmount).replace(/[^0-9.-]/g, ""));
  const targetAmount = isNaN(cleanedAmount) ? 150000.0 : cleanedAmount;

  const note = formParams.note || actionParams.note || "Updated via Looker Action";
  const updatedBy = actionParams.email || req.headers["x-looker-user-email"] || "looker-user@google.com";
  const nowIso = new Date().toISOString();

  await appendMonthlyTargetToBigQuery(datasetId, targetsTableId, {
    target_month: targetMonth,
    target_amount: targetAmount,
    updated_by: updatedBy,
    updated_at: nowIso,
    note: note
  });

  // Also append audit record to demo_table
  await insertRowToBigQuery(datasetId, tableId, {
    invoked_at: nowIso,
    invoked_by: updatedBy,
    scheduled_plan_id: targetMonth,
    query_result_size: Math.round(targetAmount),
    choice: `Target: $${targetAmount.toLocaleString()}`,
    note: `[${targetMonth}] ${note}`
  });

  return {
    status: 200,
    body: {
      looker: {
        success: true,
        refresh_query: true
      },
      message: `Successfully updated ${targetMonth} Sales Price Target to $${targetAmount.toLocaleString()}`
    }
  };
}

async function appendMonthlyTargetToBigQuery(targetDataset, targetTable, row) {
  try {
    const dataset = bigquery.dataset(targetDataset);
    const table = dataset.table(targetTable);

    const [tableExists] = await table.exists();
    if (!tableExists) {
      console.log(`Table ${targetDataset}.${targetTable} missing. Auto-creating and seeding initial monthly targets...`);
      const schema = [
        { name: "target_month", type: "STRING" },
        { name: "target_amount", type: "FLOAT64" },
        { name: "updated_by", type: "STRING" },
        { name: "updated_at", type: "TIMESTAMP" },
        { name: "note", type: "STRING" }
      ];
      await dataset.createTable(targetTable, { schema });

      // Seed baseline monthly targets for 2024, 2025, 2026 so Looker explore has full year targets ready
      const seedRows = [];
      const seedTime = new Date(Date.now() - 86400000).toISOString();
      for (const year of [2024, 2025, 2026]) {
        const baseAmt = year === 2024 ? 100000.0 : year === 2025 ? 120000.0 : 150000.0;
        for (let m = 1; m <= 12; m++) {
          const monthStr = `${year}-${String(m).padStart(2, "0")}`;
          seedRows.push({
            target_month: monthStr,
            target_amount: baseAmt,
            updated_by: "system-seed@google.com",
            updated_at: seedTime,
            note: "Initial baseline monthly target"
          });
        }
      }
      await table.insert(seedRows);
      console.log(`Seeded ${seedRows.length} baseline monthly target rows.`);
    }

    // Use standard BigQuery DML INSERT so BigQuery immediately invalidates query cache for this table
    const insertSql = `
      INSERT INTO \`${projectId}.${targetDataset}.${targetTable}\`
      (target_month, target_amount, updated_by, updated_at, note)
      VALUES (@target_month, @target_amount, @updated_by, CURRENT_TIMESTAMP(), @note)
    `;
    await bigquery.query({
      query: insertSql,
      params: {
        target_month: row.target_month,
        target_amount: Number(row.target_amount),
        updated_by: row.updated_by,
        note: row.note
      }
    });
    console.log(`Inserted new target row via DML to ${targetDataset}.${targetTable}:`, row);
  } catch (err) {
    console.error("BigQuery targets DML insert error, falling back to streaming insert:", err.message);
    const dataset = bigquery.dataset(targetDataset);
    const table = dataset.table(targetTable);
    await table.insert([row]);
  }
}

async function insertRowToBigQuery(targetDataset, targetTable, row) {
  try {
    const dataset = bigquery.dataset(targetDataset);
    const table = dataset.table(targetTable);

    const [tableExists] = await table.exists();
    if (!tableExists) {
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
  } catch (err) {
    console.error("Audit table insert warning:", err.message);
  }
}
