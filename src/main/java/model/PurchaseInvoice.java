package model;

import java.util.Date;
import java.util.ArrayList;
import java.util.List;

public class PurchaseInvoice {
    private int id;
    private Date time;
    private float totalAmount;
    private String status; // pending, received, cancelled
    private int supplierId; // Reference to tblSupplier.id
    private int warehouseStaffId; // Reference to tblStaff.tblUserid
    private List<ImportedSpareParts> listImportedSpareParts;

    public PurchaseInvoice() {
        this.listImportedSpareParts = new ArrayList<>();
    }

    public PurchaseInvoice(Date time, float totalAmount, String status, int supplierId, int warehouseStaffId) {
        this.time = time;
        this.totalAmount = totalAmount;
        this.status = status;
        this.supplierId = supplierId;
        this.warehouseStaffId = warehouseStaffId;
        this.listImportedSpareParts = new ArrayList<>();
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

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public int getWarehouseStaffId() { return warehouseStaffId; }
    public void setWarehouseStaffId(int warehouseStaffId) { this.warehouseStaffId = warehouseStaffId; }

    public List<ImportedSpareParts> getListImportedSpareParts() { return listImportedSpareParts; }
    public void setListImportedSpareParts(List<ImportedSpareParts> listImportedSpareParts) { this.listImportedSpareParts = listImportedSpareParts; }
}

