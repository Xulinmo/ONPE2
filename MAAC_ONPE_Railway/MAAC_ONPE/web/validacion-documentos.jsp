<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.Conexion" %>
<%@ page import="java.sql.*" %>
<%
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
        <title>Validación de Documentos - ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
    </head>
    <body class="bg-light">

        <aside class="sidebar">
            <div class="logo"><h3>ONPE</h3></div>
            <div class="sidebar-menu">
                <a href="inicio.jsp" class="menu-btn"><i class="fa-solid fa-house"></i> Inicio</a>
                <a href="postulaciones.jsp" class="menu-btn"><i class="fa-solid fa-users"></i> Postulaciones</a>
                <a href="evaluaciones.jsp" class="menu-btn"><i class="fa-solid fa-clipboard-check"></i> Evaluaciones</a>
                <a href="documentos.jsp" class="menu-btn active"><i class="fa-solid fa-file-lines"></i> Documentos</a>
                <a href="reportes.jsp" class="menu-btn"><i class="fa-solid fa-chart-column"></i> Reportes</a>
            </div>
            <a href="LogoutServlet" class="logout" style="text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión</a>
        </aside>

        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <div>
                    <h4 class="fw-bold m-0">Validación de Expedientes</h4>
                    <small class="text-secondary">Revisa y aprueba los documentos cargados por los analistas.</small>
                </div>
                <div class="ms-auto d-flex align-items-center gap-3">
                    <div class="dropdown">
                        <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                            <div class="avatar bg-dark" style="width: 25px; height: 25px; border-radius: 50%;"></div>
                            <%= user.getNombreUsuario()%>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                            <li><a class="dropdown-item py-2" href="perfil.jsp"><i class="fa-solid fa-user-gear me-2 text-secondary"></i> Mi Perfil</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item py-2 text-danger fw-bold" href="LogoutServlet"><i class="fa-solid fa-right-from-bracket me-2"></i> Cerrar sesión</a></li>
                        </ul>
                    </div>
                </div>
            </header>

            <div class="content p-4">
                <div class="mb-4">
                    <a href="documentos.jsp" class="btn btn-light border shadow-sm"><i class="fa-solid fa-arrow-left"></i> Volver</a>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white pt-3 pb-3">
                        <h5 class="fw-bold m-0 text-primary"><i class="fa-solid fa-user-check"></i> Documentos Pendientes de Revisión</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table align-middle table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Postulante</th>
                                        <th>Tipo de Documento</th>
                                        <th>Archivo</th>
                                        <th>Fecha de Carga</th>
                                        <th class="text-center">Acciones de Validación</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try (Connection cn = Conexion.conectar()) {
                                            // Filtramos solo los pendientes para esta vista
                                            String sql = "SELECT c.id_carga, p.nombres, p.apellidos, c.tipo_documento, c.nombre_archivo, c.ruta_archivo, c.fecha_subida "
                                                    + "FROM carga_documento c "
                                                    + "INNER JOIN postulante p ON c.id_postulante = p.id_postulante "
                                                    + "WHERE c.estado = 'Pendiente' "
                                                    + "ORDER BY c.fecha_subida ASC";

                                            PreparedStatement ps = cn.prepareStatement(sql);
                                            ResultSet rs = ps.executeQuery();

                                            boolean hayPendientes = false;
                                            while (rs.next()) {
                                                hayPendientes = true;
                                    %>
                                    <tr>
                                        <td class="fw-bold"><%= rs.getString("nombres")%> <%= rs.getString("apellidos")%></td>
                                        <td><%= rs.getString("tipo_documento")%></td>
                                        <td>
                                            <a href="VerDocumentoServlet?id_carga=<%= rs.getInt("id_carga")%>&ruta=<%= rs.getString("ruta_archivo")%>" 
                                               target="_blank" class="text-danger fw-bold text-decoration-none">
                                                <i class="fa-solid fa-file-pdf"></i> Revisar PDF
                                            </a>
                                        </td>
                                        <td><%= rs.getTimestamp("fecha_subida")%></td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <form action="ProcesarValidacionServlet" method="POST">
                                                    <input type="hidden" name="id_carga" value="<%= rs.getInt("id_carga")%>">
                                                    <input type="hidden" name="accion" value="Validado">
                                                    <button type="submit" class="btn btn-success btn-sm px-3">
                                                        <i class="fa-solid fa-check"></i> Validar
                                                    </button>
                                                </form>
                                                <form action="ProcesarValidacionServlet" method="POST">
                                                    <input type="hidden" name="id_carga" value="<%= rs.getInt("id_carga")%>">
                                                    <input type="hidden" name="accion" value="Rechazado">
                                                    <button type="submit" class="btn btn-danger btn-sm px-3">
                                                        <i class="fa-solid fa-xmark"></i> Rechazar
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                        if (!hayPendientes) {
                                    %>
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            <i class="fa-solid fa-circle-check fa-3x mb-3 d-block opacity-25"></i>
                                            No hay documentos pendientes por validar. ¡Todo está al día!
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
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