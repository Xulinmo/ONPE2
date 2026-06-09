package controlador;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import modelo.postulante;
import modelo.PostulanteDAO;

@WebServlet("/ActualizarDatosServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ActualizarDatosServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); 

        // 1. Capturamos los datos de texto
        int id = Integer.parseInt(request.getParameter("id"));
        String dni = request.getParameter("dni");
        
        postulante p = new postulante();
        p.setIdPostulante(id);
        p.setDni(dni);
        p.setNombres(request.getParameter("nombres"));
        p.setApellidos(request.getParameter("apellidos"));
        p.setCorreo(request.getParameter("correo"));
        p.setTelefono(request.getParameter("telefono"));
        p.setCargo(request.getParameter("cargo"));
        p.setModalidad(request.getParameter("modalidad"));
        p.setDireccion(request.getParameter("direccion"));

        // 2. Lógica para capturar el PDF (Requerimiento 13)
        Part filePart = request.getPart("archivo_cv"); // El 'name' de tu input file en el JSP
        String rutaParaBD = null;

        if (filePart != null && filePart.getSize() > 0) {
            // Nombre del archivo basado en el DNI para evitar duplicados
            String nombreArchivo = "CV_" + dni + ".pdf";
            
            // Ruta física en el servidor (carpeta 'uploads')
            String rutaFisica = getServletContext().getRealPath("") + File.separator + "uploads";
            File carpeta = new File(rutaFisica);
            
            if (!carpeta.exists()) {
                carpeta.mkdirs(); // Crea la carpeta si no existe
            }
            
            // Guardar el archivo físicamente
            filePart.write(rutaFisica + File.separator + nombreArchivo);
            
            // Ruta que se guardará en la base de datos
            rutaParaBD = "uploads/" + nombreArchivo;
        }
        
        // Asignamos la ruta al objeto (será null si no se subió nada)
        p.setRutaCv(rutaParaBD); 

        // 3. Llamar al DAO
        PostulanteDAO dao = new PostulanteDAO();
        
        // USAMOS EL MÉTODO QUE MANEJA ARCHIVOS
        if (dao.actualizarConArchivo(p)) {
            response.sendRedirect("postulacion-listado.jsp?msg=editado");
        } else {
            response.sendRedirect("postulacion-listado.jsp?error=1");
        }
    }
}