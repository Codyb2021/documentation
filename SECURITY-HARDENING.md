# Security hardening checklist

This file lists recommended steps and quick fixes to improve repository and account security.

1. CI / repo
- Enable the workflows in `.github/workflows/` (added `security.yml` and `secrets-scan.yml`).
- Protect `main` branch with required status checks and required reviewers.
- Enable Dependabot or renovate to keep dependencies up-to-date.

2. Secrets
- Remove any literal secrets from the repo. Use the GitHub Actions secrets store or a secrets manager.
- Rotate any leaked credentials immediately.
- Add a pre-commit hook to scan for secrets (`detect-secrets` or `git-secrets`).

3. Accounts and tokens
- Enable MFA for all GitHub and npm accounts.
- Limit token scopes: prefer fine-grained tokens and short TTLs.
- Rotate tokens when employees leave or when rotation policy requires it.

4. Dependencies
- Address critical/high vulnerabilities first. Use `npm audit` and `npm audit fix` where safe.
- For transitive dependencies, consider upgrades or mitigation (patching, replacing packages).

5. Runtime hardening
- Add Content-Security-Policy and security headers where the site is served (e.g., via the hosting layer or server middleware).
- Configure CORS to allow only required origins.

6. Observability
- Add logging, monitoring, and alerting for build failures and unauthorized access attempts.

7. CI secrets and tokens
- Store secrets in the platform's encrypted secrets store (GitHub Actions secrets).
- Restrict who can edit workflows that have privileges to use secrets.

Quick commands (run locally):
```
./scripts/security/run-audit.sh
./scripts/security/scan-secrets.sh
```

If you want, I can open PRs that:
- Add `detect-secrets` to `devDependencies` and a `pre-commit` hook using `husky`.
- Add Dependabot config.
- Triage `audit.json` and propose dependency updates.
