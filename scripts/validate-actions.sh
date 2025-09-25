#!/bin/bash
set -euo pipefail

# Validate action.yml files for syntax and required fields

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "🔍 Validating GitHub Actions..."

# Find all action.yml files
ACTION_FILES=$(find "${REPO_ROOT}" -name "action.yml" -o -name "action.yaml")
FAILED=0

for ACTION_FILE in ${ACTION_FILES}; do
    echo -n "Checking ${ACTION_FILE}... "
    
    # Check YAML syntax
    if ! python3 -c "import yaml; yaml.safe_load(open('${ACTION_FILE}'))" 2>/dev/null; then
        echo "❌ Invalid YAML"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    # Check required fields using python
    NAME=$(python3 -c "import yaml; print(yaml.safe_load(open('${ACTION_FILE}')).get('name', ''))")
    DESC=$(python3 -c "import yaml; print(yaml.safe_load(open('${ACTION_FILE}')).get('description', ''))")
    RUNS=$(python3 -c "import yaml; print(yaml.safe_load(open('${ACTION_FILE}')).get('runs', ''))")
    
    if [[ -z "${NAME}" ]]; then
        echo "❌ Missing 'name' field"
        FAILED=$((FAILED + 1))
    elif [[ -z "${DESC}" ]]; then
        echo "❌ Missing 'description' field"
        FAILED=$((FAILED + 1))
    elif [[ -z "${RUNS}" ]]; then
        echo "❌ Missing 'runs' field"
        FAILED=$((FAILED + 1))
    else
        echo "✅"
    fi
done

if [[ ${FAILED} -eq 0 ]]; then
    echo "✅ All actions validated successfully"
    exit 0
else
    echo "❌ ${FAILED} action(s) failed validation"
    exit 1
fi
