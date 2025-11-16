<%@ page import="model.User" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
    }
    String role = user.getRole() != null ? user.getRole().trim() : "customer";
    // Debug: force show role badge
    if (role == null || role.isEmpty()) {
        role = "customer";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            background-color: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            text-align: center;
        }
        h2 {
            color: #333;
            margin-bottom: 10px;
            font-size: 28px;
        }
        .role-badge {
            display: inline-block;
            padding: 5px 15px;
            background: #667eea;
            color: white;
            border-radius: 20px;
            font-size: 12px;
            margin-bottom: 30px;
            text-transform: uppercase;
        }
        .links {
            margin-top: 30px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        .links a {
            padding: 15px 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            display: inline-block;
            font-weight: 600;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .links a:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        .links a.staff-link {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .links a.staff-link:hover {
            box-shadow: 0 10px 20px rgba(245, 87, 108, 0.3);
        }
        .logout-link {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }
        .logout-link a {
            color: #666;
            text-decoration: none;
            font-size: 14px;
        }
        .logout-link a:hover {
            color: #333;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Welcome, <%= user.getFullName() %>!</h2>
        <span class="role-badge">Role: <%= role %></span>
        <div class="links">
            <% 
                // Always show both links for staff, or just customer link
                if ("staff".equalsIgnoreCase(role)) { 
            %>
                <a href="HomeViewSaleStaff.jsp" class="staff-link">
                    <span style="font-size: 18px; margin-right: 8px;">&#128187;</span>Payment Menu
                </a>
                <a href="CustomerhomeView.jsp">
                    <span style="font-size: 18px; margin-right: 8px;">&#127968;</span>Customer Home
                </a>
            <% } else { %>
                <a href="CustomerhomeView.jsp">
                    <span style="font-size: 18px; margin-right: 8px;">&#127968;</span>Customer Home
                </a>
            <% } %>
        </div>
        <div class="logout-link">
            <a href="logout.jsp">Logout</a>
        </div>
    </div>
</body>
</html>
