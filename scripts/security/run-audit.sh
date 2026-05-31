#!/usr/bin/env bash
set -euo pipefail

echo "Installing dependencies (prefer lockfile)..."
(npm ci --no-audit --no-fund || npm install --no-audit --no-fund) || true

echo "Running npm audit..."
npm audit --json > audit.json || true

echo "Running tests..."
(npm test || true)

echo "Audit and tests complete. See audit.json for details."
