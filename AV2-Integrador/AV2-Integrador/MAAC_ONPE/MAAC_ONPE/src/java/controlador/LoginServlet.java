package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.Usuario;
import modelo.UsuarioDAO;
import modelo.DashboardDAO; 

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String user = request.getParameter("txtUser");
        String pass = request.getParameter("txtPass");
        
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuarioLogueado = dao.validarAcceso(user, pass);
        
        if (usuarioLogueado != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuarioLogueado);
            
            new DashboardDAO().registrarAccion(usuarioLogueado.getIdUsuario(), "Inicio de sesión exitoso");
            
            response.sendRedirect("inicio.jsp");
        } else {
            DashboardDAO dDao = new DashboardDAO();
            dDao.registrarAccion(0, "Intento de acceso fallido: " + user);
            
            response.sendRedirect("login.jsp?error=1");
        }
    }
}