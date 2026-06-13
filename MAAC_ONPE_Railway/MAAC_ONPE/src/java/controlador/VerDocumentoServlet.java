package controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.Conexion;
import modelo.Usuario;

@WebServlet("/VerDocumentoServlet")
public class VerDocumentoServlet extends HttpServlet {

    /**
     * Procesa la petición GET para visualizar un documento y registrar la auditoría.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener el usuario en sesión
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        
        // Seguridad: Si no hay sesión, mandarlo al login
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Capturar los parámetros enviados desde la tabla
        String idCargaStr = request.getParameter("id_carga");
        String ruta = request.getParameter("ruta");

        if (idCargaStr != null && ruta != null) {
            int idCarga = Integer.parseInt(idCargaStr);

            // 3. REGISTRO DE AUDITORÍA (Requerimiento 31)
            // Insertamos en la tabla de logs quién está abriendo el archivo
            String sql = "INSERT INTO visualizacion_log (id_carga, usuario_visor, fecha_vista) VALUES (?, ?, CURRENT_TIMESTAMP)";
            
            try (Connection cn = Conexion.conectar();
                 PreparedStatement ps = cn.prepareStatement(sql)) {
                
                ps.setInt(1, idCarga);
                ps.setString(2, user.getNombreUsuario());
                ps.executeUpdate();
                
            } catch (Exception e) {
                // Si falla el log, imprimimos el error pero permitimos que vea el archivo
                e.printStackTrace();
            }

            // 4. REDIRECCIÓN AL ARCHIVO REAL
            // Una vez registrado el log, enviamos al usuario a la ruta del PDF
            response.sendRedirect(ruta);
            
        } else {
            // Si faltan parámetros, regresamos al listado
            response.sendRedirect("lista-documentos.jsp?error=parametros");
        }
    }
}