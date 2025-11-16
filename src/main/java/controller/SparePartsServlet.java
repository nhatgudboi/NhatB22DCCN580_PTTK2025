package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.SparePartsDAO;
import model.SpareParts;
import java.sql.SQLException;

@SuppressWarnings("serial")
public class SparePartsServlet extends HttpServlet {
    private SparePartsDAO sparePartsDAO;

    public void init() {
        sparePartsDAO = new SparePartsDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("details".equals(action)) {
                // Get spare parts details by ID
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    int id = Integer.parseInt(idParam);
                    SpareParts spareParts = sparePartsDAO.getSparePartsDetailsByID(id);
                    if (spareParts != null) {
                        request.setAttribute("spareParts", spareParts);
                        request.getRequestDispatcher("SparePartsDetailsView.jsp").forward(request, response);
                        return;
                    }
                }
                response.sendRedirect("SearchForSparePartsInformationView.jsp?error=1");
            } else {
                // Search spare parts by name
                String keyword = request.getParameter("keyword");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    SpareParts[] sparePartsList = sparePartsDAO.searchSparePartsByName(keyword);
                    request.setAttribute("listSpareParts", sparePartsList);
                    request.setAttribute("keyword", keyword);
                }
                request.getRequestDispatcher("SearchForSparePartsInformationView.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        } catch (NumberFormatException e) {
            response.sendRedirect("SearchForSparePartsInformationView.jsp?error=1");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

