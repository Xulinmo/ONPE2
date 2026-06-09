package controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Conexion;

@WebServlet("/ActualizarEstadoServlet")
public class ActualizarEstadoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        int idPostulante = Integer.parseInt(request.getParameter("id_postulante"));
        String nuevoEstado = request.getParameter("nuevo_estado");

        String sql = "UPDATE postulante SET estado = ? WHERE id_postulante = ?";
        
        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
             
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idPostulante);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Truco pro: El referer nos devuelve a la misma página donde estábamos (sea el listado general o esta nueva vista)
        String referer = request.getHeader("referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("estado-postulacion.jsp");
        }
    }
}