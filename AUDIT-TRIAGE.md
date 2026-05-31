# Audit triage summary

Run `npm audit --json > audit.json` and `npm run security:triage` for a machine-readable summary. Key findings from the current `audit.json` snapshot:

- Total vulnerabilities: 137
  - critical: 4
  - high: 70
  - moderate: 51
  - low: 12

Top action items

1. Prioritize patching or upgrading packages that introduce `critical` or `high` vulnerabilities. Notable entries include `@babel/traverse` (critical) and several `@graphql-*` packages (high).
2. For direct dependencies: update `package.json` to safe versions and run tests. Use `npm-check-updates` (`ncu`) to help identify non-breaking upgrades.
3. For transitive dependencies: attempt to upgrade the parent packages that depend on vulnerable transitive packages, or open issues with maintainers if no fix exists.
4. If immediate fixes are not available, consider temporary mitigations (sandboxing, limiting inputs, or removing functionality using vulnerable code-paths).

Suggested workflow

1. Run `npm run security:triage` to get a prioritized list.
2. Create separate PRs for each major upgrade (group by package families) and run CI/tests.
3. Merge once CI is green and reviewers approve; for risky updates, test in staging.

Commands

```
npm install
npm run security:triage
./scripts/security/run-audit.sh
```

If you want, I can prepare PRs that upgrade the top 5 high/critical packages one-by-one and run tests for each; say "prepare dep PRs" to continue.
