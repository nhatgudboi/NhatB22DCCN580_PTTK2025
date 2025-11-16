package model;

public class TechnicalStaff extends Staff {
    public TechnicalStaff() {
        super();
    }

    public TechnicalStaff(String username, String password, String fullName, 
                         java.util.Date dateOfBirth, String address, String email, 
                         String phoneNumber) {
        super(username, password, fullName, dateOfBirth, address, email, phoneNumber, "technical");
    }
}

