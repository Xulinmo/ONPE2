package controlador;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import modelo.Conexion;
import modelo.Usuario;
import modelo.postulante;
import modelo.PostulanteDAO;

@WebServlet("/RegistrarPostulanteServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class RegistrarPostulanteServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        // 1. Auditoría
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Captura de datos básicos
        String dni = request.getParameter("dni");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String modalidad = request.getParameter("modalidad");
        String cargo = request.getParameter("cargo");
        String estado = request.getParameter("estado");

        // ====================================================================
        // BARRERA DE SEGURIDAD (RF-23): VALIDAR DNI DUPLICADO
        // ====================================================================
        try (Connection cn = Conexion.conectar()) {
            String sqlCheck = "SELECT dni FROM postulante WHERE dni = ?";
            PreparedStatement psCheck = cn.prepareStatement(sqlCheck);
            psCheck.setString(1, dni);
            ResultSet rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {
                // ¡El DNI ya existe! Cortamos el proceso antes de subir el PDF
                response.sendRedirect("postulaciones-registro.jsp?error=dni_duplicado");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // ====================================================================

        String calleZona = request.getParameter("calle_zona");
        String distrito = request.getParameter("distrito");
        String direccionUnida = calleZona + ", " + distrito;

        // 3. Manejo del Archivo
        Part filePart = request.getPart("archivo_cv"); 
        String nombreArchivoFinal = null;
        String rutaBaseDeDatos = null;

        if (filePart != null && filePart.getSize() > 0) {
            
            String tipoContenido = filePart.getContentType();
            if (!"application/pdf".equals(tipoContenido)) {
                response.sendRedirect("postulaciones-registro.jsp?error=solo_pdf");
                return; 
            }

            nombreArchivoFinal = "CV_" + dni + ".pdf";
            rutaBaseDeDatos = "uploads/" + nombreArchivoFinal;
            
            String directorioSubida = getServletContext().getRealPath("") + File.separator + "uploads";
            File directorio = new File(directorioSubida);
            if (!directorio.exists()) directorio.mkdirs();
            
            filePart.write(directorioSubida + File.separator + nombreArchivoFinal);
        }

        // 4. Mapeo y Guardado
        postulante p = new postulante();
        p.setDni(dni);
        p.setNombres(nombres);
        p.setApellidos(apellidos);
        p.setCorreo(correo);
        p.setTelefono(telefono);
        p.setModalidad(modalidad);
        p.setDireccion(direccionUnida); 
        p.setCargo(cargo);
        p.setEstado(estado != null ? estado : "Pendiente");
        p.setRutaCv(rutaBaseDeDatos); 

        PostulanteDAO dao = new PostulanteDAO();
        
        if (dao.registrarConAuditoria(p, user.getNombreUsuario(), nombreArchivoFinal)) { 
            response.sendRedirect("postulacion-listado.jsp?msg=exito");
        } else {
            response.sendRedirect("postulacion-listado.jsp?error=1");
        }
    }
}