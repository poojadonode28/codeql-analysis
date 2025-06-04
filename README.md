# CodeQL Analysis Demo Project

This project demonstrates various security vulnerabilities that can be detected by CodeQL analysis. It includes examples in JavaScript, Go, and Java.

## Project Structure

```
.
├── src/
│   ├── js/
│   │   └── main/
│   │       └── app.js         # JavaScript application with vulnerabilities
│   ├── go/
│   │   └── main/
│   │       └── main.go        # Go application with vulnerabilities
│   └── java/
│       └── src/main/java/
│           └── com/example/
│               └── SecurityVulnerableApp.java  # Java application with vulnerabilities
├── .github/
│   └── workflows/
│       └── codeql-analysis.yml # CodeQL analysis workflow
├── package.json               # JavaScript dependencies
├── go.mod                    # Go dependencies
└── pom.xml                   # Java dependencies
```

## Security Vulnerabilities

The project includes the following types of vulnerabilities:

1. SQL Injection
2. Command Injection
3. Path Traversal
4. Cross-Site Scripting (XSS)
5. Hardcoded Credentials
6. Insecure Direct Object References
7. Weak JWT Implementation

## Running CodeQL Analysis

The project is configured with GitHub Actions to run CodeQL analysis automatically on:
- Push to main/develop branches
- Pull requests to main/develop branches
- Manual workflow dispatch

## Setup Instructions

### JavaScript
```bash
npm install
npm start
```

### Go
```bash
go mod download
go run src/go/main/main.go
```

### Java
```bash
mvn clean install
java -jar target/codeql-analysis-demo-1.0-SNAPSHOT.jar
```

## CodeQL Analysis Results

The analysis results will be available in the Security tab of your GitHub repository. SARIF files are generated for each language and can be found in the workflow artifacts.