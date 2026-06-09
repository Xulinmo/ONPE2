package controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Conexion;
import modelo.Usuario;

@WebServlet("/RegistrarEvaluacionServlet")
public class RegistrarEvaluacionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        Usuario user = (Usuario) request.getSession().getAttribute("usuario");

        // Capturamos los datos del formulario manual
        String dni = request.getParameter("dni");
        String idParam = request.getParameter("id_postulante"); // Por si se usa desde otra vista
        
        String tipoEval = request.getParameter("tipo_evaluacion");
        int puntaje = Integer.parseInt(request.getParameter("puntaje"));
        String resultado = request.getParameter("resultado");
        String fechaEval = request.getParameter("fecha_eval");
        String observacion = request.getParameter("observacion");

        int idPostulante = 0;

        try (Connection cn = Conexion.conectar()) {
            cn.setAutoCommit(false); 

            // 1. BUSCAR EL ID DEL POSTULANTE USANDO EL DNI
            if (idParam != null && !idParam.isEmpty()) {
                idPostulante = Integer.parseInt(idParam);
            } else if (dni != null && !dni.isEmpty()) {
                String sqlBusqueda = "SELECT id_postulante FROM postulante WHERE dni = ?";
                try (PreparedStatement psBusca = cn.prepareStatement(sqlBusqueda)) {
                    psBusca.setString(1, dni);
                    ResultSet rs = psBusca.executeQuery();
                    if (rs.next()) {
                        idPostulante = rs.getInt("id_postulante");
                    } else {
                        // Si el DNI no existe, lo regresamos al formulario con un error
                        response.sendRedirect("registrar-evaluacion.jsp?error=dni_invalido");
                        return;
                    }
                }
            }

            // 2. GUARDAR LA EVALUACIÓN
            String sqlEval = "INSERT INTO evaluacion (id_postulante, id_usuario, tipo_evaluacion, puntaje, resultado, observacion, fecha_eval) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps1 = cn.prepareStatement(sqlEval);
            ps1.setInt(1, idPostulante);
            ps1.setInt(2, user.getIdUsuario());
            ps1.setString(3, tipoEval);
            ps1.setInt(4, puntaje);
            ps1.setString(5, resultado);
            ps1.setString(6, observacion);
            ps1.setString(7, fechaEval);
            ps1.executeUpdate();

            // 3. ACTUALIZAR EL ESTADO DEL POSTULANTE
            String sqlPost = "UPDATE postulante SET estado = ? WHERE id_postulante = ?";
            PreparedStatement ps2 = cn.prepareStatement(sqlPost);
            ps2.setString(1, resultado);
            ps2.setInt(2, idPostulante);
            ps2.executeUpdate();

            cn.commit();
            response.sendRedirect("listado-evaluaciones.jsp?msg=exito");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("registrar-evaluacion.jsp?error=bd");
        }
    }
}