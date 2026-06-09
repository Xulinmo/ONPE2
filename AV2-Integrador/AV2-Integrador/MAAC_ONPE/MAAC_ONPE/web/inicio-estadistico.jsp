<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.DashboardDAO" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="java.util.List" %>
<%
    // BLOQUE DE SEGURIDAD Y CARGA DE DATOS
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    DashboardDAO dashDao = new DashboardDAO();
    List<String[]> actividades = dashDao.obtenerActividadReciente();
    
    int total = dashDao.contarTotalPostulantes();
    int pendientes = dashDao.contarPorEstado("Pendiente"); 
    int aprobados = dashDao.contarPorEstado("Aprobado");  
    int alertas = dashDao.contarPorEstado("Rechazado");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Actividad - ONPE</title>
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
        <div class="logout">
            <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
        </div>
    </aside>

    <div class="main">
        <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
            <div>
                <h4 class="fw-bold m-0">Actividad del Sistema</h4>
                <small class="text-secondary">Monitoreo en tiempo real de procesos (CUS-25)</small>
            </div>
            <div class="ms-auto d-flex align-items-center gap-3">
                <div class="dropdown">
                    <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                        <div class="avatar"></div>
                        <%= user.getNombreUsuario() %>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#">Perfil</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="LogoutServlet">Cerrar sesión</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="content p-4">
            <div class="top-actions mb-4">
                <a href="inicio.jsp" class="btn btn-light shadow-sm back-btn">
                    <i class="fa-solid fa-arrow-left me-2"></i> Volver a vistas
                </a>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-lg-3">
                    <div class="card dashboard-card shadow-sm border-0">
                        <div class="card-body">
                            <span class="card-label">Pendientes</span>
                            <h1 class="fw-bold"><%= pendientes %></h1>
                            <div class="card-icon warning"><i class="fa-solid fa-clock"></i></div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="card dashboard-card shadow-sm border-0">
                        <div class="card-body">
                            <span class="card-label">Postulantes Totales</span>
                            <h1 class="fw-bold text-primary"><%= total %></h1>
                            <div class="card-icon primary"><i class="fa-solid fa-users"></i></div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="card dashboard-card shadow-sm border-0">
                        <div class="card-body">
                            <span class="card-label">Aprobados</span>
                            <h1 class="fw-bold text-success"><%= aprobados %></h1>
                            <div class="card-icon success"><i class="fa-solid fa-circle-check"></i></div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="col card dashboard-card shadow-sm border-0">
                        <div class="card-body">
                            <span class="card-label">Alertas</span>
                            <h1 class="fw-bold text-danger"><%= alertas %></h1>
                            <div class="card-icon danger"><i class="fa-solid fa-triangle-exclamation"></i></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white py-3">
                            <h5 class="fw-bold m-0">Historial de Auditoría (CUS-25)</h5>
                        </div>
                        <div class="card-body">
                            <% if (actividades.isEmpty()) { %>
                                <p class="text-center text-secondary py-4">No hay actividad registrada aún.</p>
                            <% } else {
                                for (String[] act : actividades) { %>
                                <div class="activity-item d-flex gap-3 mb-3 pb-3 border-bottom">
                                    <div class="activity-icon text-primary"><i class="fa-solid fa-circle-dot"></i></div>
                                    <div class="activity-info">
                                        <strong class="d-block"><%= act[0] %></strong>
                                        <small class="text-secondary">
                                            <i class="fa-solid fa-calendar-day me-1"></i> <%= act[1] %> 
                                            <i class="fa-solid fa-clock ms-2 me-1"></i> <%= act[2] %>
                                        </small>
                                    </div>
                                </div>
                            <% } } %>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white py-3">
                            <h5 class="fw-bold m-0 text-danger">Alertas Críticas</h5>
                        </div>
                        <div class="card-body">
                            <% if (alertas > 0) { %>
                                <div class="alert alert-danger d-flex align-items-center gap-2">
                                    <i class="fa-solid fa-circle-exclamation"></i>
                                    Se detectaron <%= alertas %> documentos con observaciones.
                                </div>
                            <% } %>
                            <div class="alert alert-warning">Existen postulaciones esperando revisión.</div>
                            <div class="alert alert-primary">Nuevos usuarios registrados hoy.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
