package controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.PostulanteDAO;

@WebServlet("/EliminarPostulanteServlet")
public class EliminarPostulanteServlet extends HttpServlet {
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // 1. Capturamos el ID
    String idStr = request.getParameter("id");
    
    if (idStr != null) {
        int id = Integer.parseInt(idStr);
        PostulanteDAO dao = new PostulanteDAO();
        
        // 2. Intentamos eliminar
        if (dao.eliminar(id)) {
            // Solo si el DAO devuelve TRUE (filas afectadas > 0)
            response.sendRedirect("postulacion-listado.jsp?msg=eliminado");
        } else {
            // Si el ID no existía o hubo un error oculto
            response.sendRedirect("postulacion-listado.jsp?error=no_encontrado");
        }
    }
}
}