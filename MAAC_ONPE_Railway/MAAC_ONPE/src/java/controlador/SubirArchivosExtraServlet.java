package controlador;

import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.util.Collection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.Conexion;
import modelo.Usuario;

@WebServlet("/SubirArchivoExtraServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 50,
        maxRequestSize = 1024 * 1024 * 100
)
public class SubirArchivosExtraServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Usuario user = (Usuario) request.getSession().getAttribute("usuario");

        String dni = request.getParameter("dni");
        String tipoDoc = request.getParameter("tipo_doc");

        int idPostulante = 0;
        try (Connection cn = Conexion.conectar()) {
            String sqlId = "SELECT id_postulante FROM postulante WHERE dni = ?";
            PreparedStatement ps1 = cn.prepareStatement(sqlId);
            ps1.setString(1, dni);
            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                idPostulante = rs.getInt("id_postulante");
            } else {
                response.sendRedirect("subir-documento.jsp?error=dni");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("subir-documento.jsp?error=bd");
            return;
        }

        Collection<Part> parts = request.getParts();
        boolean subioAlMenosUno = false;

        try (Connection cn = Conexion.conectar()) {
            String sqlIns = "INSERT INTO carga_documento (id_postulante, tipo_documento, nombre_archivo, ruta_archivo, estado) VALUES (?,?,?,?,'Pendiente')";
            PreparedStatement psInsert = cn.prepareStatement(sqlIns);

            for (Part part : parts) {
                if (part.getName().equals("archivos[]") && part.getSize() > 0) {

                    String tipoContenido = part.getContentType();
                    String nombreOriginal = part.getSubmittedFileName();
                    boolean esPDF = (tipoContenido != null && tipoContenido.toLowerCase().contains("pdf"))
                            || (nombreOriginal != null && nombreOriginal.toLowerCase().endsWith(".pdf"));

                    if (!esPDF) {
                        response.sendRedirect("subir-documento.jsp?error=solo_pdf");
                        return;
                    }

                    String nombreLimpio = nombreOriginal.replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
                    String nombreArchFinal = "MASIVO_" + dni + "_" + System.currentTimeMillis() + "_" + nombreLimpio;
                    String rutaFisica = "uploads/" + nombreArchFinal;

                    String pathServidor = getServletContext().getRealPath("") + File.separator + rutaFisica;
                    File uploadsDir = new File(getServletContext().getRealPath("") + File.separator + "uploads");
                    if (!uploadsDir.exists()) {
                        uploadsDir.mkdir();
                    }
                    part.write(pathServidor);

                    psInsert.setInt(1, idPostulante);
                    psInsert.setString(2, tipoDoc + " (Lote)");
                    psInsert.setString(3, nombreArchFinal);
                    psInsert.setString(4, rutaFisica);
                    psInsert.executeUpdate();

                    subioAlMenosUno = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("subir-documento.jsp?error=bd");
            return;
        }

        if (subioAlMenosUno) {
            response.sendRedirect("subir-documento.jsp?msg=ok_masivo");
        } else {
            response.sendRedirect("subir-documento.jsp?error=vacio");
        }
    }
}

