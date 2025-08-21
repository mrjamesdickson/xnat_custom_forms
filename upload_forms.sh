#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   export BASE_URL="https://your-xnat"
#   export XNAT_TOKEN="your_pat_token"            # preferred
#   # OR: export XNAT_USER="admin"; export XNAT_PASS="secret"
#   ./upload_forms.sh subject_consent.json mri_safety_short.json mr_session_qc.json project_intake.json
#
# You can also put BASE_URL and creds in a .env file in the same directory.

if [[ -f ".env" ]]; then
  # shellcheck disable=SC1091
  source .env
fi

if [[ -z "${BASE_URL:-}" ]]; then
  echo "ERROR: Set BASE_URL (e.g., https://xnat.example.org)" >&2
  exit 1
fi

AUTH_ARGS=()
if [[ -n "${XNAT_TOKEN:-}" ]]; then
  AUTH_ARGS=(-H "Authorization: Bearer ${XNAT_TOKEN}")
elif [[ -n "${XNAT_USER:-}" && -n "${XNAT_PASS:-}" ]]; then
  AUTH_ARGS=(-u "${XNAT_USER}:${XNAT_PASS}")
else
  echo "ERROR: Provide XNAT_TOKEN or XNAT_USER/XNAT_PASS env vars." >&2
  exit 1
fi

if [[ "$#" -eq 0 ]]; then
  echo "No files specified. Example:"
  echo "  ./upload_forms.sh *.json"
  exit 1
fi

endpoint="${BASE_URL%/}/xapi/customforms/save"

for f in "$@"; do
  if [[ ! -f "$f" ]]; then
    echo "Skipping missing file: $f"
    continue
  fi
  echo "Uploading: $f"
  http_code=$(curl -sS -o /tmp/xnat_form_resp.json -w "%{http_code}" -X PUT "$endpoint"     -H "Content-Type: application/json;charset=UTF-8" "${AUTH_ARGS[@]}" --data-binary @"$f")

  if [[ "$http_code" == "200" || "$http_code" == "201" ]]; then
    uuid=$(grep -oE '"uuid"\s*:\s*"[^"]+"' /tmp/xnat_form_resp.json | head -n1 | sed -E 's/.*"uuid"\s*:\s*"([^"]+)".*/\1/')
    title=$(grep -oE '"title"\s*:\s*"[^"]+"' "$f" | head -n1 | sed -E 's/.*"title"\s*:\s*"([^"]+)".*/\1/')
    echo "  ✓ Success ($http_code) title='${title:-unknown}' uuid=${uuid:-unknown}"
  else
    echo "  ✗ Failed ($http_code). Response:"
    cat /tmp/xnat_form_resp.json
    exit 1
  fi
done

echo "All done."
