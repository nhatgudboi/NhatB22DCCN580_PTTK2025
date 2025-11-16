package model;

import java.util.Date;
import java.util.ArrayList;
import java.util.List;

public class PaymentInvoice {
    private int id;
    private Date time;
    private float totalAmount;
    private String status; // unpaid, paid, cancelled
    private int saleStaffId; // Reference to tblStaff.tblUserid
    private int customerId; // Reference to tblCustomer.id
    private int vehicleId; // Reference to tblVehicle.id
    private List<ServiceInvoice> listServiceInvoice;
    private List<SparePartsInvoice> listSparePartsInvoice;

    public PaymentInvoice() {
        this.listServiceInvoice = new ArrayList<>();
        this.listSparePartsInvoice = new ArrayList<>();
    }

    public PaymentInvoice(Date time, float totalAmount, String status, int saleStaffId, int customerId, int vehicleId) {
        this.time = time;
        this.totalAmount = totalAmount;
        this.status = status;
        this.saleStaffId = saleStaffId;
        this.customerId = customerId;
        this.vehicleId = vehicleId;
        this.listServiceInvoice = new ArrayList<>();
        this.listSparePartsInvoice = new ArrayList<>();
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Date getTime() { return time; }
    public void setTime(Date time) { this.time = time; }

    public float getTotalAmount() { return totalAmount; }
    public void setTotalAmount(float totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getSaleStaffId() { return saleStaffId; }
    public void setSaleStaffId(int saleStaffId) { this.saleStaffId = saleStaffId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public List<ServiceInvoice> getListServiceInvoice() { return listServiceInvoice; }
    public void setListServiceInvoice(List<ServiceInvoice> listServiceInvoice) { this.listServiceInvoice = listServiceInvoice; }

    public List<SparePartsInvoice> getListSparePartsInvoice() { return listSparePartsInvoice; }
    public void setListSparePartsInvoice(List<SparePartsInvoice> listSparePartsInvoice) { this.listSparePartsInvoice = listSparePartsInvoice; }
}

