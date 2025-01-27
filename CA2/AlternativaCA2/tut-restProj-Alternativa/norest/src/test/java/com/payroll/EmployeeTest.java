package com.payroll;


import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail; 

public class EmployeeTest {

    @Test
    public void testEmployeeCreationSuccess() {
        // Test creating a valid employee
        Employee employee = new Employee("David", "Software Engineer", 3, "1181210@isep.ipp.pt");
        
        assertEquals("David", employee.getName());
        assertEquals("Software Engineer", employee.getRole());
        assertEquals(3, employee.getJobYears());
        assertEquals("1181210@isep.ipp.pt", employee.getEmail());
    }

     @Test(expected = IllegalArgumentException.class)
    public void testEmployeeCreationFailsWhenNameIsNull() {
        new Employee(null, "Cybersecurity Analyst", 10);
    }


    @Test(expected = IllegalArgumentException.class)
    public void testEmployeeCreationFailsWhenRoleIsNull() {
        new Employee("Rodrigo", null, 8);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testEmployeeCreationFailsWhenEmailIsNull() {
        new Employee("Rodrigo", "Software Engineer", 8, null);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testEmployeeCreationFailsWhenNameIsEmpty() {
        new Employee("", "Software Engineer", 3);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testEmployeeCreationFailsWhenRoleIsEmpty() {
        new Employee("Rodrigo", "", 5);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testEmployeeCreationFailsWhenJobYearsIsNegative() {
        new Employee("Rodrigo", "Software Engineer", -2);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testEmployeeCreationFailsWhenEmailIsEmpty() {
        new Employee("Rodrigo", "Software Engineer", 5, "");
    }

    @Test
    public void testEmployeeCreationFailsWhenEmailIsInvalid() {
        // Check for invalid email formats
        try {
            new Employee("Rodrigo", "Software Engineer", 5, "1181210.pt");
            fail("Expected IllegalArgumentException was not thrown");
        } catch (IllegalArgumentException exception) {
            assertEquals("The email format is invalid", exception.getMessage());
        }

        try {
            new Employee("Rodrigo", "Software Engineer", 5, "isep@.pt");
            fail("Expected IllegalArgumentException was not thrown");
        } catch (IllegalArgumentException exception) {
            assertEquals("The email format is invalid", exception.getMessage());
        }

        try {
            new Employee("Rodrigo", "Software Engineer", 5, "1181210@isep");
            fail("Expected IllegalArgumentException was not thrown");
        } catch (IllegalArgumentException exception) {
            assertEquals("The email format is invalid", exception.getMessage());
        }

        try {
            new Employee("Rodrigo", "Software Engineer", 5, "1181210@isep..pt");
            fail("Expected IllegalArgumentException was not thrown");
        } catch (IllegalArgumentException exception) {
            assertEquals("The email format is invalid", exception.getMessage());
        }
    }

    @Test
    public void testEmployeeCreationSuccessWithValidEmails() {
        Employee employee1 = new Employee("Rodrigo", "Software Engineer", 5, "118.1210@isep.ipp.pt");
        assertEquals("118.1210@isep.ipp.pt", employee1.getEmail());

        Employee employee2 = new Employee("Rodrigo", "Software Engineer", 5, "1181210@isep.ipp.pt");
        assertEquals("1181210@isep.ipp.pt", employee2.getEmail());

        Employee employee4 = new Employee("Rodrigo", "Software Engineer", 5, "11812-10-teste@isep.ipp.pt");
        assertEquals("11812-10-teste@isep.ipp.pt", employee4.getEmail());
    }

    @Test
    public void testSetEmailFailsWhenInvalidEmail() {
        Employee employee = new Employee("David", "Software Engineer", 5, "1181210@isep.ipp.pt");

        try {
            employee.setEmail("1181210");
            fail("Expected IllegalArgumentException was not thrown");
        } catch (IllegalArgumentException exception) {
            assertEquals("The email format is invalid", exception.getMessage());
        }

        try {
            employee.setEmail("1181210@isep");
            fail("Expected IllegalArgumentException was not thrown");
        } catch (IllegalArgumentException exception) {
            assertEquals("The email format is invalid", exception.getMessage());
        }
    }

    @Test
    public void testEmployeeSetters() {
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