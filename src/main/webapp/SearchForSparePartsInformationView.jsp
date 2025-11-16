<%@ page import="model.SpareParts" %>
<%@ page import="java.util.Arrays" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Spare Parts Information</title>
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
            font-size: 32px;
        }

        .search-form {
            margin-bottom: 30px;
            display: flex;
            gap: 10px;
        }

        .search-form input[type="text"] {
            flex: 1;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }

        .search-form input[type="text"]:focus {
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
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            background: #667eea;
            color: white;
            font-weight: 600;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .stock-low {
            color: #dc3545;
            font-weight: bold;
        }

        .stock-ok {
            color: #28a745;
        }

        .btn-return {
            margin-top: 30px;
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

        .error {
            color: #dc3545;
            margin-bottom: 15px;
            padding: 10px;
            background: #f8d7da;
            border-radius: 5px;
        }

        .no-results {
            text-align: center;
            color: #666;
            padding: 40px;
            font-style: italic;
        }

        .action-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }

        .action-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Search for Spare Parts Information</h1>
        
        <form method="get" action="spareparts" class="search-form">
            <input type="text" name="keyword" id="inputText" 
                   placeholder="Enter spare parts name..." 
                   value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
            <button type="submit" id="btnSearch">Search</button>
        </form>

        <% if (request.getParameter("error") != null) { %>
            <div class="error">Error: Spare parts not found or invalid ID.</div>
        <% } %>

        <% SpareParts[] listSpareParts = (SpareParts[]) request.getAttribute("listSpareParts"); %>
        <% if (listSpareParts != null && listSpareParts.length > 0) { %>
            <table id="tblSpareParts">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Stock Quantity</th>
                        <th>Description</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (SpareParts spareParts : listSpareParts) { %>
                        <tr>
                            <td><%= spareParts.getId() %></td>
                            <td><%= spareParts.getName() %></td>
                            <td>$<%= String.format("%.2f", spareParts.getPrice()) %></td>
                            <td class="<%= spareParts.getStockQuantity() < 10 ? "stock-low" : "stock-ok" %>">
                                <%= spareParts.getStockQuantity() %>
                            </td>
                            <td><%= spareParts.getDescription() != null ? spareParts.getDescription() : "" %></td>
                            <td>
                                <a href="spareparts?action=details&id=<%= spareParts.getId() %>" class="action-link">View Details</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else if (listSpareParts != null && listSpareParts.length == 0) { %>
            <div class="no-results">No spare parts found matching your search.</div>
        <% } %>

        <a href="CustomerhomeView.jsp" class="btn-return" id="btnReturn">Return to Home</a>
    </div>
</body>
</html>
