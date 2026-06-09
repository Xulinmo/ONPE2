package controlador;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.UsuarioDAO;
import modelo.HistorialPassword;

@WebServlet(name = "ListarHistorialServlet", urlPatterns = {"/ListarHistorialServlet"})
public class ListarHistorialServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UsuarioDAO dao = new UsuarioDAO();
        List<HistorialPassword> historial = dao.listarHistorialPasswords();
        request.setAttribute("listaHistorial", historial);
        request.getRequestDispatcher("historial-passwords.jsp").forward(request, response);
    }
}