package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.ServiceDAO;
import model.Service;
import java.sql.SQLException;

@SuppressWarnings("serial")
public class ServiceServlet extends HttpServlet {
    private ServiceDAO serviceDAO;

    public void init() {
        serviceDAO = new ServiceDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("details".equals(action)) {
                // Get service details by ID
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    int id = Integer.parseInt(idParam);
                    Service service = serviceDAO.getServiceDetailsByID(id);
                    if (service != null) {
                        request.setAttribute("service", service);
                        request.getRequestDispatcher("ServiceDetailsView.jsp").forward(request, response);
                        return;
                    }
                }
                response.sendRedirect("SearchForServiceInformationView.jsp?error=1");
            } else {
                // Search services by name
                String keyword = request.getParameter("keyword");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    Service[] services = serviceDAO.searchServiceByName(keyword);
                    request.setAttribute("listService", services);
                    request.setAttribute("keyword", keyword);
                }
                request.getRequestDispatcher("SearchForServiceInformationView.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        } catch (NumberFormatException e) {
            response.sendRedirect("SearchForServiceInformationView.jsp?error=1");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

