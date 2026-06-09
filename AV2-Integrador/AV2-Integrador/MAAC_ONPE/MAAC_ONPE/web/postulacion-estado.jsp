<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.postulante" %>
<%@ page import="modelo.PostulanteDAO" %>
<%@ page import="java.util.List" %>
<%
    // Seguridad
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    // Capturar la pestaña actual (por defecto mostrará los "Pendientes" para revisarlos rápido)
    String filtroEstado = request.getParameter("estadoFiltro");
    if (filtroEstado == null) filtroEstado = "Pendiente"; 

    // Consultar a la BD
    PostulanteDAO dao = new PostulanteDAO();
    String busquedaBD = filtroEstado.equals("Todos") ? null : filtroEstado;
    List<postulante> lista = dao.filtrarPostulantes(null, busquedaBD, null);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Estado de Postulación - ONPE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="Diseno/fondo.css">
</head>
<body class="bg-light">

    <aside class="sidebar">
        <div class="logo"><h3>ONPE</h3></div>
        <div class="sidebar-menu">
            <a href="inicio.jsp" class="menu-btn"><i class="fa-solid fa-house"></i> Inicio</a>
            <a href="postulaciones.jsp" class="menu-btn active"><i class="fa-solid fa-users"></i> Postulaciones</a>
            <a href="evaluaciones.jsp" class="menu-btn"><i class="fa-solid fa-clipboard-check"></i> Evaluaciones</a>
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
                <h4 class="fw-bold m-0">Estado de Postulación</h4>
                <small class="text-secondary">Audita y gestiona las resoluciones de los candidatos (Req. 09).</small>
            </div>
            <div class="ms-auto d-flex align-items-center">
                <div class="dropdown">
                    <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="avatar bg-dark" style="width: 25px; height: 25px; border-radius: 50%;"></div> <%= user.getNombreUsuario()%>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                        <li><a class="dropdown-item py-2 text-danger fw-bold" href="LogoutServlet"><i class="fa-solid fa-right-from-bracket me-2"></i> Cerrar sesión</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="content p-4">
            <a href="postulaciones.jsp" class="btn btn-light border shadow-sm mb-4">
                <i class="fa-solid fa-arrow-left"></i> Volver a vistas
            </a>

            <ul class="nav nav-pills mb-4 gap-2">
                <li class="nav-item">
                    <a class="nav-link <%= filtroEstado.equals("Pendiente") ? "active bg-warning text-dark fw-bold" : "bg-white text-dark border" %>" href="postulacion-estado.jsp?estadoFiltro=Pendiente">
                        <i class="fa-solid fa-clock"></i> Pendientes por Revisar
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= filtroEstado.equals("Aprobado") ? "active bg-success fw-bold" : "bg-white text-dark border" %>" href="postulacion-estado.jsp?estadoFiltro=Aprobado">
                        <i class="fa-solid fa-check-circle"></i> Aprobados
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= filtroEstado.equals("Rechazado") ? "active bg-danger fw-bold" : "bg-white text-dark border" %>" href="postulacion-estado.jsp?estadoFiltro=Rechazado">
                        <i class="fa-solid fa-times-circle"></i> Rechazados
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= filtroEstado.equals("Todos") ? "active bg-secondary fw-bold" : "bg-white text-dark border" %>" href="postulacion-estado.jsp?estadoFiltro=Todos">
                        <i class="fa-solid fa-list"></i> Ver Todos
                    </a>
                </li>
            </ul>

            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table align-middle table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>DNI</th>
                                    <th>Postulante</th>
                                    <th>Cargo</th>
                                    <th>Documento</th>
                                    <th style="width: 200px;">Acción Rápida (Estado)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (lista != null && !lista.isEmpty()) { 
                                    for (postulante p : lista) { %>
                                <tr>
                                    <td class="fw-bold"><%= p.getDni() %></td>
                                    <td><%= p.getNombres() %> <%= p.getApellidos() %></td>
                                    <td><%= p.getCargo() %></td>
                                    <td>
                                        <% if (p.getRutaCv() != null && !p.getRutaCv().isEmpty()) { %>
                                            <a href="VerDocumentoServlet?id=<%= p.getIdPostulante() %>&ruta=<%= p.getRutaCv() %>" target="_blank" class="text-danger fw-bold text-decoration-none">
                                                <i class="fa-solid fa-file-pdf"></i> Ver CV
                                            </a>
                                        <% } else { %>
                                            <span class="text-muted"><i class="fa-solid fa-file-excel"></i> Sin archivo</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <form action="ActualizarEstadoServlet" method="POST" class="m-0">
                                            <input type="hidden" name="id_postulante" value="<%= p.getIdPostulante() %>">
                                            <select name="nuevo_estado" class="form-select form-select-sm shadow-sm border-secondary cursor-pointer" onchange="this.form.submit()">
                                                <option value="Pendiente" <%= p.getEstado().equals("Pendiente") ? "selected" : "" %>>Pendiente</option>
                                                <option value="Aprobado" <%= p.getEstado().equals("Aprobado") ? "selected" : "" %>>Aprobado</option>
                                                <option value="Rechazado" <%= p.getEstado().equals("Rechazado") ? "selected" : "" %>>Rechazado</option>
                                            </select>
                                        </form>
                                    </td>
                                </tr>
                                <%  } 
                                } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">
                                        <i class="fa-solid fa-check-double fa-2x mb-2 d-block text-success opacity-50"></i>
                                        No hay postulantes en la categoría seleccionada.
                                    </td>
                                </tr>
                                <% } %>
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