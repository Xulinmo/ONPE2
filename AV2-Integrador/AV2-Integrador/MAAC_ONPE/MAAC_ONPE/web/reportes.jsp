<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
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
        <title>Reportes - ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
        <style>
            .report-card {
                border: none;
                border-radius: 15px;
                transition: transform 0.2s, box-shadow 0.2s;
                cursor: pointer;
                text-decoration: none;
                color: inherit;
                height: 100%;
            }
            .report-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
            }
            .icon-box {
                width: 60px;
                height: 60px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 20px;
            }
            .bg-report {
                background-color: #ffebee;
                color: #ef5350;
            }
            .bg-stats {
                background-color: #fce4ec;
                color: #ec407a;
            }
            .bg-history {
                background-color: #fff3e0;
                color: #ffa726;
            }

            .card-title {
                font-weight: 700;
                font-size: 1.25rem;
                margin-bottom: 10px;
            }
            .card-text {
                color: #6c757d;
                font-size: 0.95rem;
                line-height: 1.5;
            }
        </style>
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
                <% }%>

            </div>
            <a href="LogoutServlet" class="logout" style="text-decoration: none;">
                <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
            </a>
        </aside>

        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <div>
                    <h4 class="fw-bold m-0">Panel Principal</h4>
                    <small class="text-secondary">Sistema de Gestión de Postulaciones</small>
                </div>
                <div class="ms-auto d-flex align-items-center">
                    <div class="dropdown">
                        <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                            <div class="avatar bg-dark"></div> <%= user.getNombreUsuario()%>
                        </button>
                    </div>
                </div>
            </header>

            <div class="content p-5">
                <div class="row g-4">

                    <div class="col-md-4">
                        <a href="GenerarReporteServlet?tipo=general" class="card report-card shadow-sm">
                            <div class="card-body p-4">
                                <div class="icon-box bg-report">
                                    <i class="fa-solid fa-table-cells fa-xl"></i>
                                </div>
                                <h5 class="card-title">Reportes Generales</h5>
                                <p class="card-text">Visualiza y exporta la lista completa de postulantes registrados en formatos PDF y Excel.</p>
                            </div>
                        </a>
                    </div>

                    <div class="col-md-4">
                        <a href="inicio-estadistico.jsp" class="card report-card shadow-sm">
                            <div class="card-body p-4">
                                <div class="icon-box bg-stats">
                                    <i class="fa-solid fa-chart-pie fa-xl"></i>
                                </div>
                                <h5 class="card-title">Estadísticas</h5>
                                <p class="card-text">Gráficos y métricas de rendimiento de las evaluaciones y estados de procesos activos.</p>
                            </div>
                        </a>
                    </div>

                    <div class="col-md-4">
                        <a href="historial-reportes.jsp" class="card report-card shadow-sm">
                            <div class="card-body p-4">
                                <div class="icon-box bg-history">
                                    <i class="fa-solid fa-clock-rotate-left fa-xl"></i>
                                </div>
                                <h5 class="card-title">Historial</h5>
                                <p class="card-text">Registro detallado de todos los reportes generados, exportaciones realizadas y descargas.</p>
                            </div>
                        </a>
                    </div>

                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>