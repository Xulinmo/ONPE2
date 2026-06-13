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

    // VARIABLES PARA LOS GRÁFICOS
    int aprobados = 0, observados = 0, rechazados = 0;

    try (Connection cn = Conexion.conectar()) {
        // 1. Contamos los estados globales de los postulantes
        String sqlContar = "SELECT estado, COUNT(*) as total FROM postulante GROUP BY estado";
        PreparedStatement ps = cn.prepareStatement(sqlContar);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            String est = rs.getString("estado");
            if ("Aprobado".equals(est)) {
                aprobados = rs.getInt("total");
            } else if ("Observado".equals(est)) {
                observados = rs.getInt("total");
            } else if ("Rechazado".equals(est) || "Desaprobado".equals(est)) {
                rechazados = rs.getInt("total");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Resultados de Evaluación - ONPE</title>
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
                    <small class="text-secondary">Análisis y resultados generales de las evaluaciones realizadas.</small>
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
                    <a href="evaluaciones.jsp" class="btn btn-light shadow-sm border"><i class="fa-solid fa-arrow-left"></i> Volver a vistas</a>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm p-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div><small class="text-muted fw-bold">Aprobados</small><h2 class="fw-bold m-0"><%= aprobados%></h2></div>
                                <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;"><i class="fa-solid fa-check"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm p-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div><small class="text-muted fw-bold">Rozando (Observados)</small><h2 class="fw-bold m-0"><%= observados%></h2></div>
                                <div class="bg-warning text-dark rounded-circle d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;"><i class="fa-solid fa-eye"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm p-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div><small class="text-muted fw-bold">Desaprobados</small><h2 class="fw-bold m-0"><%= rechazados%></h2></div>
                                <div class="bg-danger text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;"><i class="fa-solid fa-xmark"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm p-4">
                            <h5 class="fw-bold mb-4">Estadísticas de Evaluaciones</h5>
                            <canvas id="barChart" height="150"></canvas>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm p-4">
                            <h5 class="fw-bold mb-4">Distribución</h5>
                            <canvas id="pieChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white pt-3 pb-3 d-flex justify-content-between">
                        <h5 class="fw-bold m-0">Resumen por Cargo Postulado</h5>
                        <button class="btn btn-danger btn-sm"><i class="fa-solid fa-download"></i> Exportar</button>
                    </div>
                    <div class="card-body">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Cargo</th>
                                    <th class="text-center">Aprobados</th>
                                    <th class="text-center">Observados</th>
                                    <th class="text-center">Rechazados</th>
                                    <th class="text-center">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try (Connection cn = Conexion.conectar()) {
                                        String sqlTab = "SELECT cargo, "
                                                + "SUM(CASE WHEN estado = 'Aprobado' THEN 1 ELSE 0 END) as apr, "
                                                + "SUM(CASE WHEN estado = 'Observado' THEN 1 ELSE 0 END) as obs, "
                                                + "SUM(CASE WHEN estado IN ('Rechazado','Desaprobado') THEN 1 ELSE 0 END) as rec "
                                                + "FROM postulante GROUP BY cargo";
                                        PreparedStatement psT = cn.prepareStatement(sqlTab);
                                        ResultSet rsT = psT.executeQuery();
                                        while (rsT.next()) {
                                            int t = rsT.getInt("apr") + rsT.getInt("obs") + rsT.getInt("rec");
                                %>
                                <tr>
                                    <td class="fw-bold"><%= rsT.getString("cargo")%></td>
                                    <td class="text-center"><span class="badge bg-success"><%= rsT.getInt("apr")%></span></td>
                                    <td class="text-center"><span class="badge bg-warning text-dark"><%= rsT.getInt("obs")%></span></td>
                                    <td class="text-center"><span class="badge bg-danger"><%= rsT.getInt("rec")%></span></td>
                                    <td class="text-center fw-bold"><%= t%></td>
                                </tr>
                                <% }
                                } catch (Exception e) {
                                }%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            const ctxBar = document.getElementById('barChart').getContext('2d');
            new Chart(ctxBar, {
                type: 'bar',
                data: {
                    labels: ['Aprobados', 'Rozando', 'Desaprobado'],
                    datasets: [{
                            label: 'Cantidad de Postulantes',
                            data: [<%= aprobados%>, <%= observados%>, <%= rechazados%>],
                            backgroundColor: ['#198754', '#ffc107', '#dc3545'],
                            borderRadius: 5
                        }]
                },
                options: {responsive: true, plugins: {legend: {display: false}}}
            });

            const ctxPie = document.getElementById('pieChart').getContext('2d');
            new Chart(ctxPie, {
                type: 'doughnut',
                data: {
                    labels: ['Aprobados', 'Observados', 'Rechazados'],
                    datasets: [{
                            data: [<%= aprobados%>, <%= observados%>, <%= rechazados%>],
                            backgroundColor: ['#198754', '#ffc107', '#dc3545'],
                            borderWidth: 0
                        }]
                },
                options: {cutout: '70%', plugins: {legend: {position: 'bottom'}}}
            });
        </script>
    </body>
</html>