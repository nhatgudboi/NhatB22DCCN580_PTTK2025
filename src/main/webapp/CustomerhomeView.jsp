<%@ page import="model.User" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Home</title>
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

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 10px;
        }

        .welcome-text {
            color: #666;
            font-size: 16px;
        }

        .menu {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 30px;
        }

        .menu-item {
            padding: 20px 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            text-align: center;
            font-weight: 600;
            font-size: 16px;
            transition: transform 0.3s, box-shadow 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .menu-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .menu-item .icon {
            font-size: 20px;
        }

        .footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn-return {
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            transition: background 0.3s;
        }

        .btn-return:hover {
            background: #5a6268;
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
        <div class="header">
            <h1>Customer Home</h1>
            <p class="welcome-text">Welcome, <%= user != null ? user.getFullName() : "Guest" %>!</p>
        </div>

        <div class="menu">
            <a href="SearchForServiceInformationView.jsp" class="menu-item">
                <span class="icon">&#128295;</span>
                <span>Search for Service Information</span>
            </a>
            <a href="SearchForSparePartsInformationView.jsp" class="menu-item">
                <span class="icon">&#9881;</span>
                <span>Search for Spare Parts Information</span>
            </a>
        </div>

        <div class="footer">
            <a href="welcome.jsp" class="btn-return">Return</a>
            <div class="logout-link">
                <a href="logout.jsp">Logout</a>
            </div>
        </div>
    </div>
</body>
</html>

