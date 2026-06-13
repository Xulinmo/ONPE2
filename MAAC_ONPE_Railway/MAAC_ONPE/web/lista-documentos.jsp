<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.Conexion" %>
<%@ page import="java.sql.*" %>
<%
    // 1. SEGURIDAD: Verificación de sesión
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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lista de Documentos - ONPE</title>
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
                <% if (user.getIdRol() == 1) { %>
                <a href="usuarios.jsp" class="menu-btn"><i class="fa-solid fa-user-group"></i> Usuarios</a>
                <% }%>
            </div>
            <a href="LogoutServlet" class="logout" style="text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión</a>
        </aside>

        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <div>
                    <h4 class="fw-bold m-0">Lista de Documentos</h4>
                    <small class="text-secondary">Repositorio centralizado de archivos y expedientes.</small>
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
                <div class="mb-4 d-flex justify-content-between align-items-center">
                    <a href="documentos.jsp" class="btn btn-light border shadow-sm"><i class="fa-solid fa-arrow-left"></i> Volver a vistas</a>
                    <a href="subir-documento.jsp" class="btn btn-danger shadow-sm"><i class="fa-solid fa-plus"></i> Nuevo Documento</a>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white pt-3 pb-3">
                        <h5 class="fw-bold m-0">Archivos Registrados</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table align-middle table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Postulante</th>
                                        <th>Tipo de Documento</th>
                                        <th>Nombre del Archivo</th>
                                        <th>Fecha de Carga</th>
                                        <th>Estado</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try (Connection cn = Conexion.conectar()) {
                                            String sql = "SELECT c.id_carga, p.nombres, p.apellidos, c.tipo_documento, "
                                                    + "c.nombre_archivo, c.ruta_archivo, c.fecha_subida, c.estado "
                                                    + "FROM carga_documento c "
                                                    + "INNER JOIN postulante p ON c.id_postulante = p.id_postulante "
                                                    + "ORDER BY c.fecha_subida DESC";

                                            PreparedStatement ps = cn.prepareStatement(sql);
                                            ResultSet rs = ps.executeQuery();

                                            while (rs.next()) {
                                                String estado = rs.getString("estado");
                                                String tipoDoc = rs.getString("tipo_documento"); // Optimizamos capturando el tipo
                                                
                                                String badgeClass = "bg-warning text-dark";
                                                if ("Validado".equals(estado)) {
                                                    badgeClass = "bg-success";
                                                }
                                                if ("Rechazado".equals(estado)) {
                                                    badgeClass = "bg-danger";
                                                }
                                    %>
                                    <tr>
                                        <td><%= rs.getString("nombres")%> <%= rs.getString("apellidos")%></td>
                                        <td><span class="badge bg-light text-dark border"><%= tipoDoc %></span></td>
                                        <td>
                                            <span class="text-danger fw-bold">
                                                <i class="fa-solid fa-file-pdf me-1"></i> <%= rs.getString("nombre_archivo")%>
                                            </span>
                                        </td>
                                        <td><small><%= rs.getTimestamp("fecha_subida")%></small></td>
                                        <td><span class="badge <%= badgeClass%>"><%= estado%></span></td>
                                        
                                        <!-- REALIZAMOS EL CONTROL GRANULAR DE ACCESOS (RF-30) -->
                                        <td class="text-center">
                                            <% 
                                                // 1. Identificamos si contiene palabras clave de información sensible
                                                boolean esConfidencial = tipoDoc.contains("Salud") || tipoDoc.contains("Penales");
                                                // 2. Evaluamos si el usuario activo NO posee el rol jerárquico 1 (Administrador)
                                                boolean esAdmin = user.getIdRol() == 1;

                                                if (esConfidencial && !esAdmin) { 
                                            %>
                                                <!-- Botón Inhabilitado con aviso de privacidad para usuarios comunes -->
                                                <button class="btn btn-sm btn-secondary" disabled title="Acceso restringido: Requiere privilegios de alta gerencia o Administrador.">
                                                    <i class="fa-solid fa-lock"></i> Restringido
                                                </button>
                                            <% } else { %>
                                                <!-- Acceso permitido para documentos públicos o personal autorizado -->
                                                <a href="VerDocumentoServlet?id_carga=<%= rs.getInt("id_carga")%>&ruta=<%= rs.getString("ruta_archivo")%>" 
                                                   target="_blank" class="btn btn-sm btn-outline-primary">
                                                    <i class="fa-solid fa-eye"></i>
                                                </a>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='6' class='text-danger text-center'>Error: " + e.getMessage() + "</td></tr>");
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