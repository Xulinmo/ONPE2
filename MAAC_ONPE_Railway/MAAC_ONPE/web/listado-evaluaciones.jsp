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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Listado de Evaluaciones - ONPE</title>
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
                <a href="evaluaciones.jsp" class="menu-btn active"><i class="fa-solid fa-clipboard-check"></i> Evaluaciones</a>
                <a href="documentos.jsp" class="menu-btn"><i class="fa-solid fa-file-lines"></i> Documentos</a>
                <a href="reportes.jsp" class="menu-btn"><i class="fa-solid fa-chart-column"></i> Reportes</a>
                <% if (user != null && user.getIdRol() == 1) { %>
                <a href="usuarios.jsp" class="menu-btn"><i class="fa-solid fa-user-group"></i> Usuarios</a>
                <% }%>
            </div>
            <a href="LogoutServlet" class="logout" style="text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión</a>
        </aside>

        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <div>
                    <h4 class="fw-bold m-0">Panel Principal</h4>
                    <small class="text-secondary">Resumen general del sistema de postulaciones</small>
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
                    <a href="evaluaciones.jsp" class="btn btn-light shadow-sm border">
                        <i class="fa-solid fa-arrow-left"></i> Volver a vistas
                    </a>
                </div>

                <div class="mb-4">
                    <h3 class="fw-bold">Listado de Evaluaciones</h3>
                    <p class="text-secondary m-0">Visualización general de todas las evaluaciones registradas.</p>
                </div>

                <%
                    String msg = request.getParameter("msg");
                    if ("exito".equals(msg)) {
                %>
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i> <strong>¡Éxito!</strong> Evaluación registrada correctamente.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>

                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center pt-3 pb-3">
                        <h5 class="fw-bold m-0">Evaluaciones Registradas</h5>
                        <button class="btn btn-danger btn-sm"><i class="fa-solid fa-file-pdf"></i> Exportar PDF</button>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table align-middle table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>DNI</th>
                                        <th>Postulante</th>
                                        <th>Tipo</th>
                                        <th>Puntaje</th>
                                        <th>Resultado</th>
                                        <th>Evaluador</th>
                                        <th>Fecha</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try (Connection cn = Conexion.conectar()) {
                                            // Consulta cruzando evaluacion, postulante y usuario
                                            String sql = "SELECT e.id_evaluacion, p.dni, p.nombres, p.apellidos, "
                                                    + "e.tipo_evaluacion, e.puntaje, e.resultado, "
                                                    + "u.usuario AS evaluador, e.fecha_eval "
                                                    + "FROM evaluacion e "
                                                    + "INNER JOIN postulante p ON e.id_postulante = p.id_postulante "
                                                    + "LEFT JOIN usuario u ON e.id_usuario = u.id_usuario "
                                                    + "ORDER BY e.fecha_eval DESC, e.id_evaluacion DESC";

                                            PreparedStatement ps = cn.prepareStatement(sql);
                                            ResultSet rs = ps.executeQuery();

                                            boolean hayDatos = false;
                                            while (rs.next()) {
                                                hayDatos = true;
                                                // Configurar el color de la etiqueta (badge) según el resultado
                                                String badgeClass = "bg-secondary";
                                                if ("Aprobado".equals(rs.getString("resultado")))
                                                    badgeClass = "bg-success";
                                                else if ("Observado".equals(rs.getString("resultado")))
                                                    badgeClass = "bg-warning text-dark";
                                                else if ("Rechazado".equals(rs.getString("resultado")) || "Desaprobado".equals(rs.getString("resultado")))
                                                    badgeClass = "bg-danger";
                                    %>
                                    <tr>
                                        <td class="fw-bold"><%= rs.getString("dni")%></td>
                                        <td><%= rs.getString("nombres")%> <%= rs.getString("apellidos")%></td>
                                        <td><%= rs.getString("tipo_evaluacion")%></td>
                                        <td class="fw-bold text-center"><%= rs.getInt("puntaje")%></td>
                                        <td>
                                            <span class="badge <%= badgeClass%>"><%= rs.getString("resultado")%></span>
                                        </td>
                                        <td><i class="fa-solid fa-user-tie text-muted me-1"></i> <%= (rs.getString("evaluador") != null) ? rs.getString("evaluador") : "Sistema"%></td>
                                        <td><%= rs.getDate("fecha_eval")%></td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <button class="btn btn-sm btn-light border text-primary" title="Ver detalles"><i class="fa-solid fa-eye"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                        if (!hayDatos) {
                                    %>
                                    <tr>
                                        <td colspan="8" class="text-center py-4 text-muted">Aún no hay evaluaciones registradas.</td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='8' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <script src="