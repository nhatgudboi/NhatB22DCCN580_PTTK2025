package model;

public class WarehouseStaff extends Staff {
    public WarehouseStaff() {
        super();
    }

    public WarehouseStaff(String username, String password, String fullName, 
                          java.util.Date dateOfBirth, String address, String email, 
                          String phoneNumber) {
        super(username, password, fullName, dateOfBirth, address, email, phoneNumber, "warehouse");
    }
}

