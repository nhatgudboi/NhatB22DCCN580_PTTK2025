package model;

public class ManagementStaff extends Staff {
    public ManagementStaff() {
        super();
    }

    public ManagementStaff(String username, String password, String fullName, 
                          java.util.Date dateOfBirth, String address, String email, 
                          String phoneNumber) {
        super(username, password, fullName, dateOfBirth, address, email, phoneNumber, "management");
    }
}

