/**
 * @name Custom SQL Injection Detection
 * @description Detects potential SQL injection vulnerabilities in Go code
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id go/custom-sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import go
import DataFlow::PathGraph

class SQLInjectionConfig extends TaintTracking::Configuration {
  SQLInjectionConfig() { this = "SQLInjectionConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(HTTP::RequestBody body |
      source = body
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(SQL::QueryString query |
      sink = query.getAUse()
    )
  }
} 