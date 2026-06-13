package controlador;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.postulante;
import modelo.PostulanteDAO;

@WebServlet("/GenerarReporteServlet")
public class GenerarReporteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=Reporte_Aprobados_ONPE.pdf");
        modelo.Usuario user = (modelo.Usuario) request.getSession().getAttribute("usuario");

        try {
            Document documento = new Document(PageSize.A4);
            PdfWriter.getInstance(documento, response.getOutputStream());
            documento.open();

            Font fuenteTitulo = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.RED);
            Paragraph titulo = new Paragraph("OFICINA NACIONAL DE PROCESOS ELECTORALES", fuenteTitulo);
            titulo.setAlignment(Element.ALIGN_CENTER);
            documento.add(titulo);

            documento.add(new Paragraph(" "));
            documento.add(new Paragraph("LISTADO OFICIAL DE POSTULANTES APROBADOS"));
            documento.add(new Paragraph("Fecha de generación: " + new java.util.Date().toString()));
            documento.add(new Paragraph(" "));

            PdfPTable tabla = new PdfPTable(4);
            tabla.setWidthPercentage(100);

            tabla.addCell(new PdfPCell(new Phrase("DNI", FontFactory.getFont(FontFactory.HELVETICA_BOLD))));
            tabla.addCell(new PdfPCell(new Phrase("Nombres y Apellidos", FontFactory.getFont(FontFactory.HELVETICA_BOLD))));
            tabla.addCell(new PdfPCell(new Phrase("Cargo", FontFactory.getFont(FontFactory.HELVETICA_BOLD))));
            tabla.addCell(new PdfPCell(new Phrase("Estado", FontFactory.getFont(FontFactory.HELVETICA_BOLD))));

            PostulanteDAO dao = new PostulanteDAO();
            List<postulante> lista = dao.filtrarPostulantes(null, "Aprobado", null);

            for (postulante p : lista) {
                tabla.addCell(p.getDni());
                tabla.addCell(p.getNombres() + " " + p.getApellidos());
                tabla.addCell(p.getCargo());
                tabla.addCell(p.getEstado());
            }
            documento.add(tabla);
            documento.add(new Paragraph(" "));
            Paragraph firma = new Paragraph("\n\n\n__________________________\nFirma del Analista Responsable");
            firma.setAlignment(Element.ALIGN_CENTER);
            documento.add(firma);

            if (user != null) {
                try (java.sql.Connection cn = modelo.Conexion.conectar()) {
                    String sqlLog = "INSERT INTO log_descargas (id_usuario, nombre_archivo) VALUES (?, ?)";
                    java.sql.PreparedStatement psLog = cn.prepareStatement(sqlLog);
                    psLog.setInt(1, user.getIdUsuario());
                    psLog.setString(2, "Reporte_Aprobados_ONPE.pdf");
                    psLog.executeUpdate();
                } catch (Exception e) {
                    System.err.println("Error al registrar log de descargas: " + e.getMessage());
                }
            }

            documento.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
