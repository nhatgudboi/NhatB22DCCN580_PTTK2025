package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.PaymentInvoiceDAO;
import dao.ServiceDAO;
import dao.SparePartsDAO;
import model.PaymentInvoice;
import model.ServiceInvoice;
import model.SparePartsInvoice;
import model.Service;
import model.SpareParts;
import model.Vehicle;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@SuppressWarnings("serial")
public class PaymentInvoiceServlet extends HttpServlet {
    private PaymentInvoiceDAO paymentInvoiceDAO;
    private ServiceDAO serviceDAO;
    private SparePartsDAO sparePartsDAO;

    public void init() {
        paymentInvoiceDAO = new PaymentInvoiceDAO();
        serviceDAO = new ServiceDAO();
        sparePartsDAO = new SparePartsDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String customerIdParam = request.getParameter("customerId");
        
        try {
            if ("details".equals(action) && customerIdParam != null) {
                int customerId = Integer.parseInt(customerIdParam);
                PaymentInvoice[] invoices = paymentInvoiceDAO.selectInvoiceByCustomer(customerId);
                
                // Load service and spare parts details for display
                Map<Integer, Service> serviceMap = new HashMap<>();
                Map<Integer, SpareParts> sparePartsMap = new HashMap<>();
                Map<Integer, Vehicle> vehicleMap = new HashMap<>();
                for (PaymentInvoice invoice : invoices) {
                    // Load vehicle information
                    if (invoice.getVehicleId() > 0 && !vehicleMap.containsKey(invoice.getVehicleId())) {
                        Vehicle vehicle = paymentInvoiceDAO.getVehicleById(invoice.getVehicleId());
                        if (vehicle != null) {
                            vehicleMap.put(invoice.getVehicleId(), vehicle);
                        }
                    }
                    for (ServiceInvoice si : invoice.getListServiceInvoice()) {
                        if (!serviceMap.containsKey(si.getServiceId())) {
                            Service service = serviceDAO.getServiceDetailsByID(si.getServiceId());
                            if (service != null) {
                                serviceMap.put(si.getServiceId(), service);
                            }
                        }
                    }
                    for (SparePartsInvoice spi : invoice.getListSparePartsInvoice()) {
                        if (!sparePartsMap.containsKey(spi.getSparePartsId())) {
                            SpareParts spareParts = sparePartsDAO.getSparePartsDetailsByID(spi.getSparePartsId());
                            if (spareParts != null) {
                                sparePartsMap.put(spi.getSparePartsId(), spareParts);
                            }
                        }
                    }
                }
                
                request.setAttribute("listInvoice", invoices);
                request.setAttribute("serviceMap", serviceMap);
                request.setAttribute("sparePartsMap", sparePartsMap);
                request.setAttribute("vehicleMap", vehicleMap);
                request.setAttribute("customerId", customerId);
                request.getRequestDispatcher("DetailedInvoicesView.jsp").forward(request, response);
            } else if ("searchService".equals(action) || "searchSpareParts".equals(action)) {
                // Search services or spare parts by name, then redirect back to details
                String searchKey = request.getParameter("searchKey");
                
                if (customerIdParam != null) {
                    int customerId = Integer.parseInt(customerIdParam);
                    PaymentInvoice[] invoices = paymentInvoiceDAO.selectInvoiceByCustomer(customerId);
                    
                    // Load service and spare parts details for display
                    Map<Integer, Service> serviceMap = new HashMap<>();
                    Map<Integer, SpareParts> sparePartsMap = new HashMap<>();
                    Map<Integer, Vehicle> vehicleMap = new HashMap<>();
                    for (PaymentInvoice invoice : invoices) {
                        // Load vehicle information
                        if (invoice.getVehicleId() > 0 && !vehicleMap.containsKey(invoice.getVehicleId())) {
                            Vehicle vehicle = paymentInvoiceDAO.getVehicleById(invoice.getVehicleId());
                            if (vehicle != null) {
                                vehicleMap.put(invoice.getVehicleId(), vehicle);
                            }
                        }
                        for (ServiceInvoice si : invoice.getListServiceInvoice()) {
                            if (!serviceMap.containsKey(si.getServiceId())) {
                                Service service = serviceDAO.getServiceDetailsByID(si.getServiceId());
                                if (service != null) {
                                    serviceMap.put(si.getServiceId(), service);
                                }
                            }
                        }
                        for (SparePartsInvoice spi : invoice.getListSparePartsInvoice()) {
                            if (!sparePartsMap.containsKey(spi.getSparePartsId())) {
                                SpareParts spareParts = sparePartsDAO.getSparePartsDetailsByID(spi.getSparePartsId());
                                if (spareParts != null) {
                                    sparePartsMap.put(spi.getSparePartsId(), spareParts);
                                }
                            }
                        }
                    }
                    
                    // Perform search if searchKey provided
                    if (searchKey != null && !searchKey.trim().isEmpty()) {
                        if ("searchService".equals(action)) {
                            Service[] services = serviceDAO.searchServiceByName(searchKey);
                            request.setAttribute("searchResults", services);
                            request.setAttribute("searchType", "service");
                        } else {
                            SpareParts[] spareParts = sparePartsDAO.searchSparePartsByName(searchKey);
                            request.setAttribute("searchResults", spareParts);
                            request.setAttribute("searchType", "spareParts");
                        }
                    }
                    
                    request.setAttribute("listInvoice", invoices);
                    request.setAttribute("serviceMap", serviceMap);
                    request.setAttribute("sparePartsMap", sparePartsMap);
                    request.setAttribute("vehicleMap", vehicleMap);
                    request.setAttribute("customerId", customerId);
                    request.getRequestDispatcher("DetailedInvoicesView.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("DetailedInvoicesView.jsp").forward(request, response);
                }
            } else {
                request.getRequestDispatcher("DetailedInvoicesView.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        } catch (NumberFormatException e) {
            response.sendRedirect("SelectCustomerView.jsp?error=1");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("save".equals(action)) {
                // Save invoice with services and spare parts
                String customerIdParam = request.getParameter("customerId");
                String vehicleIdParam = request.getParameter("vehicleId");
                String saleStaffIdParam = request.getParameter("saleStaffId");
                
                if (customerIdParam != null && vehicleIdParam != null && saleStaffIdParam != null) {
                    PaymentInvoice invoice = new PaymentInvoice();
                    invoice.setTime(new Date());
                    invoice.setStatus("unpaid");
                    invoice.setCustomerId(Integer.parseInt(customerIdParam));
                    invoice.setVehicleId(Integer.parseInt(vehicleIdParam));
                    invoice.setSaleStaffId(Integer.parseInt(saleStaffIdParam));
                    
                    String invoiceIdParam = request.getParameter("invoiceId");
                    
                    // Load existing invoice if invoiceId provided, otherwise create new
                    if (invoiceIdParam != null && !invoiceIdParam.isEmpty()) {
                        // Load existing invoice to add items to it
                        PaymentInvoice[] existingInvoices = paymentInvoiceDAO.selectInvoiceByCustomer(Integer.parseInt(customerIdParam));
                        for (PaymentInvoice inv : existingInvoices) {
                            if (inv.getId() == Integer.parseInt(invoiceIdParam)) {
                                invoice = inv;
                                break;
                            }
                        }
                    }
                    
                    // Calculate additional amount from new items
                    float additionalAmount = 0;
                    
                    // Add service invoices
                    String[] serviceIds = request.getParameterValues("serviceId");
                    String[] serviceQuantities = request.getParameterValues("serviceQuantity");
                    if (serviceIds != null && serviceIds.length > 0) {
                        for (int i = 0; i < serviceIds.length; i++) {
                            try {
                                int serviceId = Integer.parseInt(serviceIds[i]);
                                int quantity = Integer.parseInt(serviceQuantities[i]);
                                var service = serviceDAO.getServiceDetailsByID(serviceId);
                                if (service != null) {
                                    ServiceInvoice si = new ServiceInvoice();
                                    si.setServiceId(serviceId);
                                    si.setQuantity(quantity);
                                    si.setTotalAmount(service.getPrice() * quantity);
                                    si.setTechnicalStaffId(Integer.parseInt(saleStaffIdParam));
                                    invoice.getListServiceInvoice().add(si);
                                    additionalAmount += si.getTotalAmount();
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }
                    
                    // Add spare parts invoices
                    String[] sparePartsIds = request.getParameterValues("sparePartsId");
                    String[] sparePartsQuantities = request.getParameterValues("sparePartsQuantity");
                    if (sparePartsIds != null && sparePartsIds.length > 0) {
                        for (int i = 0; i < sparePartsIds.length; i++) {
                            try {
                                int sparePartsId = Integer.parseInt(sparePartsIds[i]);
                                int quantity = Integer.parseInt(sparePartsQuantities[i]);
                                var spareParts = sparePartsDAO.getSparePartsDetailsByID(sparePartsId);
                                if (spareParts != null) {
                                    SparePartsInvoice spi = new SparePartsInvoice();
                                    spi.setSparePartsId(sparePartsId);
                                    spi.setQuantity(quantity);
                                    spi.setTotalAmount(spareParts.getPrice() * quantity);
                                    invoice.getListSparePartsInvoice().add(spi);
                                    additionalAmount += spi.getTotalAmount();
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }
                    
                    // Update total amount
                    invoice.setTotalAmount(invoice.getTotalAmount() + additionalAmount);
                    
                    // Save invoice (will handle both new and existing invoices)
                    paymentInvoiceDAO.save(invoice);
                    
                    response.sendRedirect("paymentinvoice?action=details&customerId=" + customerIdParam);
                }
            } else if ("updateStatus".equals(action)) {
                // Update payment status
                String invoiceIdParam = request.getParameter("invoiceId");
                String status = request.getParameter("status");
                String paymentMethod = request.getParameter("paymentMethod");
                String customerIdParam = request.getParameter("customerId");
                
                if (invoiceIdParam != null && status != null) {
                    int invoiceId = Integer.parseInt(invoiceIdParam);
                    paymentInvoiceDAO.updateStatus(invoiceId, status);
                    
                    // Redirect back to DetailedInvoicesView to see updated invoice
                    if (customerIdParam != null) {
                        response.sendRedirect("paymentinvoice?action=details&customerId=" + customerIdParam);
                    } else {
                        request.setAttribute("paymentMethod", paymentMethod);
                        request.getRequestDispatcher("PaymentView.jsp").forward(request, response);
                    }
                }
            } else {
                doGet(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        } catch (NumberFormatException e) {
            response.sendRedirect("SelectCustomerView.jsp?error=1");
        }
    }
}

