<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment</title>
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
            max-width: 600px;
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

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 14px;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }

        .form-group input:focus, .form-group select:focus {
            border-color: #667eea;
        }

        .total-amount {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
        }

        .total-amount h2 {
            color: #667eea;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .btn {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 15px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Payment Processing</h1>
        
        <%
            String invoiceId = request.getParameter("invoiceId");
            String totalAmount = request.getParameter("totalAmount");
            String customerId = request.getParameter("customerId");
        %>

        <div class="total-amount">
            <h2>Total Amount: $<%= totalAmount != null ? String.format("%.2f", Float.parseFloat(totalAmount)) : "0.00" %></h2>
        </div>

        <form method="post" action="paymentinvoice" id="paymentForm">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" name="invoiceId" value="<%= invoiceId != null ? invoiceId : "" %>">
            <input type="hidden" name="status" value="paid">
            <input type="hidden" name="customerId" value="<%= customerId != null ? customerId : "" %>">

            <div class="form-group">
                <label for="inputPaymentMethod">Payment Method</label>
                <select name="paymentMethod" id="inputPaymentMethod" required>
                    <option value="">Select payment method</option>
                    <option value="cash">Cash</option>
                    <option value="credit_card">Credit Card</option>
                    <option value="bank_transfer">Bank Transfer</option>
                </select>
            </div>

            <div class="form-group">
                <label for="inputTotalAmount">Total Amount</label>
                <input type="number" id="inputTotalAmount" name="totalAmount" 
                       value="<%= totalAmount != null ? totalAmount : "" %>" 
                       step="0.01" required readonly>
            </div>

            <button type="submit" class="btn btn-primary" id="btnConfirmPayment">Confirm Payment</button>
            <button type="button" class="btn btn-secondary" id="btnPrintInvoice" onclick="window.print()">Print Invoice</button>
            <a href="paymentinvoice?action=details&customerId=<%= customerId != null ? customerId : "" %>" class="btn btn-secondary" id="btnReturn" style="text-decoration: none; display: block; text-align: center;">Return</a>
        </form>
    </div>

    <script>
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            if (confirm('Confirm payment for this invoice?')) {
                return true;
            }
            e.preventDefault();
            return false;
        });
    </script>
</body>
</html>

