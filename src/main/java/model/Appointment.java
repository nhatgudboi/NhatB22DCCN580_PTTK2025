package model;

import java.util.Date;

public class Appointment {
    private int id;
    private Date creationDate;
    private Date appointmentDate;
    private String status; // pending, confirmed, completed, cancelled
    private int customerId; // Reference to tblCustomer.id

    public Appointment() {}

    public Appointment(Date creationDate, Date appointmentDate, String status, int customerId) {
        this.creationDate = creationDate;
        this.appointmentDate = appointmentDate;
        this.status = status;
        this.customerId = customerId;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Date getCreationDate() { return creationDate; }
    public void setCreationDate(Date creationDate) { this.creationDate = creationDate; }

    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
}

