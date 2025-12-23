\
#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "▶ Running generate.sh"
bash "$WORKSPACE_DIR/generate.sh"

if [[ "${DO_CONSOLIDATE:-no}" == "yes" ]]; then
  echo "▶ Running consolidate.sh"
  bash "$WORKSPACE_DIR/consolidate.sh" "${RUN_DATE:-$(date +%Y%m%d)}"
else
  echo "⏭ Consolidation disabled"
fi

if [[ "${DEST_TYPE:-local}" == "remote" && "${DO_UPLOAD:-no}" == "yes" ]]; then
  echo "▶ Running uploader.sh"
  bash "$WORKSPACE_DIR/uploader.sh"
else
  echo "⏭ Upload disabled (or local destination)"
fi

echo "✅ All operations completed. Check: ${OUTPUT_DIR:-<unset>}"
