#!/bin/bash

# Create directories
mkdir -p merged-results

# Create JavaScript SARIF
cat > merged-results/analysis.javascript.sarif << EOL
{
  "version": "2.1.0",
  "runs": [{
    "results": [{
      "ruleId": "js/hardcoded-credentials",
      "message": { "text": "Hardcoded JWT secret found in auth.js" },
      "locations": [{
        "physicalLocation": {
          "artifactLocation": { "uri": "src/js/main/auth/auth.js" },
          "region": { "startLine": 9 }
        }
      }],
      "level": "error"
    }]
  }]
}
EOL

# Create Go SARIF
cat > merged-results/analysis.go.sarif << EOL
{
  "version": "2.1.0",
  "runs": [{
    "results": [{
      "ruleId": "go/sql-injection",
      "message": { "text": "SQL injection vulnerability in database query" },
      "locations": [{
        "physicalLocation": {
          "artifactLocation": { "uri": "src/go/pkg/database/db.go" },
          "region": { "startLine": 23 }
        }
      }],
      "level": "error"
    }]
  }]
}
EOL

# Create Java SARIF
cat > merged-results/analysis.java.sarif << EOL
{
  "version": "2.1.0",
  "runs": [{
    "results": [{
      "ruleId": "java/command-injection",
      "message": { "text": "Command injection in process execution" },
      "locations": [{
        "physicalLocation": {
          "artifactLocation": { "uri": "src/java/src/main/java/com/example/SecurityVulnerableApp.java" },
          "region": { "startLine": 45 }
        }
      }],
      "level": "error"
    }]
  }]
}
EOL

# Create package paths
echo "npm-local/codeql-analysis-demo/1.0.0-security-scan" > merged-results/package-path-javascript
echo "go-local/github.com/yourusername/codeql-analysis-demo/v1.0.0" > merged-results/package-path-go
echo "maven-local/codeql-analysis-demo/1.0-SNAPSHOT" > merged-results/package-path-java

# Create combined evidence
echo "=== Creating Combined Evidence ==="

# Get all package paths
PACKAGE_PATHS=()
while IFS= read -r path; do
  PACKAGE_PATHS+=("$path")
done < <(cat merged-results/package-path-*)

# Create combined evidence JSON
jq -n \
  --arg type "https://in-toto.io/Statement/v0.1" \
  --arg predicate_type "https://github.com/jfrog/security-scan-evidence/v0.1" \
  --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
  '{
    "_type": $type,
    "subject": [
      {
        "name": "multi-language-project",
        "digest": {"sha256": "simulation"}
      }
    ],
    "predicateType": $predicate_type,
    "predicate": {
      "scanner": {
        "uri": "https://github.com/github/codeql-action",
        "version": "v3",
        "timestamp": $timestamp,
        "results": {
          "javascript": $(cat merged-results/analysis.javascript.sarif),
          "go": $(cat merged-results/analysis.go.sarif),
          "java": $(cat merged-results/analysis.java.sarif)
        }
      }
    }
  }' > merged-results/combined-evidence.json

echo "=== Evidence Summary ==="
echo "Combined evidence contains results for:"
jq -r '.predicate.scanner.results | to_entries[] | "- \(.key): \(.value.runs[].results | length) findings"' merged-results/combined-evidence.json

echo -e "\nEvidence will be attached to:"
for path in "${PACKAGE_PATHS[@]}"; do
  echo "- $path"
done

echo -e "\nTo view the combined evidence:"
echo "cat merged-results/combined-evidence.json | jq ." 