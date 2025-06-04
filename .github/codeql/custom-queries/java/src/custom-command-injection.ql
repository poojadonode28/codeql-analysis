/**
 * @name Command Injection Detection
 * @description Detects potential command injection vulnerabilities in Java code
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id java/command-injection
 * @tags security
 *       external/cwe/cwe-078
 */

import java
import semmle.code.java.security.CommandLineQuery
import DataFlow::PathGraph

class CustomCommandInjectionConfig extends TaintTracking::Configuration {
  CustomCommandInjectionConfig() { this = "CustomCommandInjectionConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof CommandLineArgument
  }
} 