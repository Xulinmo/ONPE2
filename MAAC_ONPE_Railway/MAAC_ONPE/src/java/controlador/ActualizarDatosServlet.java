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

        Part filePart = request.getPart("archivo_cv");
        String rutaParaBD = null;

        if (filePart != null && filePart.getSize() > 0) {
            String nombreArchivo = "CV_" + dni + ".pdf";
            
            String rutaFisica = getServletContext().getRealPath("") + File.separator + "uploads";
            File carpeta = new File(rutaFisica);
            
            if (!carpeta.exists()) {
                carpeta.mkdirs(); 
            }
            
            filePart.write(rutaFisica + File.separator + nombreArchivo);
            
            rutaParaBD = "uploads/" + nombreArchivo;
        }
        
        p.setRutaCv(rutaParaBD); 

        PostulanteDAO dao = new PostulanteDAO();
        
        if (dao.actualizarConArchivo(p)) {
            response.sendRedirect("postulacion-listado.jsp?msg=editado");
        } else {
            response.sendRedirect("postulacion-listado.jsp?error=1");
        }
    }
}