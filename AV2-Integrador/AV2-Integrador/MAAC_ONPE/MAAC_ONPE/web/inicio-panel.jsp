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

    // 2. Definir las variables que el error dice que no encuentra
    DashboardDAO dashDao = new DashboardDAO();

    // Estas son las variables que causan el error 500:
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

    <body>
        <!-- SIDEBAR -->
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
            <div class="logout">
                <i class="fa-solid fa-right-from-bracket"></i>
                Cerrar sesión
            </div>

        </aside>

        <div class="main">

            <!-- HEADER -->
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">

                <div>
                    <h4 class="fw-bold m-0">Panel Principal</h4>
                    <small class="text-secondary">
                        Resumen general del sistema de postulaciones
                    </small>
                </div>

                <div class="ms-auto d-flex align-items-center gap-3">

                    <!-- PERFIL -->
                    <div class="dropdown">

                        <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2"
                                data-bs-toggle="dropdown">

                            <div class="avatar"></div>

                            <%= user.getNombreUsuario()%>

                        </button>

                        <ul class="dropdown-menu dropdown-menu-end">

                            <li>
                                <a class="dropdown-item" href="#">
                                    Perfil
                                </a>
                            </li>

                            <li>
                                <a class="dropdown-item" href="#">
                                    Configuración
                                </a>
                            </li>

                            <li><hr class="dropdown-divider"></li>

                            <li>
                                <a class="dropdown-item text-danger" href="#">
                                    Cerrar sesión
                                </a>
                            </li>

                        </ul>

                    </div>

                </div>

            </header>

            <div class="content">

                <!-- BOTONES SUPERIORES -->
                <div class="top-actions">

                    <!-- VOLVER -->
                    <a href="inicio.jsp"
                       class="btn btn-light shadow-sm back-btn">
                        <i class="fa-solid fa-arrow-left"></i>
                        Volver a vistas
                    </a>

                    <!-- EXPORTAR -->
                    <button class="btn btn-danger">
                        <i class="fa-solid fa-download"></i>
                        Exportar
                    </button>
                </div>

                <div class="dashboard-content">

                    <!-- TARJETAS -->
                    <div class="row g-3">

                        <!-- TOTALES -->
                        <div class="col-lg-3">
                            <div class="card dashboard-card shadow-sm border-0">
                                <div class="card-body">
                                    <div class="card-top">
                                        <div>
                                            <span class="card-label">Postulantes Totales</span>
                                            <h1><%= totalPostulantes%></h1> </div>
                                        <div class="card-icon primary">
                                            <i class="fa-solid fa-users"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- GRAFICOS -->
                        <div class="row g-4 mt-1">

                            <!-- GRAFICO -->
                            <div class="col-lg-8">
                                <div class="card border-0 shadow-sm">
                                    <div class="card-header bg-white">
                                        <div class="d-flex justify-content-between align-items-center">

                                            <div>

                                                <h5 class="fw-bold m-0">
                                                    Postulantes por Mes
                                                </h5>

                                                <small class="text-secondary">
                                                    Comparación mensual
                                                </small>

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
                                        <div class="chart-containera">
                                            <canvas id="monthlyChart"></canvas>
                                        </div>
                                    </div>
                                </div>

                            </div>


                            <!-- ACTIVIDAD -->
                            <div class="col-lg-4">

                                <div class="card border-0 shadow-sm h-100">

                                    <div class="card-header bg-white">

                                        <h5 class="fw-bold m-0">
                                            Actividad Reciente
                                        </h5>

                                    </div>

                                    <div class="card-body">

                                        <div class="activity-item">

                                            <div class="activity-dot success-bg"></div>

                                            <div>

                                                <strong>
                                                    Nuevo postulante registrado
                                                </strong>

                                                <p class="text-secondary small m-0">
                                                    Hace 10 minutos
                                                </p>

                                            </div>

                                        </div>


                                        <div class="activity-item">

                                            <div class="activity-dot warning-bg"></div>

                                            <div>

                                                <strong>
                                                    Evaluación pendiente
                                                </strong>

                                                <p class="text-secondary small m-0">
                                                    Hace 25 minutos
                                                </p>

                                            </div>

                                        </div>


                                        <div class="activity-item">

                                            <div class="activity-dot danger-bg"></div>

                                            <div>

                                                <strong>
                                                    Documento observado
                                                </strong>

                                                <p class="text-secondary small m-0">
                                                    Hace 1 hora
                                                </p>

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
                <script src="/chart.js"></script>
                <script>
                    // Pasamos los datos de Java (Servidor) a JS (Navegador)
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
                                    data: dataAprobados, // <-- USAMOS LA VARIABLE DINÁMICA
                                    backgroundColor: '#198754',
                                    borderRadius: 8
                                },
                                {
                                    label: 'Rechazados',
                                    data: dataRechazados, // <-- USAMOS LA VARIABLE DINÁMICA
                                    backgroundColor: '#dc3545',
                                    borderRadius: 8
                                }
                            ]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales: {y: {beginAtZero: true}}
                        }
                    });
                </script>
                </body>
                </html>