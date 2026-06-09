package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Usuario;
import modelo.UsuarioDAO;
import modelo.DashboardDAO;

@WebServlet(name = "RegistrarUsuarioServlet", urlPatterns = {"/RegistrarUsuarioServlet"})
public class RegistrarUsuarioServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Configurar codificación para que acepte tildes y ñ
        request.setCharacterEncoding("UTF-8");
        
        // 2. Capturar los datos del formulario (Vista 1)
        String nombres = request.getParameter("nombres");
        String usuario = request.getParameter("usuario");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        int idRol = Integer.parseInt(request.getParameter("id_rol"));
        
        // 3. Llenar el objeto Modelo
        Usuario u = new Usuario();
        u.setNombres(nombres);
        u.setNombreUsuario(usuario);
        u.setCorreo(correo);
        u.setContraseña(contrasena);
        u.setIdRol(idRol);
        
        // 4. Ejecutar la inserción en Base de Datos
        UsuarioDAO uDao = new UsuarioDAO();
        boolean exito = uDao.registrarUsuario(u);
        
        if (exito) {
            // DINAMISMO: Registrar en auditoría que el administrador creó una cuenta
            Usuario admin = (Usuario) request.getSession().getAttribute("usuario");
            if (admin != null) {
                DashboardDAO dDao = new DashboardDAO();
                dDao.registrarAccion(admin.getIdUsuario(), "Creación de nueva cuenta: " + usuario);
            }
            // Redirigir de vuelta al formulario con éxito
            response.sendRedirect("usuario-registro.jsp?msg=usuario_creado");
        } else {
            // Redirigir con error si falla MySQL
            response.sendRedirect("usuario-registro.jsp?error=bd");
        }
    }
}