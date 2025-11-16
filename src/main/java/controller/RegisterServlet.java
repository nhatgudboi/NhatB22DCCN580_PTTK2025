package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.LoginDao;
import model.User;
import java.sql.SQLException;

@SuppressWarnings("serial")
public class RegisterServlet extends HttpServlet {
    private LoginDao userDao;

    public void init() {
        userDao = new LoginDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = new User();
        user.setFullName(name);
        user.setEmail(email);
        user.setPassword(password);

        try {
            if (userDao.registerUser(user)) {
                response.sendRedirect("login.jsp");
            } else {
                response.sendRedirect("register.jsp?error=1");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
