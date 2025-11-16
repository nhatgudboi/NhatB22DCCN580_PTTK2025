<%@ page import="model.PaymentInvoice" %>
<%@ page import="model.ServiceInvoice" %>
<%@ page import="model.SparePartsInvoice" %>
<%@ page import="model.Service" %>
<%@ page import="model.SpareParts" %>
<%@ page import="model.Vehicle" %>
<%@ page import="model.User" %>
<%@ page import="java.util.Map" %>
<%
    // Get current user from session
    User currentUser = (User) session.getAttribute("user");
    int saleStaffId = currentUser != null ? currentUser.getId() : 0;
    
    // Get service and spare parts maps for display
    Map<Integer, Service> serviceMap = (Map<Integer, Service>) request.getAttribute("serviceMap");
    Map<Integer, SpareParts> sparePartsMap = (Map<Integer, SpareParts>) request.getAttribute("sparePartsMap");
    Map<Integer, Vehicle> vehicleMap = (Map<Integer, Vehicle>) request.getAttribute("vehicleMap");
    
    // Get search results if any
    Object[] searchResults = (Object[]) request.getAttribute("searchResults");
    String searchType = (String) request.getAttribute("searchType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detailed Invoices</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
        }

        h1 {
            color: #333;
            margin-bottom: 30px;
        }

        .invoice-section {
            margin-bottom: 40px;
        }

        .section-title {
            color: #667eea;
            font-size: 24px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            background: #f8f9fa;
            color: #667eea;
            font-weight: 600;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.3s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-return {
            background: #6c757d;
            color: white;
            margin-top: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
        }

        .add-item-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .add-item-form h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .form-row {
            display: flex;
            gap: 15px;
            align-items: flex-end;
        }

        .form-row .form-group {
            flex: 1;
            margin-bottom: 0;
        }

        .form-row .form-group.small {
            flex: 0 0 100px;
        }

        .btn-add {
            background: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }

        .btn-add:hover {
            background: #218838;
        }

        .empty-message {
            text-align: center;
            color: #999;
            padding: 20px;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Detailed Invoices</h1>
        
        <% 
            PaymentInvoice[] listInvoice = (PaymentInvoice[]) request.getAttribute("listInvoice");
            String customerIdParam = request.getParameter("customerId");
            int customerId = 0;
            int vehicleId = 0;
            if (customerIdParam != null) {
                customerId = Integer.parseInt(customerIdParam);
            }
            if (listInvoice != null && listInvoice.length > 0 && listInvoice[0] != null) {
                vehicleId = listInvoice[0].getVehicleId();
            }
        %>
        
        <% if (listInvoice != null && listInvoice.length > 0) { %>
            <% for (PaymentInvoice invoice : listInvoice) { %>
                <div class="invoice-section">
                    <h2>Invoice #<%= invoice.getId() %></h2>
                    <p>Date: <%= invoice.getTime() %></p>
                    <p>Status: <strong><%= invoice.getStatus() %></strong></p>
                    <p>Total Amount: $<%= String.format("%.2f", invoice.getTotalAmount()) %></p>
                    
                    <% 
                        // Display vehicle information
                        Vehicle vehicle = null;
                        if (vehicleMap != null && invoice.getVehicleId() > 0) {
                            vehicle = vehicleMap.get(invoice.getVehicleId());
                        }
                    %>
                    <% if (vehicle != null) { %>
                        <div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #667eea;">
                            <h3 style="color: #667eea; margin-bottom: 10px; font-size: 18px;">Vehicle Information</h3>
                            <p><strong>License Plate:</strong> <%= vehicle.getLicensePlate() != null ? vehicle.getLicensePlate() : "N/A" %></p>
                            <% if (vehicle.getBrand() != null || vehicle.getModel() != null) { %>
                                <p><strong>Brand/Model:</strong> 
                                    <%= vehicle.getBrand() != null ? vehicle.getBrand() : "" %>
                                    <%= vehicle.getModel() != null ? " " + vehicle.getModel() : "" %>
                                </p>
                            <% } %>
                            <% if (vehicle.getYear() != null) { %>
                                <p><strong>Year:</strong> <%= vehicle.getYear() %></p>
                            <% } %>
                            <% if (vehicle.getColor() != null) { %>
                                <p><strong>Color:</strong> <%= vehicle.getColor() %></p>
                            <% } %>
                            <% if (vehicle.getDescription() != null && !vehicle.getDescription().trim().isEmpty()) { %>
                                <p><strong>Description:</strong> <%= vehicle.getDescription() %></p>
                            <% } %>
                        </div>
                    <% } %>

                    <% if ("unpaid".equals(invoice.getStatus())) { %>
                        <!-- Form to Add Service -->
                        <div class="add-item-form">
                            <h3>Add Service</h3>
                            <form method="get" action="paymentinvoice" id="searchServiceForm" style="margin-bottom: 15px;">
                                <input type="hidden" name="action" value="searchService">
                                <input type="hidden" name="customerId" value="<%= invoice.getCustomerId() %>">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="serviceSearchKey">Search Service by Name</label>
                                        <input type="text" name="searchKey" id="serviceSearchKey" placeholder="Enter service name" value="<%= request.getParameter("searchKey") != null && "service".equals(searchType) ? request.getParameter("searchKey") : "" %>">
                                    </div>
                                    <button type="submit" class="btn-add" style="background: #667eea;">Search</button>
                                </div>
                            </form>
                            
                            <% if (searchResults != null && "service".equals(searchType)) { %>
                                <div style="margin-bottom: 15px; padding: 10px; background: #e8f4f8; border-radius: 5px;">
                                    <strong>Search Results:</strong>
                                    <% Service[] services = (Service[]) searchResults; %>
                                    <% if (services.length > 0) { %>
                                        <ul style="margin-top: 10px; list-style: none; padding: 0;">
                                            <% for (Service s : services) { %>
                                                <li style="padding: 5px; border-bottom: 1px solid #ddd;">
                                                    <strong><%= s.getName() %></strong> (ID: <%= s.getId() %>, Price: $<%= String.format("%.2f", s.getPrice()) %>)
                                                </li>
                                            <% } %>
                                        </ul>
                                    <% } else { %>
                                        <p style="margin-top: 10px; color: #999;">No services found</p>
                                    <% } %>
                                </div>
                            <% } %>
                            
                            <form method="post" action="paymentinvoice" id="addServiceForm">
                                <input type="hidden" name="action" value="save">
                                <input type="hidden" name="invoiceId" value="<%= invoice.getId() %>">
                                <input type="hidden" name="customerId" value="<%= invoice.getCustomerId() %>">
                                <input type="hidden" name="vehicleId" value="<%= invoice.getVehicleId() %>">
                                <input type="hidden" name="saleStaffId" value="<%= invoice.getSaleStaffId() %>">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="serviceId">Service ID</label>
                                        <input type="number" name="serviceId" id="serviceId" placeholder="Enter service ID" required>
                                    </div>
                                    <div class="form-group small">
                                        <label for="serviceQuantity">Quantity</label>
                                        <input type="number" name="serviceQuantity" id="serviceQuantity" value="1" min="1" required>
                                    </div>
                                    <button type="submit" class="btn-add" id="btnAddService">Add Service</button>
                                </div>
                            </form>
                        </div>

                        <!-- Form to Add Spare Parts -->
                        <div class="add-item-form">
                            <h3>Add Spare Parts</h3>
                            <form method="get" action="paymentinvoice" id="searchSparePartsForm" style="margin-bottom: 15px;">
                                <input type="hidden" name="action" value="searchSpareParts">
                                <input type="hidden" name="customerId" value="<%= invoice.getCustomerId() %>">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="sparePartsSearchKey">Search Spare Parts by Name</label>
                                        <input type="text" name="searchKey" id="sparePartsSearchKey" placeholder="Enter spare parts name" value="<%= request.getParameter("searchKey") != null && "spareParts".equals(searchType) ? request.getParameter("searchKey") : "" %>">
                                    </div>
                                    <button type="submit" class="btn-add" style="background: #667eea;">Search</button>
                                </div>
                            </form>
                            
                            <% if (searchResults != null && "spareParts".equals(searchType)) { %>
                                <div style="margin-bottom: 15px; padding: 10px; background: #e8f4f8; border-radius: 5px;">
                                    <strong>Search Results:</strong>
                                    <% SpareParts[] sparePartsList = (SpareParts[]) searchResults; %>
                                    <% if (sparePartsList.length > 0) { %>
                                        <ul style="margin-top: 10px; list-style: none; padding: 0;">
                                            <% for (SpareParts sp : sparePartsList) { %>
                                                <li style="padding: 5px; border-bottom: 1px solid #ddd;">
                                                    <strong><%= sp.getName() %></strong> (ID: <%= sp.getId() %>, Price: $<%= String.format("%.2f", sp.getPrice()) %>, Stock: <%= sp.getStockQuantity() %>)
                                                </li>
                                            <% } %>
                                        </ul>
                                    <% } else { %>
                                        <p style="margin-top: 10px; color: #999;">No spare parts found</p>
                                    <% } %>
                                </div>
                            <% } %>
                            
                            <form method="post" action="paymentinvoice" id="addSparePartsForm">
                                <input type="hidden" name="action" value="save">
                                <input type="hidden" name="invoiceId" value="<%= invoice.getId() %>">
                                <input type="hidden" name="customerId" value="<%= invoice.getCustomerId() %>">
                                <input type="hidden" name="vehicleId" value="<%= invoice.getVehicleId() %>">
                                <input type="hidden" name="saleStaffId" value="<%= invoice.getSaleStaffId() %>">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="sparePartsId">Spare Parts ID</label>
                                        <input type="number" name="sparePartsId" id="sparePartsId" placeholder="Enter spare parts ID" required>
                                    </div>
                                    <div class="form-group small">
                                        <label for="sparePartsQuantity">Quantity</label>
                                        <input type="number" name="sparePartsQuantity" id="sparePartsQuantity" value="1" min="1" required>
                                    </div>
                                    <button type="submit" class="btn-add" id="btnAddSpareParts">Add Spare Parts</button>
                                </div>
                            </form>
                        </div>
                    <% } %>

                    <div class="section-title">Services</div>
                    <table>
                        <thead>
                            <tr>
                                <th>Service ID</th>
                                <th>Service Name</th>
                                <th>Quantity</th>
                                <th>Amount</th>
                            </tr>
                        </thead>
                        <tbody id="lbListService">
                            <% if (invoice.getListServiceInvoice() == null || invoice.getListServiceInvoice().isEmpty()) { %>
                                <tr>
                                    <td colspan="4" class="empty-message">No services added yet</td>
                                </tr>
                            <% } else { %>
                                <% for (ServiceInvoice si : invoice.getListServiceInvoice()) { %>
                                    <tr>
                                        <td><%= si.getServiceId() %></td>
                                        <td>
                                            <% if (serviceMap != null && serviceMap.containsKey(si.getServiceId())) { %>
                                                <%= serviceMap.get(si.getServiceId()).getName() %>
                                            <% } else { %>
                                                N/A
                                            <% } %>
                                        </td>
                                        <td><%= si.getQuantity() %></td>
                                        <td>$<%= String.format("%.2f", si.getTotalAmount()) %></td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>

                    <div class="section-title">Spare Parts</div>
                    <table>
                        <thead>
                            <tr>
                                <th>Spare Parts ID</th>
                                <th>Spare Parts Name</th>
                                <th>Quantity</th>
                                <th>Amount</th>
                            </tr>
                        </thead>
                        <tbody id="lbListSpareParts">
                            <% if (invoice.getListSparePartsInvoice() == null || invoice.getListSparePartsInvoice().isEmpty()) { %>
                                <tr>
                                    <td colspan="4" class="empty-message">No spare parts added yet</td>
                                </tr>
                            <% } else { %>
                                <% for (SparePartsInvoice spi : invoice.getListSparePartsInvoice()) { %>
                                    <tr>
                                        <td><%= spi.getSparePartsId() %></td>
                                        <td>
                                            <% if (sparePartsMap != null && sparePartsMap.containsKey(spi.getSparePartsId())) { %>
                                                <%= sparePartsMap.get(spi.getSparePartsId()).getName() %>
                                            <% } else { %>
                                                N/A
                                            <% } %>
                                        </td>
                                        <td><%= spi.getQuantity() %></td>
                                        <td>$<%= String.format("%.2f", spi.getTotalAmount()) %></td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>

                    <% if ("unpaid".equals(invoice.getStatus())) { %>
                        <a href="PaymentView.jsp?invoiceId=<%= invoice.getId() %>&totalAmount=<%= invoice.getTotalAmount() %>&customerId=<%= invoice.getCustomerId() %>" 
                           class="btn btn-success" id="btnConfirmInvoice">Confirm Payment</a>
                    <% } %>
                </div>
            <% } %>
        <% } else { %>
            <p>No invoices found for this customer.</p>
        <% } %>

        <a href="SelectCustomerView.jsp" class="btn btn-return" id="btnReturn">Return</a>
    </div>
</body>
</html>

