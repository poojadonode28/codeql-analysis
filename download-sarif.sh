#!/bin/bash

# Read token from .secrets file
TOKEN=$(cat .secrets | grep GITHUB_TOKEN | cut -d'=' -f2)

# Get the latest workflow run ID
WORKFLOW_ID=$(curl -s -H "Authorization: token $TOKEN" \
  "https://api.github.com/repos/poojadonode28/codeql-analysis/actions/workflows" \
  | jq -r '.workflows[] | select(.name=="CodeQL") | .id')

LATEST_RUN=$(curl -s -H "Authorization: token $TOKEN" \
  "https://api.github.com/repos/poojadonode28/codeql-analysis/actions/workflows/$WORKFLOW_ID/runs" \
  | jq -r '.workflow_runs[0].id')

# Get artifacts for the latest run
ARTIFACTS=$(curl -s -H "Authorization: token $TOKEN" \
  "https://api.github.com/repos/poojadonode28/codeql-analysis/actions/runs/$LATEST_RUN/artifacts")

# Get the download URL for the SARIF results
ARTIFACT_ID=$(echo $ARTIFACTS | jq -r '.artifacts[] | select(.name=="codeql-sarif-results") | .id')

# Download the SARIF results
curl -s -L -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/poojadonode28/codeql-analysis/actions/artifacts/$ARTIFACT_ID/zip" \
  --output sarif-results.zip

# Unzip the results
unzip -o sarif-results.zip -d sarif-results
rm sarif-results.zip

echo "SARIF results downloaded to sarif-results directory" 