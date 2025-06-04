#!/bin/bash

# Create directories to simulate JFrog structure
mkdir -p jfrog-simulation/npm-local/codeql-analysis-demo/1.0.0-security-scan
mkdir -p jfrog-simulation/go-local/github.com/yourusername/codeql-analysis-demo/v1.0.0
mkdir -p jfrog-simulation/maven-local/codeql-analysis-demo/1.0-SNAPSHOT

# Simulate SARIF generation for JavaScript
cat > jfrog-simulation/js-analysis.sarif << EOL
{
  "version": "2.1.0",
  "runs": [{
    "results": [{
      "ruleId": "js/hardcoded-credentials",
      "message": {
        "text": "Hardcoded JWT secret found in auth.js"
      },
      "locations": [{
        "physicalLocation": {
          "artifactLocation": {
            "uri": "src/js/main/auth/auth.js"
          },
          "region": {
            "startLine": 9
          }
        }
      }],
      "level": "error"
    }]
  }]
}
EOL

# Create evidence JSON
cat > jfrog-simulation/npm-evidence.json << EOL
{
  "_type": "https://in-toto.io/Statement/v0.1",
  "subject": [{
    "name": "npm-local/codeql-analysis-demo/1.0.0-security-scan",
    "digest": {"sha256": "simulation"}
  }],
  "predicateType": "https://github.com/jfrog/security-scan-evidence/v0.1",
  "predicate": {
    "scanner": {
      "uri": "https://github.com/github/codeql-action",
      "version": "v3",
      "result": $(cat jfrog-simulation/js-analysis.sarif)
    }
  }
}
EOL

# Simulate evidence attachment
cp jfrog-simulation/npm-evidence.json "jfrog-simulation/npm-local/codeql-analysis-demo/1.0.0-security-scan/security-evidence.json"

echo "=== Security Evidence Simulation ==="
echo "1. Package Information:"
echo "   - Name: codeql-analysis-demo"
echo "   - Version: 1.0.0-security-scan"
echo "   - Type: npm package"
echo ""
echo "2. Security Issues Found:"
jq -r '.runs[].results[] | "   - [\(.level | ascii_upcase)] \(.message.text) at \(.locations[0].physicalLocation.uri):\(.locations[0].physicalLocation.region.startLine)"' jfrog-simulation/js-analysis.sarif
echo ""
echo "3. Evidence Location:"
echo "   JFrog Path: npm-local/codeql-analysis-demo/1.0.0-security-scan/security-evidence.json"
echo ""
echo "4. To view evidence content:"
echo "   cat jfrog-simulation/npm-local/codeql-analysis-demo/1.0.0-security-scan/security-evidence.json | jq ." 