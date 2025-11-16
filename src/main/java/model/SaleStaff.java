package model;

public class SaleStaff extends Staff {
    public SaleStaff() {
        super();
    }

    public SaleStaff(String username, String password, String fullName, 
                     java.util.Date dateOfBirth, String address, String email, 
                     String phoneNumber) {
        super(username, password, fullName, dateOfBirth, address, email, phoneNumber, "sales");
    }
}

