package database

import (
    "database/sql"
    "fmt"
    _ "github.com/go-sql-driver/mysql"
)

// SECURITY ISSUE: Hardcoded credentials in package
var (
    dbHost = "localhost"
    dbUser = "root"
    dbPass = "admin123"
)

// SECURITY ISSUE: SQL Injection in package function
func QueryUser(id string) (*sql.Rows, error) {
    db, err := sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s:3306)/users", dbUser, dbPass, dbHost))
    if err != nil {
        return nil, err
    }
    defer db.Close()

    // Direct string concatenation leading to SQL injection
    query := "SELECT * FROM users WHERE id = " + id
    return db.Query(query)
} 