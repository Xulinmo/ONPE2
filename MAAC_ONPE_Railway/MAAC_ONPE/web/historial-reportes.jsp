<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.Conexion" %>
<%@ page import="java.sql.*" %>
<%
    // Seguridad
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Historial de Descargas - ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
    </head>
    <body class="bg-light">

        <aside class="sidebar">
            <div class="logo">
                <h3>ONPE</h3>
            </div>
            <div class="sidebar-menu">
                <a href="inicio.jsp" class="menu-btn active">
                    <i class="fa-solid fa-house"></i> Inicio
                </a>
                <a href="postulaciones.jsp" class="menu-btn">
                    <i class="fa-solid fa-users"></i> Postulaciones
                </a>
                <a href="evaluaciones.jsp" class="menu-btn">
                    <i class="fa-solid fa-clipboard-check"></i> Evaluaciones
                </a>
                <a href="documentos.jsp" class="menu-btn">
                    <i class="fa-solid fa-file-lines"></i> Documentos
                </a>
                <a href="reportes.jsp" class="menu-btn">
                    <i class="fa-solid fa-chart-column"></i> Reportes
                </a>

                <%-- VALIDACIÓN DE ROL: Solo el Administrador (Rol 1) puede ver este botón --%>
                <% if (user != null && user.getIdRol() == 1) { %>
                <a href="usuarios.jsp" class="menu-btn">
                    <i class="fa-solid fa-user-group"></i> Usuarios
                </a>
                <% }%>

            </div>
            <a href="LogoutServlet" class="logout" style="text-decoration: none;">
                <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
            </a>
        </aside>

        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <div>
                    <h4 class="fw-bold m-0">Historial de Descargas</h4>
                    <small class="text-secondary">Registro de auditoría de reportes exportados (Req. 17)</small>
                </div>
                <div class="ms-auto d-flex align-items-center">
                    
                    <div class="dropdown">
                        <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <div class="avatar bg-dark" style="width: 25px; height: 25px; border-radius: 50%;"></div> <%= user.getNombreUsuario()%>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                            <li>
                                <a class="dropdown-item py-2" href="perfil.jsp">
                                    <i class="fa-solid fa-user text-secondary me-2"></i> Mi Perfil
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item py-2 text-danger fw-bold" href="LogoutServlet">
                                    <i class="fa-solid fa-right-from-bracket me-2"></i> Cerrar sesión
                                </a>
                            </li>
                        </ul>
                    </div>
                    </div>
            </header>

            <div class="content p-4">
                <div class="mb-3">
                    <a href="reportes.jsp" class="btn btn-light border shadow-sm">
                        <i class="fa-solid fa-arrow-left"></i> Volver a Reportes
                    </a>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table align-middle table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th># ID Descarga</th>
                                        <th>Usuario Responsable</th>
                                        <th>Archivo Generado</th>
                                        <th>Fecha y Hora de Generación</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try (Connection cn = Conexion.conectar()) {
                                            // Consulta SQL adaptada a tu diagrama (Req 17 - 3FN)
                                            String sql = "SELECT l.id_descarga, u.usuario AS nombre_usuario, l.nombre_archivo, l.fecha_descarga "
                                                    + "FROM log_descargas l "
                                                    + "INNER JOIN usuario u ON l.id_usuario = u.id_usuario "
                                                    + "ORDER BY l.fecha_descarga DESC";

                                            PreparedStatement ps = cn.prepareStatement(sql);
                                            ResultSet rs = ps.executeQuery();

                                            boolean hayDatos = false;
                                            while (rs.next()) {
                                                hayDatos = true;
                                    %>
                                    <tr>
                                        <td><span class="badge bg-secondary">LOG-<%= rs.getInt("id_descarga")%></span></td>
                                        <td class="fw-bold"><i class="fa-solid fa-user-shield text-primary me-2"></i> <%= rs.getString("nombre_usuario")%></td>
                                        <td>
                                            <span class="text-danger fw-semibold"><i class="fa-solid fa-file-pdf"></i> <%= rs.getString("nombre_archivo")%></span>
                                        </td>
                                        <td><i class="fa-regular fa-clock text-muted"></i> <%= rs.getTimestamp("fecha_descarga")%></td>
                                    </tr>
                                    <%
                                            }
                                            if (!hayDatos) {
                                    %>
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted">Aún no se ha generado ningún reporte.</td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='4' class='text-danger'>Error al cargar el historial: " + e.getMessage() + "</td></tr>");
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>