package model;

public class ImportedSpareParts {
    private int id;
    private float totalAmount;
    private int quantity;
    private int purchaseInvoiceId; // Reference to tblPurchaseInvoice.id
    private int sparePartsId; // Reference to tblSpareParts.id

    public ImportedSpareParts() {}

    public ImportedSpareParts(float totalAmount, int quantity, int purchaseInvoiceId, int sparePartsId) {
        this.totalAmount = totalAmount;
        this.quantity = quantity;
        this.purchaseInvoiceId = purchaseInvoiceId;
        this.sparePartsId = sparePartsId;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public float getTotalAmount() { return totalAmount; }
    public void setTotalAmount(float totalAmount) { this.totalAmount = totalAmount; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getPurchaseInvoiceId() { return purchaseInvoiceId; }
    public void setPurchaseInvoiceId(int purchaseInvoiceId) { this.purchaseInvoiceId = purchaseInvoiceId; }

    public int getSparePartsId() { return sparePartsId; }
    public void setSparePartsId(int sparePartsId) { this.sparePartsId = sparePartsId; }
}

