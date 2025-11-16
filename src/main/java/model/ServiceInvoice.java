package model;

public class ServiceInvoice {
    private int id;
    private float totalAmount;
    private int quantity;
    private int serviceId; // Reference to tblService.id
    private int technicalStaffId; // Reference to tblStaff.tblUserid
    private int paymentInvoiceId; // Reference to tblPaymentInvoice.id

    public ServiceInvoice() {}

    public ServiceInvoice(float totalAmount, int quantity, int serviceId, int technicalStaffId, int paymentInvoiceId) {
        this.totalAmount = totalAmount;
        this.quantity = quantity;
        this.serviceId = serviceId;
        this.technicalStaffId = technicalStaffId;
        this.paymentInvoiceId = paymentInvoiceId;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public float getTotalAmount() { return totalAmount; }
    public void setTotalAmount(float totalAmount) { this.totalAmount = totalAmount; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getTechnicalStaffId() { return technicalStaffId; }
    public void setTechnicalStaffId(int technicalStaffId) { this.technicalStaffId = technicalStaffId; }

    public int getPaymentInvoiceId() { return paymentInvoiceId; }
    public void setPaymentInvoiceId(int paymentInvoiceId) { this.paymentInvoiceId = paymentInvoiceId; }
}

