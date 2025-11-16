package model;

public class Staff extends User {
    private String position; // "management", "warehouse", "technical", "sales"

    public Staff() {
        super();
    }

    public Staff(String username, String password, String fullName, 
                 java.util.Date dateOfBirth, String address, String email, 
                 String phoneNumber, String position) {
        super(username, password, fullName, dateOfBirth, address, email, phoneNumber, "staff");
        this.position = position;
    }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
}

