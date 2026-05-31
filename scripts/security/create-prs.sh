#!/usr/bin/env bash
set -euo pipefail

echo "Preparing branches and PRs..."

root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root"

BR1=security/automation-and-hooks
BR2=chore/audit-triage

echo "Branch: $BR1"
git checkout -B "$BR1"
git add .github scripts .husky package.json SECURITY-HARDENING.md || true
if git commit -m "chore(security): add audit & secrets CI, pre-commit hooks, Dependabot"; then
  echo "Committed $BR1"
else
  echo "No changes to commit on $BR1"
fi
git push -u origin "$BR1"

echo "Creating PR for $BR1 (requires gh CLI and auth)"
if command -v gh >/dev/null 2>&1; then
  gh pr create --title "chore: add security automation, secrets scan, and pre-commit hooks" \
    --body "Adds CI audit and secrets-scan workflows, Dependabot config, Husky pre-commit hook, local security scripts, and a SECURITY-HARDENING checklist. Run: npm install && npm run security:triage" \
    --base main --head "$BR1" --draft || echo "gh pr create failed for $BR1"
else
  echo "gh CLI not found — please create the PR for $BR1 manually. Branch pushed."
fi

echo "Branch: $BR2"
git checkout -B "$BR2"
git add AUDIT-TRIAGE.md || true
if git commit -m "chore(security): add AUDIT-TRIAGE summary"; then
  echo "Committed $BR2"
else
  echo "No changes to commit on $BR2"
fi
git push -u origin "$BR2"

echo "Creating PR for $BR2 (requires gh CLI and auth)"
if command -v gh >/dev/null 2>&1; then
  gh pr create --title "chore: audit triage summary" \
    --body "Adds AUDIT-TRIAGE.md with prioritized vulnerability summary and recommended workflow. Run \`npm run security:triage\` for details." \
    --base main --head "$BR2" --draft || echo "gh pr create failed for $BR2"
else
  echo "gh CLI not found — please create the PR for $BR2 manually. Branch pushed."
fi

echo "Done."
