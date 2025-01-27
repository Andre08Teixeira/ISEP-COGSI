package com.payroll;

import io.restassured.RestAssured;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ConfigurableApplicationContext;

import static org.hamcrest.Matchers.containsString;

public class PayrollApplicationTest {
    private static ConfigurableApplicationContext context;

    @BeforeClass
    public static void setUp() {
        context = SpringApplication.run(PayrollApplication.class, new String[]{});
        RestAssured.port = 8080;
    }

    @AfterClass
    public static void tearDown() {
        context.close();
    }

    @Test
    public void testUsersLoaded() {
        RestAssured.get("/employees")
                   .then()
                   .statusCode(200)
                   .body(containsString("Frodo Baggins"));
    }
}