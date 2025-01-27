package payroll;
import java.util.Objects;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import java.util.regex.Pattern;


@Entity
class Employee {

	private @Id
	@GeneratedValue(strategy = GenerationType.IDENTITY) Long id;
	private String name;
	private String email;
	private String role;
	private int jobYears;

private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*\\.[A-Za-z]{2,}$";
    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);

	Employee() {}

	Employee(String name, String role, int jobYears) {

		// Validations
		if (name == null || name.trim().isEmpty()) {
			throw new IllegalArgumentException("The name can't be null or empty");
		}
		if (role == null || role.trim().isEmpty()) {
			throw new IllegalArgumentException("The role can't be null or empty");
		}
		if (jobYears < 0) {
			throw new IllegalArgumentException("Job years must be a positive integer");
		}

		this.name = name;
		this.role = role;
		this.jobYears = jobYears;
	}

	Employee(String name, String role, int jobYears, String email) {

		// Validations
		this(name, role, jobYears);
		if (email == null || email.trim().isEmpty()) {
			throw new IllegalArgumentException("The email can't be null or empty");
		}
		else if (!isValidEmail(email)) {
            throw new IllegalArgumentException("The email format is invalid");
        }

		this.email = email;
	}

	public Long getId() {
		return this.id;
	}

	public String getName() {
		return this.name;
	}

	public String getRole() {
		return this.role;
	}

	public int getJobYears() {
		return this.jobYears;
	}

	public String getEmail() {
		return this.email;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setName(String name) {

		if (name == null || name.trim().isEmpty()) {
			throw new IllegalArgumentException("The name can't be null or empty");
		}

		this.name = name;
	}

	public void setRole(String role) {

		if (role == null || role.trim().isEmpty()) {
			throw new IllegalArgumentException("The role can't be null or empty");
		}

		this.role = role;
	}

	public void setJobYears(int jobYears) {

		if (jobYears < 0) {
			throw new IllegalArgumentException("Job years must be a positive integer");
		}

		this.jobYears = jobYears;
	}
	
	public void setEmail(String email) {

		if (email == null || email.trim().isEmpty()) {
			throw new IllegalArgumentException("The email can't be null or empty");
		}
		else if (!isValidEmail(email)) {
            throw new IllegalArgumentException("The email format is invalid");
        }

		this.email = email;
	}

 	 private boolean isValidEmail(String email) {
        return EMAIL_PATTERN.matcher(email).matches();
    }
	
	@Override
	public boolean equals(Object o) {

		if (this == o)
			return true;
		if (!(o instanceof Employee))
			return false;
		Employee employee = (Employee) o;
		return Objects.equals(this.id, employee.id) && Objects.equals(this.name, employee.name) && Objects.equals(this.email, employee.email)
				&& Objects.equals(this.role, employee.role) && Objects.equals(this.jobYears, employee.jobYears);
	}

	@Override
	public int hashCode() {
		return Objects.hash(this.id, this.email, this.name, this.role);
	}

	@Override
	public String toString() {
		return "Employee{" + "id=" + this.id + ", name='" + this.name + '\''+ ", email='" + this.email + '\'' + ", role='" + this.role + '\'' + ", jobYears='" + this.jobYears + '\'' + '}';
	}
}
