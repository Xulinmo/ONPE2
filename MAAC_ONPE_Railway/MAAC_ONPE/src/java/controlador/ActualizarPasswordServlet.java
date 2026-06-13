package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.UsuarioDAO;
import modelo.DashboardDAO;

@WebServlet(name = "ActualizarPasswordServlet", urlPatterns = {"/ActualizarPasswordServlet"})
public class ActualizarPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        String nuevaClave = request.getParameter("nuevaClave");

        UsuarioDAO uDao = new UsuarioDAO();
        DashboardDAO dDao = new DashboardDAO();
        
        uDao.respaldarContraseñaAntigua(idUsuario);

        // 1. Ejecutar la actualización en la tabla Usuario
        boolean exito = uDao.actualizarClave(idUsuario, nuevaClave);

        if (exito) {
            // 2. REGISTRO EN HISTORIAL (CUS-25)
            dDao.registrarAccion(idUsuario, "Cambio de contraseña exitoso");
            
            // Redirigir al login con mensaje de éxito
            response.sendRedirect("login.jsp?update=success");
        } else {
            response.sendRedirect("actualizar-password.jsp?id=" + idUsuario + "&error=1");
        }
    }
}