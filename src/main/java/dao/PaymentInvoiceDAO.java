package dao;

import model.PaymentInvoice;
import model.ServiceInvoice;
import model.SparePartsInvoice;
import model.Vehicle;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentInvoiceDAO extends DAO {

    private static final String SELECT_INVOICE_BY_CUSTOMER_SQL = 
        "SELECT * FROM tblPaymentInvoice WHERE tblCustomerid = ?";
    private static final String SELECT_SERVICE_INVOICES_BY_PAYMENT_SQL = 
        "SELECT * FROM tblServiceInvoice WHERE tblPaymentInvoiceid = ?";
    private static final String SELECT_SPAREPARTS_INVOICES_BY_PAYMENT_SQL = 
        "SELECT * FROM tblSparePartsInvoice WHERE PaymentInvoiceid = ?";
    private static final String SELECT_VEHICLE_BY_ID_SQL = 
        "SELECT * FROM tblVehicle WHERE id = ?";
    private static final String UPDATE_STATUS_SQL = 
        "UPDATE tblPaymentInvoice SET status = ? WHERE id = ?";
    private static final String UPDATE_PAYMENT_INVOICE_SQL = 
        "UPDATE tblPaymentInvoice SET totalAmount = ? WHERE id = ?";
    private static final String INSERT_PAYMENT_INVOICE_SQL = 
        "INSERT INTO tblPaymentInvoice (time, totalAmount, status, tblVehicleid, tblCustomerid, tblSaleStaffid) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String INSERT_SERVICE_INVOICE_SQL = 
        "INSERT INTO tblServiceInvoice (totalAmount, quantity, tblPaymentInvoiceid, tblServiceid, tblStafftblUserid) VALUES (?, ?, ?, ?, ?)";
    private static final String INSERT_SPAREPARTS_INVOICE_SQL = 
        "INSERT INTO tblSparePartsInvoice (totalAmount, quantity, PaymentInvoiceid, tblSparePartsid) VALUES (?, ?, ?, ?)";

    public PaymentInvoiceDAO() {
        super();
    }

    public PaymentInvoice[] selectInvoiceByCustomer(int customerId) throws SQLException {
        List<PaymentInvoice> invoices = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SELECT_INVOICE_BY_CUSTOMER_SQL)) {
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                // Create PaymentInvoice object (as shown in sequence diagram step 20)
                PaymentInvoice invoice = new PaymentInvoice();
                invoice.setId(rs.getInt("id"));
                invoice.setTime(rs.getDate("time"));
                invoice.setTotalAmount(rs.getFloat("totalAmount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setVehicleId(rs.getInt("tblVehicleid"));
                invoice.setCustomerId(rs.getInt("tblCustomerid"));
                invoice.setSaleStaffId(rs.getInt("tblSaleStaffid"));
                
                // Load service invoices (internal implementation, not shown in diagram)
                List<ServiceInvoice> serviceInvoices = new ArrayList<>();
                try (PreparedStatement stmtService = connection.prepareStatement(SELECT_SERVICE_INVOICES_BY_PAYMENT_SQL)) {
                    stmtService.setInt(1, invoice.getId());
                    ResultSet rsService = stmtService.executeQuery();
                    while (rsService.next()) {
                        ServiceInvoice si = new ServiceInvoice();
                        si.setId(rsService.getInt("id"));
                        si.setTotalAmount(rsService.getFloat("totalAmount"));
                        si.setQuantity(rsService.getInt("quantity"));
                        si.setServiceId(rsService.getInt("tblServiceid"));
                        si.setTechnicalStaffId(rsService.getInt("tblStafftblUserid"));
                        si.setPaymentInvoiceId(invoice.getId());
                        serviceInvoices.add(si);
                    }
                }
                invoice.setListServiceInvoice(serviceInvoices);
                
                // Load spare parts invoices (internal implementation, not shown in diagram)
                List<SparePartsInvoice> sparePartsInvoices = new ArrayList<>();
                try (PreparedStatement stmtSpareParts = connection.prepareStatement(SELECT_SPAREPARTS_INVOICES_BY_PAYMENT_SQL)) {
                    stmtSpareParts.setInt(1, invoice.getId());
                    ResultSet rsSpareParts = stmtSpareParts.executeQuery();
                    while (rsSpareParts.next()) {
                        SparePartsInvoice spi = new SparePartsInvoice();
                        spi.setId(rsSpareParts.getInt("id"));
                        spi.setTotalAmount(rsSpareParts.getFloat("totalAmount"));
                        spi.setQuantity(rsSpareParts.getInt("quantity"));
                        spi.setSparePartsId(rsSpareParts.getInt("tblSparePartsid"));
                        spi.setPaymentInvoiceId(invoice.getId());
                        sparePartsInvoices.add(spi);
                    }
                }
                invoice.setListSparePartsInvoice(sparePartsInvoices);
                
                invoices.add(invoice);
            }
        }
        return invoices.toArray(new PaymentInvoice[0]);
    }

    public Vehicle getVehicleById(int vehicleId) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SELECT_VEHICLE_BY_ID_SQL)) {
            stmt.setInt(1, vehicleId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setId(rs.getInt("id"));
                vehicle.setLicensePlate(rs.getString("licensePlate"));
                vehicle.setBrand(rs.getString("brand"));
                vehicle.setModel(rs.getString("model"));
                Integer year = rs.getInt("year");
                if (!rs.wasNull()) {
                    vehicle.setYear(year);
                }
                vehicle.setColor(rs.getString("color"));
                vehicle.setDescription(rs.getString("description"));
                vehicle.setCustomerId(rs.getInt("customerId"));
                return vehicle;
            }
        }
        return null;
    }

    public PaymentInvoice updateStatus(int invoiceId, String status) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(UPDATE_STATUS_SQL)) {
            stmt.setString(1, status);
            stmt.setInt(2, invoiceId);
            stmt.executeUpdate();
            
            // Return updated invoice
            PaymentInvoice[] invoices = selectInvoiceByCustomer(0);
            for (PaymentInvoice inv : invoices) {
                if (inv.getId() == invoiceId) {
                    return inv;
                }
            }
        }
        return null;
    }

    public PaymentInvoice save(PaymentInvoice invoice) throws SQLException {
        Connection connection = getConnection();
        try {
            connection.setAutoCommit(false);
            
            // Check if invoice exists (has ID) or is new
            if (invoice.getId() > 0) {
                // Update existing invoice total amount
                try (PreparedStatement stmt = connection.prepareStatement(UPDATE_PAYMENT_INVOICE_SQL)) {
                    stmt.setFloat(1, invoice.getTotalAmount());
                    stmt.setInt(2, invoice.getId());
                    stmt.executeUpdate();
                }
                
                // Only insert new service invoices (those without paymentInvoiceId set or with id = 0)
                for (ServiceInvoice si : invoice.getListServiceInvoice()) {
                    if (si.getId() == 0) { // New service invoice
                        try (PreparedStatement stmt = connection.prepareStatement(INSERT_SERVICE_INVOICE_SQL)) {
                            stmt.setFloat(1, si.getTotalAmount());
                            stmt.setInt(2, si.getQuantity());
                            stmt.setInt(3, invoice.getId());
                            stmt.setInt(4, si.getServiceId());
                            stmt.setInt(5, si.getTechnicalStaffId());
                            stmt.executeUpdate();
                        }
                    }
                }
                
                // Only insert new spare parts invoices
                for (SparePartsInvoice spi : invoice.getListSparePartsInvoice()) {
                    if (spi.getId() == 0) { // New spare parts invoice
                        try (PreparedStatement stmt = connection.prepareStatement(INSERT_SPAREPARTS_INVOICE_SQL)) {
                            stmt.setFloat(1, spi.getTotalAmount());
                            stmt.setInt(2, spi.getQuantity());
                            stmt.setInt(3, invoice.getId());
                            stmt.setInt(4, spi.getSparePartsId());
                            stmt.executeUpdate();
                        }
                    }
                }
            } else {
                // Insert new payment invoice
                try (PreparedStatement stmt = connection.prepareStatement(INSERT_PAYMENT_INVOICE_SQL, Statement.RETURN_GENERATED_KEYS)) {
                    stmt.setDate(1, new java.sql.Date(invoice.getTime().getTime()));
                    stmt.setFloat(2, invoice.getTotalAmount());
                    stmt.setString(3, invoice.getStatus());
                    stmt.setInt(4, invoice.getVehicleId());
                    stmt.setInt(5, invoice.getCustomerId());
                    stmt.setInt(6, invoice.getSaleStaffId());
                    stmt.executeUpdate();
                    
                    ResultSet rs = stmt.getGeneratedKeys();
                    if (rs.next()) {
                        invoice.setId(rs.getInt(1));
                    }
                }
                
                // Insert service invoices
                for (ServiceInvoice si : invoice.getListServiceInvoice()) {
                    try (PreparedStatement stmt = connection.prepareStatement(INSERT_SERVICE_INVOICE_SQL)) {
                        stmt.setFloat(1, si.getTotalAmount());
                        stmt.setInt(2, si.getQuantity());
                        stmt.setInt(3, invoice.getId());
                        stmt.setInt(4, si.getServiceId());
                        stmt.setInt(5, si.getTechnicalStaffId());
                        stmt.executeUpdate();
                    }
                }
                
                // Insert spare parts invoices
                for (SparePartsInvoice spi : invoice.getListSparePartsInvoice()) {
                    try (PreparedStatement stmt = connection.prepareStatement(INSERT_SPAREPARTS_INVOICE_SQL)) {
                        stmt.setFloat(1, spi.getTotalAmount());
                        stmt.setInt(2, spi.getQuantity());
                        stmt.setInt(3, invoice.getId());
                        stmt.setInt(4, spi.getSparePartsId());
                        stmt.executeUpdate();
                    }
                }
            }
            
            connection.commit();
            return invoice;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

}

