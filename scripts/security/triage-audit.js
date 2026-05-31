#!/usr/bin/env node
const fs = require('fs')
const path = require('path')

const auditPath = path.resolve(process.cwd(), 'audit.json')
if (!fs.existsSync(auditPath)) {
  console.error('audit.json not found. Run `npm audit --json > audit.json` first.')
  process.exit(2)
}

const raw = JSON.parse(fs.readFileSync(auditPath, 'utf8'))
const vulns = raw.vulnerabilities || {}

const severityOrder = ['critical', 'high', 'moderate', 'low', 'info']
const counts = { critical:0, high:0, moderate:0, low:0, info:0 }
const entries = []

for (const [name, info] of Object.entries(vulns)) {
  const sev = info.severity || 'info'
  if (counts[sev] !== undefined) counts[sev]++
  entries.push({ name, severity: sev, range: info.range || '', fixAvailable: !!info.fixAvailable })
}

console.log('\nVulnerability summary:')
for (const s of severityOrder) {
  console.log(`${s.padEnd(8)} : ${counts[s]}`)
}

console.log('\nTop vulnerable packages:')
entries.sort((a,b) => severityOrder.indexOf(a.severity) - severityOrder.indexOf(b.severity))
entries.slice(0, 40).forEach(e => {
  console.log(`- ${e.name} (${e.severity}) range: ${e.range} fixAvailable: ${e.fixAvailable}`)
})

console.log('\nNotes: prioritize critical/high packages. For direct deps, update package.json; for transitive, consider upgrading parents or filing issues.')
