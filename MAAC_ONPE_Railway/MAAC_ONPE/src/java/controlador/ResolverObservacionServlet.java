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

@WebServlet("/ResolverObservacionServlet")
public class ResolverObservacionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idEval = Integer.parseInt(request.getParameter("id_evaluacion"));

        try (Connection cn = Conexion.conectar()) {
            String sql = "UPDATE evaluacion SET estado_obs = 'Resuelta' WHERE id_evaluacion = ?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, idEval);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Regresamos a la vista de observaciones
        response.sendRedirect("observaciones.jsp");
    }
}