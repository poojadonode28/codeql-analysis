package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.io.File;
import java.nio.file.Files;

@SpringBootApplication
@RestController
public class SecurityVulnerableApp {

    // SECURITY ISSUE 1: Hardcoded credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/mydb";
    private static final String DB_USER = "admin";
    private static final String DB_PASS = "password123";

    public static void main(String[] args) {
        SpringApplication.run(SecurityVulnerableApp.class, args);
    }

    // SECURITY ISSUE 2: SQL Injection vulnerability
    @GetMapping("/user/{id}")
    public String getUser(@PathVariable String id) {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement stmt = conn.createStatement();
            stmt.executeQuery("SELECT * FROM users WHERE id = " + id);
            return "Query executed";
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }

    // SECURITY ISSUE 3: Path Traversal vulnerability
    @GetMapping("/file/{filename}")
    public byte[] getFile(@PathVariable String filename) {
        try {
            File file = new File("/app/files/" + filename);
            return Files.readAllBytes(file.toPath());
        } catch (Exception e) {
            return null;
        }
    }

    // SECURITY ISSUE 4: XSS vulnerability
    @GetMapping("/message")
    public String getMessage(@RequestParam String input) {
        return "<div>" + input + "</div>";
    }

    // SECURITY ISSUE 5: Command Injection vulnerability
    @GetMapping("/execute")
    public String executeCommand(@RequestParam String cmd) {
        try {
            Process process = Runtime.getRuntime().exec(cmd);
            return "Command executed";
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }
} 