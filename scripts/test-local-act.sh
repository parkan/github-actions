#!/bin/bash
set -euo pipefail

# Test GitHub Actions locally using act
# Requires: act (https://github.com/nektos/act)

# Configuration
ACT_IMAGE="${ACT_IMAGE:-catthehacker/ubuntu:full-latest}"
WORKFLOW_FILE="${1:-.github/workflows/test-actions.yml}"
JOB_NAME="${2:-}"

# Check if act is installed
if ! command -v act &> /dev/null; then
    echo "❌ act is not installed. Install from: https://github.com/nektos/act"
    exit 1
fi

# Check if Podman is available locally
if command -v podman &> /dev/null; then
    echo "✅ Podman detected locally"
    export DOCKER_HOST="${DOCKER_HOST:-unix://$XDG_RUNTIME_DIR/podman/podman.sock}"
fi

# Prepare environment file
cat > test.env <<EOF
SKIP_DOCKER_DISABLE=${SKIP_DOCKER_DISABLE:-false}
SKIP_SYSTEMD_OPS=${SKIP_SYSTEMD_OPS:-true}
ACT_TESTING=true
EOF

echo "🧪 Testing GitHub Actions locally with act..."
echo "   Workflow: ${WORKFLOW_FILE}"
echo "   Job: ${JOB_NAME:-all}"
echo "   Image: ${ACT_IMAGE}"

# Build command
ACT_CMD="act"

if [[ -n "${JOB_NAME}" ]]; then
    ACT_CMD="${ACT_CMD} -j ${JOB_NAME}"
fi

ACT_CMD="${ACT_CMD} \
    -W ${WORKFLOW_FILE} \
    -P ubuntu-latest=${ACT_IMAGE} \
    --env-file test.env \
    --privileged \
    -v"

# Run act
echo "Executing: ${ACT_CMD}"
${ACT_CMD}

# Cleanup
rm -f test.env

echo "✅ Local testing complete"
