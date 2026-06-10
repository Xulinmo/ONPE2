<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%
    // BLOQUE DE SEGURIDAD (CUS-01 / CUS-04)
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
    <title>Dashboard - MAACC ONPE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="Diseno/fondo.css">
    <link rel="stylesheet" href="Diseno/btn-vistas.css">


</head>
<body>
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
            <% } %>
            
        </div>
        <a href="LogoutServlet" class="logout" style="text-decoration: none;">
            <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
        </a>
    </aside>

    <div class="main">
        <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
            <div>
                <h4 class="fw-bold m-0">Vistas del Dashboard</h4>
                <small class="text-secondary">Bienvenido al sistema de gestión de procesos</small>
            </div>
            <div class="ms-auto d-flex align-items-center gap-3">
                <div class="dropdown">
                    <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                        <div class="avatar"></div>
                        <%= user.getNombreUsuario() %>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="config.jsp">Perfil</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="LogoutServlet">Cerrar sesión</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="views-grid">
            <a href="inicio-panel.jsp" class="view-card">
                <div class="view-icon"><i class="fa-solid fa-chart-pie"></i></div>
                <h3>Panel Principal</h3>
                <p>Estadísticas generales y resumen del sistema</p>
            </a>
            <a href="inicio-estadistico.jsp" class="view-card">
                <div class="view-icon"><i class="fa-solid fa-chart-column"></i></div>
                <h3>Estadísticas Mensuales</h3>
                <p>Gráficos de aprobados y rechazados por mes</p>
            </a>
            <a href="inicio-actividad.jsp" class="view-card">
                <div class="view-icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
                <h3>Actividad Reciente</h3>
                <p>Últimos movimientos, procesos del sistema e historial</p>
            </a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
