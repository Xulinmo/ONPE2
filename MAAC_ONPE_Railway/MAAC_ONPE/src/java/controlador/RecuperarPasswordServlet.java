package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.UsuarioDAO;
import modelo.DashboardDAO;
import modelo.Usuario;

@WebServlet(name = "RecuperarPasswordServlet", urlPatterns = {"/RecuperarPasswordServlet"})
public class RecuperarPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String correo = request.getParameter("correo");
        UsuarioDAO uDao = new UsuarioDAO();
        DashboardDAO dDao = new DashboardDAO();

        // 1. Validamos si el correo pertenece a algún usuario
        Usuario u = uDao.buscarPorCorreo(correo);

        if (u != null) {
            // 2. DINAMISMO: Registramos la solicitud en el historial (CUS-25)
            dDao.registrarAccion(u.getIdUsuario(), "Solicitud de recuperación de contraseña: " + correo);
            
            // Aquí iría la lógica para generar el token en la tabla RECUPERAR
            // Por ahora redirigimos con éxito para las capturas
            response.sendRedirect("recuperar-password.jsp?status=enviado");
        } else {
            response.sendRedirect("recuperar-password.jsp?status=no_existe");
        }
    }
}