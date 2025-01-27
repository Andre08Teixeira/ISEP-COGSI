package payroll;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class EmployeeTest {

    @Test
    void testEmployeeCreationSuccess() {
        // Test creating a valid employee
        Employee employee = new Employee("David", "Software Engineer", 3, "1181210@isep.ipp.pt");
        
        assertEquals("David", employee.getName());
        assertEquals("Software Engineer", employee.getRole());
        assertEquals(3, employee.getJobYears());
        assertEquals("1181210@isep.ipp.pt", employee.getEmail());
    }

    @Test
    void testEmployeeCreationFailsWhenNameIsNull() {
        // Test creating employee with null name
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            new Employee(null, "Cybersecurity Analyst", 10);
        });
        
        assertEquals("The name can't be null or empty", exception.getMessage());
    }

    @Test
    void testEmployeeCreationFailsWhenRoleIsNull() {
        // Test creating employee with null role
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            new Employee("Rodrigo", null, 8);
        });
        
        assertEquals("The role can't be null or empty", exception.getMessage());
    }

    @Test
    void testEmployeeCreationFailsWhenEmailIsNull() {
        // Test creating employee with null email
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            new Employee("Rodrigo", "Software Engineer", 8, null);
        });
        
        assertEquals("The email can't be null or empty", exception.getMessage());
    }

    @Test
    void testEmployeeCreationFailsWhenNameIsEmpty() {
        // Test creating employee with empty name
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            new Employee("", "Software Engineer", 3);
        });
        
        assertEquals("The name can't be null or empty", exception.getMessage());
    }

    @Test
    void testEmployeeCreationFailsWhenRoleIsEmpty() {
        // Test creating employee with empty role
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            new Employee("Rodrigo", "", 5);
        });
        
        assertEquals("The role can't be null or empty", exception.getMessage());
    }

    @Test
    void testEmployeeCreationFailsWhenJobYearsIsNegative() {
        // Test creating employee with negative job years
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            new Employee("Rodrigo", "Software Engineer", -2);
        });
        
        assertEquals("Job years must be a positive integer", exception.getMessage());
    }

    @Test
    void testEmployeeCreationFailsWhenEmailIsEmpty() {
       // Test creating employee with empty role
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            new Employee("Rodrigo", "Software Engineer", 5, "");
        });
        
        assertEquals("The email can't be null or empty", exception.getMessage());
    }

     @Test
    void testEmployeeCreationFailsWhenEmailIsInvalid() {

        Exception exception1 = assertThrows(IllegalArgumentException.class, () -> {
            new Employee("Rodrigo", "Software Engineer", 5, "1181210.pt");
        });
        assertEquals("The email format is invalid", exception1.getMessage(), 
        "Unexpected exception message for email without '@'.");

        Exception exception2 = assertThrows(IllegalArgumentException.class, () -> {
            new Employee("Rodrigo", "Software Engineer", 5, "isep@.pt");
        });
        assertEquals("The email format is invalid", exception2.getMessage(), 
        "Unexpected exception message for email with missing domain name.");

        Exception exception3 = assertThrows(IllegalArgumentException.class, () -> {
            new Employee("Rodrigo", "Software Engineer", 5, "1181210@isep");
        });
        assertEquals("The email format is invalid", exception3.getMessage());

        Exception exception4 = assertThrows(IllegalArgumentException.class, () -> {
            new Employee("Rodrigo", "Software Engineer", 5, "1181210@isep..pt");
        });
        assertEquals("The email format is invalid", exception4.getMessage(), 
        "Unexpected exception message for email with double dots.");
    }

    @Test
    void testEmployeeCreationSuccessWithValidEmails() {
        
        Employee employee1 = new Employee("Rodrigo", "Software Engineer", 5, "118.1210@isep.ipp.pt");
        assertEquals("118.1210@isep.ipp.pt", employee1.getEmail());

        Employee employee2 = new Employee("Rodrigo", "Software Engineer", 5, "1181210@isep.ipp.pt");
        assertEquals("1181210@isep.ipp.pt", employee2.getEmail());

        Employee employee4 = new Employee("Rodrigo", "Software Engineer", 5, "11812-10-teste@isep.ipp.pt");
        assertEquals("11812-10-teste@isep.ipp.pt", employee4.getEmail());
    }

    @Test
    void testSetEmailFailsWhenInvalidEmail() {

        Employee employee = new Employee("David", "Software Engineer", 5, "1181210@isep.ipp.pt");

        Exception exception1 = assertThrows(IllegalArgumentException.class, () -> {
            employee.setEmail("1181210");
        });
        assertEquals("The email format is invalid", exception1.getMessage());

        Exception exception2 = assertThrows(IllegalArgumentException.class, () -> {
            employee.setEmail("1181210@isep");
        });
        assertEquals("The email format is invalid", exception2.getMessage());
    }

    @Test
    void testEmployeeSetters() {
        Employee employee = new Employee("David", "Software Engineer", 5, "teste@isep.ipp.pt");
        
        employee.setName("Rodrigo");
        employee.setRole("Cybersecurity Analyst");
        employee.setJobYears(10);
        employee.setEmail("1181210@isep.ipp.pt");


        assertEquals("Rodrigo", employee.getName());
        assertEquals("Cybersecurity Analyst", employee.getRole());
        assertEquals(10, employee.getJobYears());
        assertEquals("1181210@isep.ipp.pt", employee.getEmail());
    }

}