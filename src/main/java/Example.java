import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class Example {
    public void unsafeSQL(String userInput) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/test", "user", "password");
            // Unsafe: SQL Injection vulnerability
            Statement stmt = conn.createStatement();
            stmt.execute("SELECT * FROM users WHERE id = " + userInput);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        Example example = new Example();
        example.unsafeSQL("1 OR 1=1"); // Potential SQL injection
    }
} 