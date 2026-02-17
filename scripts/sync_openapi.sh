#!/bin/bash
# scripts/sync_openapi.sh
# Download the latest WhatsApp Business Platform OpenAPI spec and convert YAML→JSON

set -euo pipefail

REPO="facebook/openapi"
SPEC_DIR="priv/openapi"
VERSION_FILE="OPENAPI_VERSION"

mkdir -p "$SPEC_DIR"

# Get the latest spec file name (matches business-messaging-api_v*.yaml pattern)
LATEST=$(curl -sL "https://api.github.com/repos/${REPO}/contents" | \
  grep -o '"name": "business-messaging-api_v[^"]*\.yaml"' | \
  head -1 | \
  sed 's/"name": "\(.*\)"/\1/')

if [ -z "$LATEST" ]; then
  echo "ERROR: Could not find spec file in ${REPO}"
  exit 1
fi

# Derive JSON filename from YAML filename
JSON_FILE=$(echo "$LATEST" | sed 's/\.yaml$/.json/')

echo "Downloading ${LATEST}..."
curl -sL "https://raw.githubusercontent.com/${REPO}/main/${LATEST}" \
  -o "/tmp/${LATEST}"

# Convert YAML → JSON (uses Python, available on macOS and most CI runners)
echo "Converting YAML → JSON..."
python3 -c "
import yaml, json, sys
with open('/tmp/${LATEST}') as f:
    data = yaml.safe_load(f)
with open('${SPEC_DIR}/${JSON_FILE}', 'w') as f:
    json.dump(data, f, indent=2)
"

rm -f "/tmp/${LATEST}"

# Extract version from filename (e.g., "v23.0" from "business-messaging-api_v23.0.json")
VERSION=$(echo "$JSON_FILE" | sed 's/business-messaging-api_\(v[0-9.]*\)\.json/\1/')
echo "$VERSION" > "$VERSION_FILE"

echo "Synced: ${LATEST} → ${JSON_FILE} (version: ${VERSION})"
echo "Spec saved to: ${SPEC_DIR}/${JSON_FILE}"
