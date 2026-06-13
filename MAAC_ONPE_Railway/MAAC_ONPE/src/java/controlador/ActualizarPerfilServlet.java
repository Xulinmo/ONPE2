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

@WebServlet("/ActualizarPerfilServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB
    maxRequestSize = 1024 * 1024 * 10    // 10MB
)
public class ActualizarPerfilServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String tipoOperacion = request.getParameter("tipo_operacion");

        if ("password".equals(tipoOperacion)) {
            String passActual = request.getParameter("pass_actual");
            String passNueva = request.getParameter("pass_nueva");

            try (Connection cn = Conexion.conectar()) {
                String sqlCheck = "SELECT * FROM usuario WHERE usuario = ? AND contraseña = ?";
                PreparedStatement ps1 = cn.prepareStatement(sqlCheck);
                ps1.setString(1, user.getNombreUsuario());
                ps1.setString(2, passActual);
                ResultSet rs = ps1.executeQuery();

                if (rs.next()) {
                    String sqlUpdate = "UPDATE usuario SET contraseña = ? WHERE usuario = ?";
                    PreparedStatement ps2 = cn.prepareStatement(sqlUpdate);
                    ps2.setString(1, passNueva);
                    ps2.setString(2, user.getNombreUsuario());
                    ps2.executeUpdate();

                    response.sendRedirect("perfil.jsp?msg=pass_ok");
                } else {
                    response.sendRedirect("perfil.jsp?error=pass_incorrecta");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("perfil.jsp?error=bd");
            }
        } 
        
        
        else if ("datos".equals(tipoOperacion)) {
            int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");

            Part filePart = request.getPart("foto_perfil");
            boolean actualizoFoto = false;
            String nombreFotoFinal = null;

            if (filePart != null && filePart.getSize() > 0) {
                String tipoContenido = filePart.getContentType();
                if (!tipoContenido.startsWith("image/")) {
                    response.sendRedirect("perfil.jsp?error=formato_img");
                    return;
                }

                nombreFotoFinal = "PERFIL_" + idUsuario + "_" + System.currentTimeMillis() + ".jpg";
                String rutaDirectorio = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "perfiles";
                File directorio = new File(rutaDirectorio);
                if (!directorio.exists()) directorio.mkdirs();

                filePart.write(rutaDirectorio + File.separator + nombreFotoFinal);
                actualizoFoto = true;
            }

            try (Connection cn = Conexion.conectar()) {
                String sql;
                PreparedStatement ps;

                if (actualizoFoto) {
                    String rutaBD = "uploads/perfiles/" + nombreFotoFinal;
                    sql = "UPDATE usuario SET correo = ?, telefono = ?, foto_perfil = ? WHERE id_usuario = ?";
                    ps = cn.prepareStatement(sql);
                    ps.setString(1, correo);
                    ps.setString(2, telefono);
                    ps.setString(3, rutaBD);
                    ps.setInt(4, idUsuario);
                } else {
                    sql = "UPDATE usuario SET correo = ?, telefono = ? WHERE id_usuario = ?";
                    ps = cn.prepareStatement(sql);
                    ps.setString(1, correo);
                    ps.setString(2, telefono);
                    ps.setInt(3, idUsuario);
                }
                ps.executeUpdate();

                user.setCorreo(correo);
                session.setAttribute("usuario", user);

                response.sendRedirect("perfil.jsp?msg=perfil_ok");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("perfil.jsp?error=bd");
            }
        }
    }
}