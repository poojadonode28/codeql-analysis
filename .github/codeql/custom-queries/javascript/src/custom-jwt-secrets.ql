/**
 * @name Hardcoded JWT Secrets
 * @description Detects hardcoded JWT secrets in JavaScript code
 * @kind problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision high
 * @id js/hardcoded-jwt-secret
 * @tags security
 *       external/cwe/cwe-798
 */

import javascript

from StringLiteral secret, CallExpr jwt
where
  // Find JWT sign or verify calls
  jwt.getCalleeName() in ["sign", "verify"] and
  jwt.getCallee().getAPropertyAccess().getPropertyName() = "jwt" and
  // Find the secret parameter
  secret = jwt.getArgument(1) and
  // Check if it's a hardcoded string
  not secret.getValue().regexpMatch("process\\.env\\..*")
select secret, "JWT secret appears to be hardcoded" 