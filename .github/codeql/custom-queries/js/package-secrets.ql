/**
 * @name Package Secrets Detection
 * @description Detects hardcoded secrets in specific packages
 * @kind problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id js/package-secrets
 * @tags security
 */

import javascript

from StringLiteral secret, File file
where
  // Check if the string looks like a secret
  (
    secret.getValue().regexpMatch("(?i).*key.*|.*secret.*|.*password.*|.*token.*") and
    secret.getValue().length() > 8
  ) and
  // Get the file containing the secret
  secret.getFile() = file and
  // Check if the file is in a specific package
  file.getAbsolutePath().matches("%/auth/%")
select secret, "Potential hardcoded secret found in authentication package" 