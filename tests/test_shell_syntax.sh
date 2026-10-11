#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Checking Bash syntax..."

while IFS= read -r -d '' file; do
    echo "Checking: $file"
    bash -n "$file"
done < <(find "$ROOT_DIR/scripts" -type f -name '*.sh' -print0)

echo "PASS: All Bash scripts have valid syntax."
