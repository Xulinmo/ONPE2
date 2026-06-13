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

@WebServlet("/ProcesarValidacionServlet")
public class ProcesarValidacionServlet extends HttpServlet {

    /**
     * Procesa la validación (Aprobar/Rechazar) de un documento cargado.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Verificación de seguridad (Solo usuarios logueados)
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Captura de parámetros del formulario de validación
        String idCargaStr = request.getParameter("id_carga");
        String accion = request.getParameter("accion"); // Recibe 'Validado' o 'Rechazado'

        if (idCargaStr != null && accion != null) {
            int idCarga = Integer.parseInt(idCargaStr);

            // 3. ACTUALIZACIÓN EN LA BASE DE DATOS
            // Cambiamos el estado del documento en la tabla carga_documento
            String sql = "UPDATE carga_documento SET estado = ? WHERE id_carga = ?";
            
            try (Connection cn = Conexion.conectar();
                 PreparedStatement ps = cn.prepareStatement(sql)) {
                
                ps.setString(1, accion);
                ps.setInt(2, idCarga);
                
                int filasAfectadas = ps.executeUpdate();
                
                if (filasAfectadas > 0) {
                    // Éxito: Redirigimos con un mensaje de confirmación
                    response.sendRedirect("validacion-documentos.jsp?msg=" + accion.toLowerCase());
                } else {
                    response.sendRedirect("validacion-documentos.jsp?error=no_encontrado");
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("validacion-documentos.jsp?error=bd");
            }
        } else {
            response.sendRedirect("validacion-documentos.jsp?error=parametros");
        }
    }
}