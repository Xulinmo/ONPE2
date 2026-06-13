package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.DashboardDAO;
import modelo.Usuario;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    HttpSession session = request.getSession(false);
    if (session != null) {
        Usuario user = (Usuario) session.getAttribute("usuario");
        if (user != null) {
            // REGISTRAMOS LA ACCIÓN ANTES DE SALIR
            DashboardDAO dashDao = new DashboardDAO();
            dashDao.registrarAccion(user.getIdUsuario(), "Cierre de sesión: " + user.getNombreUsuario());
        }
        session.invalidate();
    }
    response.sendRedirect("login.jsp?logout=true");
}
}