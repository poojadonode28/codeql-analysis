package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os/exec"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

// SECURITY ISSUE 1: Hardcoded credentials
const (
	dbUser     = "admin"
	dbPassword = "password123"
	dbName     = "myapp"
)

func main() {
	r := gin.Default()

	// SECURITY ISSUE 2: Command Injection vulnerability
	r.GET("/execute", func(c *gin.Context) {
		command := c.Query("cmd")
		cmd := exec.Command("sh", "-c", command)
		output, _ := cmd.Output()
		c.String(200, string(output))
	})

	// SECURITY ISSUE 3: SQL Injection vulnerability
	r.GET("/user/:id", func(c *gin.Context) {
		id := c.Param("id")
		db, _ := sql.Open("mysql", fmt.Sprintf("%s:%s@/%s", dbUser, dbPassword, dbName))
		defer db.Close()

		query := "SELECT * FROM users WHERE id = " + id
		rows, _ := db.Query(query)
		defer rows.Close()

		// Process rows...
		c.String(200, "Query executed")
	})

	// SECURITY ISSUE 4: Insecure direct object reference
	r.GET("/files/:filename", func(c *gin.Context) {
		filename := c.Param("filename")
		c.File(filename)
	})

	if err := r.Run(":8080"); err != nil {
		log.Fatal(err)
	}
} 