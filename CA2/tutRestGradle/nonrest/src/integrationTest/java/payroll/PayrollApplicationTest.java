package payroll;

import io.restassured.RestAssured;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ConfigurableApplicationContext;

import static org.hamcrest.Matchers.containsString;

class PayrollApplicationTest {
    private static ConfigurableApplicationContext context;

    @BeforeAll
    public static void setUp() {
        context = SpringApplication.run(PayrollApplication.class, new String[]{});
        RestAssured.port = 9090;
    }

    @AfterAll
    public static void tearDown() {
        context.close();
    }

    @Test
    void testUserLoaded() {
        RestAssured.get("/employees")
                   .then()
                   .statusCode(200)
                   .body(containsString("Frodo Baggins"));
    }
}
