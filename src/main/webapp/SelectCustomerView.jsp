<%@ page import="model.Customer" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Customer</title>
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
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
        }

        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 32px;
        }

        .search-form {
            margin-bottom: 30px;
            display: flex;
            gap: 10px;
        }

        .search-form input {
            flex: 1;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }

        .search-form input:focus {
            border-color: #667eea;
        }

        .search-form button {
            padding: 15px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s;
        }

        .search-form button:hover {
            transform: translateY(-2px);
        }

        .customer-list {
            display: grid;
            gap: 15px;
        }

        .customer-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }

        .customer-card:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .customer-info h3 {
            color: #667eea;
            margin-bottom: 5px;
        }

        .customer-info p {
            color: #666;
            font-size: 14px;
        }

        .btn-select {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        .btn-return {
            margin-top: 30px;
            padding: 12px 24px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            display: inline-block;
        }

        .no-results {
            text-align: center;
            color: #666;
            padding: 40px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Select Customer</h1>
        
        <form method="get" action="customer" class="search-form">
            <input type="text" name="name" id="inputText" 
                   placeholder="Enter customer name..." 
                   value="<%= request.getAttribute("searchName") != null ? request.getAttribute("searchName") : "" %>">
            <button type="submit" id="btnSearch">Search</button>
        </form>

        <% Customer[] listCustomer = (Customer[]) request.getAttribute("listCustomer"); %>
        <% if (listCustomer != null && listCustomer.length > 0) { %>
            <div class="customer-list">
                <% for (Customer customer : listCustomer) { %>
                    <a href="paymentinvoice?action=details&customerId=<%= customer.getId() %>" class="customer-card">
                        <div class="customer-info">
                            <h3><%= customer.getFullName() %></h3>
                            <p><%= customer.getAddress() != null ? customer.getAddress() : "" %></p>
                            <p>Phone: <%= customer.getPhoneNumber() %></p>
                        </div>
                        <span class="btn-select">Select</span>
                    </a>
                <% } %>
            </div>
        <% } else if (listCustomer != null && listCustomer.length == 0) { %>
            <div class="no-results">No customers found matching your search.</div>
        <% } %>

        <a href="HomeViewSaleStaff.jsp" class="btn-return">Return to Home</a>
    </div>
</body>
</html>

