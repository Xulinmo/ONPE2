package controlador;

import java.io.File;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.Conexion;
import modelo.Usuario;

@WebServlet("/SubirArchivoExtraServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10)
public class SubirArchivosExtraServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Usuario user = (Usuario) request.getSession().getAttribute("usuario");
        String dni = request.getParameter("dni");
        String tipoDoc = request.getParameter("tipo_doc");
        Part filePart = request.getPart("archivo");

        try (Connection cn = Conexion.conectar()) {
            String sqlId = "SELECT id_postulante FROM postulante WHERE dni = ?";
            PreparedStatement ps1 = cn.prepareStatement(sqlId);
            ps1.setString(1, dni);
            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                int idPost = rs.getInt("id_postulante");
                String nombreArch = "EXTRA_" + dni + "_" + System.currentTimeMillis() + ".pdf";
                String ruta = "uploads/" + nombreArch;
                
                // Guardar archivo en la carpeta del servidor
                String path = getServletContext().getRealPath("") + File.separator + ruta;
                File uploadsDir = new File(getServletContext().getRealPath("") + File.separator + "uploads");
                if (!uploadsDir.exists()) uploadsDir.mkdir();
                filePart.write(path);

                // INSERT: Ajustado a tus columnas actuales (image_470839.png)
                String sqlIns = "INSERT INTO carga_documento (id_postulante, tipo_documento, nombre_archivo, ruta_archivo, estado) VALUES (?,?,?,?,'Pendiente')";
                PreparedStatement ps2 = cn.prepareStatement(sqlIns);
                ps2.setInt(1, idPost);
                ps2.setString(2, tipoDoc); // Viene del select tipo_doc
                ps2.setString(3, nombreArch);
                ps2.setString(4, ruta);
                ps2.executeUpdate();

                response.sendRedirect("lista-documentos.jsp?msg=ok");
            } else {
                response.sendRedirect("subir-documento.jsp?error=dni");
            }
        } catch (Exception e) { 
            e.printStackTrace();
            response.sendRedirect("subir-documento.jsp?error=bd");
        }
    }
}