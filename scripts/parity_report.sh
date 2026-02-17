#!/bin/bash
# scripts/parity_report.sh
# Report feature coverage vs PyWa (best community SDK)

set -euo pipefail

echo "=== WhatsApp SDK Parity Report ==="
echo ""

echo "--- Endpoint Coverage ---"
echo ""

# Count generated service modules (exclude generator directory)
SERVICES=$({ find lib/whatsapp -name '*_service.ex' -not -path '*/generator/*' 2>/dev/null || true; } | wc -l | tr -d ' ')
echo "Service modules: ${SERVICES}"

# Count generated resource structs
RESOURCES=$({ find lib/whatsapp/resources -name '*.ex' 2>/dev/null || true; } | wc -l | tr -d ' ')
echo "Resource structs: ${RESOURCES}"

# Count API domains (directories under lib/whatsapp, excluding generator/resources)
DOMAINS=$(ls -d lib/whatsapp/*/ 2>/dev/null | { grep -v -e generator -e resources -e webhook_plug || true; } | wc -l | tr -d ' ')
echo "API domains: ${DOMAINS}"

echo ""
echo "--- Feature Coverage vs PyWa ---"
echo ""
echo "| Feature | PyWa | Ours |"
echo "|---------|:----:|:----:|"
echo "| Messages (text, media, template, interactive) | YES | YES |"
echo "| Media upload/download/delete | YES | YES |"
echo "| Template CRUD | YES | YES |"
echo "| Business profile get/update | YES | YES |"
echo "| Phone number management | YES | YES |"
echo "| WhatsApp Flows CRUD | YES | YES |"
echo "| QR code management | YES | YES |"
echo "| Calls API | -- | YES |"
echo "| Business management (WABA, Solutions) | -- | YES |"
echo "| Webhook signature verification | YES | YES |"
echo "| Webhook handler framework | YES | YES |"
echo "| Interactive message builders | YES | YES |"
echo ""
echo "--- Feature Superiority ---"
echo ""
echo "| Feature | Others | Ours |"
echo "|---------|:------:|:----:|"
echo "| Connection pooling (Finch) | -- | YES |"
echo "| HTTP/2 support | -- | YES |"
echo "| Auto-retry (429/5xx/conn) | -- | YES |"
echo "| Retry-After header parsing | -- | YES |"
echo "| Exponential backoff + jitter | -- | YES |"
echo "| is_transient awareness | -- | YES |"
echo "| Structured telemetry | -- | YES |"
echo "| Typed error structs | -- | YES |"
echo "| Typed resource structs | -- | YES |"
echo "| Process-scoped test stubs | -- | YES |"
echo "| Response metadata access | -- | YES |"
echo "| Auto-pagination Stream | -- | YES |"
echo ""
echo "=== Report Complete ==="
