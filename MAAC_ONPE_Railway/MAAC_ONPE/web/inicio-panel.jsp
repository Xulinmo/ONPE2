<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.DashboardDAO" %>
<%@ page import="java.util.List" %>
<%
    // 1. Verificar sesión
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Definir las variables para el Dashboard
    DashboardDAO dashDao = new DashboardDAO();

    int totalPostulantes = dashDao.contarTotalPostulantes();
    String datosAprobados = dashDao.obtenerDatosGrafico("Aprobado");
    String datosRechazados = dashDao.obtenerDatosGrafico("Desaprobado");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
        <link rel="stylesheet" href="Diseno/btn-vistas.css">
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

                <%-- VALIDACIÓN DE ROL --%>
                <% if (user != null && user.getIdRol() == 1) { %>
                <a href="usuarios.jsp" class="menu-btn">
                    <i class="fa-solid fa-user-group"></i> Usuarios
                </a>
                <% }%>
            </div>

            <a href="LogoutServlet" class="logout" style="text-decoration: none;">
                <i class="fa-solid fa-right-from-bracket me-2"></i> Cerrar sesión
            </a>
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
                <div class="top-actions mb-4 d-flex justify-content-between">
                    <a href="inicio.jsp" class="btn btn-light shadow-sm back-btn">
                        <i class="fa-solid fa-arrow-left"></i> Volver a vistas
                    </a>
                    <button class="btn btn-danger shadow-sm">
                        <i class="fa-solid fa-download"></i> Exportar
                    </button>
                </div>

                <div class="dashboard-content">
                    <div class="row g-3 mb-4">
                        <div class="col-lg-3">
                            <div class="card dashboard-card shadow-sm border-0">
                                <div class="card-body">
                                    <div class="card-top d-flex justify-content-between align-items-center">
                                        <div>
                                            <span class="card-label text-muted small fw-bold">Postulantes Totales</span>
                                            <h1 class="fw-bold m-0 text-primary"><%= totalPostulantes%></h1>
                                        </div>
                                        <div class="card-icon primary bg-primary-subtle text-primary p-3 rounded">
                                            <i class="fa-solid fa-users fa-xl"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4">
                        <div class="col-lg-8">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white py-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h5 class="fw-bold m-0">Postulantes por Mes</h5>
                                            <small class="text-secondary">Comparación mensual</small>
                                        </div>
                                        <select class="form-select w-auto">
                                            <option>Enero</option>
                                            <option>Febrero</option>
                                            <option>Marzo</option>
                                            <option>Abril</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container" style="position: relative; height:300px;">
                                        <canvas id="monthlyChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-header bg-white py-3">
                                    <h5 class="fw-bold m-0">Actividad Reciente</h5>
                                </div>
                                <div class="card-body">
                                    <div class="activity-item d-flex gap-3 mb-3">
                                        <div class="activity-dot bg-success rounded-circle" style="width: 12px; height: 12px; margin-top: 5px;"></div>
                                        <div>
                                            <strong class="d-block" style="font-size: 0.9rem;">Nuevo postulante registrado</strong>
                                            <p class="text-secondary small m-0">Hace 10 minutos</p>
                                        </div>
                                    </div>
                                    <div class="activity-item d-flex gap-3 mb-3">
                                        <div class="activity-dot bg-warning rounded-circle" style="width: 12px; height: 12px; margin-top: 5px;"></div>
                                        <div>
                                            <strong class="d-block" style="font-size: 0.9rem;">Evaluación pendiente</strong>
                                            <p class="text-secondary small m-0">Hace 25 minutos</p>
                                        </div>
                                    </div>
                                    <div class="activity-item d-flex gap-3">
                                        <div class="activity-dot bg-danger rounded-circle" style="width: 12px; height: 12px; margin-top: 5px;"></div>
                                        <div>
                                            <strong class="d-block" style="font-size: 0.9rem;">Documento observado</strong>
                                            <p class="text-secondary small m-0">Hace 1 hora</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> 
                </div> 
            </div> 
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            const dataAprobados = [<%= datosAprobados%>];
            const dataRechazados = [<%= datosRechazados%>];

            const ctx = document.getElementById('monthlyChart');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo'],
                    datasets: [
                        {
                            label: 'Aprobados',
                            data: dataAprobados,
                            backgroundColor: '#198754',
                            borderRadius: 8
                        },
                        {
                            label: 'Rechazados',
                            data: dataRechazados,
                            backgroundColor: '#dc3545',
                            borderRadius: 8
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: { y: { beginAtZero: true } }
                }
            });
        </script>
    </body>
</html>