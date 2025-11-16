package model;

public class SparePartsInvoice {
    private int id;
    private float totalAmount;
    private int quantity;
    private int sparePartsId; // Reference to tblSpareParts.id
    private int paymentInvoiceId; // Reference to tblPaymentInvoice.id

    public SparePartsInvoice() {}

    public SparePartsInvoice(float totalAmount, int quantity, int sparePartsId, int paymentInvoiceId) {
        this.totalAmount = totalAmount;
        this.quantity = quantity;
        this.sparePartsId = sparePartsId;
        this.paymentInvoiceId = paymentInvoiceId;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public float getTotalAmount() { return totalAmount; }
    public void setTotalAmount(float totalAmount) { this.totalAmount = totalAmount; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getSparePartsId() { return sparePartsId; }
    public void setSparePartsId(int sparePartsId) { this.sparePartsId = sparePartsId; }

    public int getPaymentInvoiceId() { return paymentInvoiceId; }
    public void setPaymentInvoiceId(int paymentInvoiceId) { this.paymentInvoiceId = paymentInvoiceId; }
}

