#!/usr/bin/env bash
set -euo pipefail

echo "Running basic secrets grep scan (excludes node_modules and .git)..."
grep -RIn --exclude-dir=node_modules --exclude-dir=.git -E "(BEGIN RSA PRIVATE KEY|BEGIN PRIVATE KEY|-----BEGIN PRIVATE KEY-----|AKIA[0-9A-Z]{16}|AWS_SECRET_ACCESS_KEY|GITHUB_TOKEN|github_token|PRIVATE KEY|password=)" . || true
echo "Scan complete. Review matches above and in your console output."
