#!/usr/bin/env bash

set -euo pipefail

API_BASE_URL="${API_BASE_URL:-http://localhost:5000}"
ENDPOINT="${API_BASE_URL}/api/Questionnaires/analyze-and-recommend"
PATIENT_DESCRIPTION="${PATIENT_DESCRIPTION:-Tenho ansiedade intensa, crises de panico e insonia ha meses.}"
EXPECT_NO_FALLBACK="${EXPECT_NO_FALLBACK:-true}"

echo "[AI TEST] Endpoint: ${ENDPOINT}"
echo "[AI TEST] Description: ${PATIENT_DESCRIPTION}"

payload=$(cat <<JSON
{"patientDescription":"${PATIENT_DESCRIPTION}"}
JSON
)

http_code=$(curl -sS -o /tmp/ai_test_response.json -w "%{http_code}" \
  -X POST "${ENDPOINT}" \
  -H 'Content-Type: application/json' \
  -d "${payload}")

echo "[AI TEST] HTTP ${http_code}"

if [[ "${http_code}" != "200" ]]; then
  echo "[AI TEST] FAIL: endpoint returned non-200 response"
  cat /tmp/ai_test_response.json
  exit 1
fi

used_fallback=$(node -e "const fs=require('fs');const data=JSON.parse(fs.readFileSync('/tmp/ai_test_response.json','utf8'));console.log(data?.analysisMetadata?.usedFallback===true?'true':'false');")
analysis_method=$(node -e "const fs=require('fs');const data=JSON.parse(fs.readFileSync('/tmp/ai_test_response.json','utf8'));console.log(data?.analysisMetadata?.analysisMethod ?? 'unknown');")
fallback_reason=$(node -e "const fs=require('fs');const data=JSON.parse(fs.readFileSync('/tmp/ai_test_response.json','utf8'));console.log(data?.analysisMetadata?.fallbackReason ?? 'none');")
total_recommended=$(node -e "const fs=require('fs');const data=JSON.parse(fs.readFileSync('/tmp/ai_test_response.json','utf8'));console.log(Array.isArray(data?.recommendedProfessionals)?data.recommendedProfessionals.length:0);")

echo "[AI TEST] analysisMethod=${analysis_method}"
echo "[AI TEST] usedFallback=${used_fallback}"
echo "[AI TEST] fallbackReason=${fallback_reason}"
echo "[AI TEST] recommendedProfessionals=${total_recommended}"

if [[ "${EXPECT_NO_FALLBACK}" == "true" && "${used_fallback}" == "true" ]]; then
  echo "[AI TEST] FAIL: response used fallback."
  echo "[AI TEST] Hint: configure a valid OpenAI key in OpenAI:ApiKey or OPENAI_API_KEY and ensure outbound access."
  exit 2
fi

echo "[AI TEST] PASS"