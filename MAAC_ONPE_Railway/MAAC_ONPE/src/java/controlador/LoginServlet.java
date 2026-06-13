package controlador;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
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

    private static Map<String, Integer> intentosFallidos = new HashMap<>();
    private static Map<String, Long> tiempoBloqueo = new HashMap<>();
    
    private static final long TIEMPO_CASTIGO_MS = 3 * 60 * 1000; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String user = request.getParameter("txtUser");
        String pass = request.getParameter("txtPass");
        
        if (tiempoBloqueo.containsKey(user)) {
            long tiempoRestante = (tiempoBloqueo.get(user) + TIEMPO_CASTIGO_MS) - System.currentTimeMillis();
            
            if (tiempoRestante > 0) {
                response.sendRedirect("login.jsp?error=bloqueado_temp");
                return;
            } else {
                intentosFallidos.remove(user);
                tiempoBloqueo.remove(user);
            }
        }
        
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuarioLogueado = dao.validarAcceso(user, pass);
        
        if (usuarioLogueado != null) {
            intentosFallidos.remove(user);
            tiempoBloqueo.remove(user);
            
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuarioLogueado);
            
            new DashboardDAO().registrarAccion(usuarioLogueado.getIdUsuario(), "Inicio de sesión exitoso");
            
            response.sendRedirect("inicio.jsp");
            
        } else {
            DashboardDAO dDao = new DashboardDAO();
            dDao.registrarAccion(0, "Intento de acceso fallido: " + user);
            
            int fallas = intentosFallidos.getOrDefault(user, 0) + 1;
            intentosFallidos.put(user, fallas);
            
            if (fallas >= 3) {
                tiempoBloqueo.put(user, System.currentTimeMillis());
                response.sendRedirect("login.jsp?error=max_intentos");
            } else {
                response.sendRedirect("login.jsp?error=credenciales&intentos=" + fallas);
            }
        }
    }
}