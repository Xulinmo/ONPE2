<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.HistorialPassword" %>
<%@ page import="java.util.List" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<HistorialPassword> lista = (List<HistorialPassword>) request.getAttribute("listaHistorial");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial de Contraseñas - ONPE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="Diseno/fondo.css">
    <link rel="stylesheet" href="Diseno/btn-vistas.css">
</head>
<body>
    <aside class="sidebar">
        <div class="logo"><h3>ONPE</h3></div>
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
            <% } %>
            
        </div>
        <a href="LogoutServlet" class="logout" style="text-decoration: none;">
            <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
        </a>
    </aside>

    <div class="main">
        <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
            <div>
                <h4 class="fw-bold m-0">Auditoría de Credenciales</h4>
                <small class="text-secondary">Registro histórico de cambios de contraseña (CUS-25)</small>
            </div>
            <div class="ms-auto d-flex align-items-center gap-3">
                <div class="dropdown">
                    <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                        <div class="avatar"></div>
                        <%= user.getNombreUsuario() %> 
                    </button>
                </div>
            </div>
        </header>

        <div class="content p-4">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="fw-bold m-0">Movimientos de Seguridad</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Usuario</th>
                                    <th>Contraseña Anterior (Segura)</th>
                                    <th>Fecha y Hora de Cambio</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (lista != null) {
                                    for (HistorialPassword hp : lista) { %>
                                    <tr>
                                        <td>#<%= hp.getIdHistorial() %></td>
                                        <td class="fw-semibold"><%= hp.getNombreUsuario() %></td>
                                        <td class="text-muted"><code><%= hp.getContraseñaAnterior().substring(0, 8) %>...</code></td>
                                        <td><%= hp.getFechaCambio() %></td>
                                        <td><span class="badge bg-success-subtle text-success border border-success-subtle">Archivado</span></td>
                                    </tr>
                                <% } } else { %>
                                    <tr><td colspan="5" class="text-center py-4">No hay registros aún.</td></tr>
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