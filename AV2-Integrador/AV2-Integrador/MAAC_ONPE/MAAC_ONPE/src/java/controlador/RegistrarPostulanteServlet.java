package controlador;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
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

        // 2. Captura de texto
        String dni = request.getParameter("dni");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String modalidad = request.getParameter("modalidad");
        String direccion = request.getParameter("direccion");
        String cargo = request.getParameter("cargo");
        String estado = request.getParameter("estado");

        // 3. MANEJO DEL ARCHIVO (Sincronizado con las nuevas columnas)
        Part filePart = request.getPart("archivo_cv"); 
        String nombreArchivoFinal = null;
        String rutaBaseDeDatos = null;

        if (filePart != null && filePart.getSize() > 0) {
            // Generamos el nombre que irá a la columna 'nombre_archivo'
            nombreArchivoFinal = "CV_" + dni + ".pdf";
            rutaBaseDeDatos = "uploads/" + nombreArchivoFinal;
            
            String directorioSubida = getServletContext().getRealPath("") + File.separator + "uploads";
            File directorio = new File(directorioSubida);
            if (!directorio.exists()) directorio.mkdirs();
            
            // Guardar físicamente
            filePart.write(directorioSubida + File.separator + nombreArchivoFinal);
        }

        // 4. Mapeo al objeto
        postulante p = new postulante();
        p.setDni(dni);
        p.setNombres(nombres);
        p.setApellidos(apellidos);
        p.setCorreo(correo);
        p.setTelefono(telefono);
        p.setModalidad(modalidad);
        p.setDireccion(direccion);
        p.setCargo(cargo);
        p.setEstado(estado != null ? estado : "Pendiente");
        
        // Pasamos los datos del archivo al objeto
        p.setRutaCv(rutaBaseDeDatos); // Esto va a ruta_archivo
        // Si tu clase 'postulante' no tiene setNombreArchivo, pásalo directamente al DAO

        // 5. Registro con Auditoría
        PostulanteDAO dao = new PostulanteDAO();
        
        /* IMPORTANTE: Asegúrate de que tu método registrarConAuditoria en el DAO 
           ahora reciba nombreArchivoFinal y lo inserte en la columna 'nombre_archivo'
           de la tabla 'carga_documento'.
        */
        if (dao.registrarConAuditoria(p, user.getNombreUsuario(), nombreArchivoFinal)) { 
            response.sendRedirect("postulacion-listado.jsp?msg=exito");
        } else {
            response.sendRedirect("postulacion-listado.jsp?error=1");
        }
    }
}