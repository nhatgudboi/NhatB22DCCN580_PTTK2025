<%@ page import="model.SpareParts" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Spare Parts Details</title>
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
            max-width: 800px;
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
            border-bottom: 3px solid #667eea;
            padding-bottom: 15px;
        }

        .detail-item {
            margin: 25px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }

        .detail-label {
            font-weight: 600;
            color: #667eea;
            margin-bottom: 8px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .detail-value {
            color: #333;
            font-size: 18px;
        }

        .price {
            color: #667eea;
            font-size: 32px;
            font-weight: bold;
        }

        .stock-low {
            color: #dc3545;
            font-weight: bold;
            font-size: 24px;
        }

        .stock-ok {
            color: #28a745;
            font-size: 24px;
        }

        .btn-return {
            margin-top: 40px;
            padding: 12px 24px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            display: inline-block;
            transition: background 0.3s;
        }

        .btn-return:hover {
            background: #5a6268;
        }

        .not-found {
            text-align: center;
            color: #666;
            padding: 40px;
        }
    </style>
</head>
<body>
    <div class="container">
        <% SpareParts spareParts = (SpareParts) request.getAttribute("spareParts"); %>
        <% if (spareParts != null) { %>
            <h1>Spare Parts Details</h1>
            
            <div class="detail-item">
                <div class="detail-label">Spare Parts ID</div>
                <div class="detail-value"><%= spareParts.getId() %></div>
            </div>
            
            <div class="detail-item">
                <div class="detail-label">Name</div>
                <div class="detail-value"><%= spareParts.getName() %></div>
            </div>
            
            <div class="detail-item">
                <div class="detail-label">Price</div>
                <div class="detail-value price">$<%= String.format("%.2f", spareParts.getPrice()) %></div>
            </div>
            
            <div class="detail-item">
                <div class="detail-label">Stock Quantity</div>
                <div class="detail-value <%= spareParts.getStockQuantity() < 10 ? "stock-low" : "stock-ok" %>">
                    <%= spareParts.getStockQuantity() %>
                    <% if (spareParts.getStockQuantity() < 10) { %>
                        <span style="font-size: 14px; color: #666; margin-left: 10px;">(Low Stock)</span>
                    <% } %>
                </div>
            </div>
            
            <div class="detail-item">
                <div class="detail-label">Description</div>
                <div class="detail-value"><%= spareParts.getDescription() != null ? spareParts.getDescription() : "No description available" %></div>
            </div>
            
            <a href="SearchForSparePartsInformationView.jsp" class="btn-return" id="btnReturn">Return to Search</a>
        <% } else { %>
            <h1>Spare Parts Not Found</h1>
            <div class="not-found">
                <p>The requested spare parts could not be found.</p>
                <a href="SearchForSparePartsInformationView.jsp" class="btn-return" id="btnReturn" style="margin-top: 20px;">Return to Search</a>
            </div>
        <% } %>
    </div>
</body>
</html>
