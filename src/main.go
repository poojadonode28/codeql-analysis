package main

import (
	"fmt"
	"os/exec"
)

func main() {
	// SECURITY ISSUE: Command Injection vulnerability
	userInput := "ls -la; rm -rf /"
	cmd := exec.Command("sh", "-c", userInput)
	output, _ := cmd.Output()
	fmt.Println(string(output))
}