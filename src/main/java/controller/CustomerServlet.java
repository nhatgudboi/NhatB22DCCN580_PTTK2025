package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.CustomerDAO;
import model.Customer;
import java.sql.SQLException;

@SuppressWarnings("serial")
public class CustomerServlet extends HttpServlet {
    private CustomerDAO customerDAO;

    public void init() {
        customerDAO = new CustomerDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        
        try {
            if (name != null && !name.trim().isEmpty()) {
                Customer[] customers = customerDAO.selectCustomerByName(name);
                request.setAttribute("listCustomer", customers);
                request.setAttribute("searchName", name);
            }
            request.getRequestDispatcher("SelectCustomerView.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

