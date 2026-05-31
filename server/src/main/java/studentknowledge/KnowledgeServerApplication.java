package studentknowledge;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class KnowledgeServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(KnowledgeServerApplication.class, args);
        System.out.println("✅ Server started at http://localhost:8080");
    }
}