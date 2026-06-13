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

    // 2. VARIABLES PARA TARJETAS DE RESUMEN
    int totales = 0, criticas = 0, resueltas = 0;

    try (Connection cn = Conexion.conectar()) {
        // Consulta para los contadores (Filtramos solo los que tienen resultado 'Observado')
        String sqlCount = "SELECT "
                + "COUNT(*) as total, "
                + "SUM(CASE WHEN nivel_riesgo = 'Alto' THEN 1 ELSE 0 END) as crit, "
                + "SUM(CASE WHEN estado_obs = 'Resuelta' THEN 1 ELSE 0 END) as res "
                + "FROM evaluacion WHERE resultado = 'Observado'";

        PreparedStatement ps = cn.prepareStatement(sqlCount);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            totales = rs.getInt("total");
            criticas = rs.getInt("crit");
            resueltas = rs.getInt("res");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Observaciones - ONPE</title>
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
                    <h4 class="fw-bold m-0">Observaciones</h4>
                    <small class="text-secondary">Revisión de incidencias detectadas durante las evaluaciones</small>
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
                        <div class="card border-0 shadow-sm p-4">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="text-muted fw-bold">Observaciones Totales</span>
                                <i class="fa-solid fa-triangle-exclamation text-warning"></i>
                            </div>
                            <h1 class="fw-bold"><%= totales%></h1>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm p-4">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="text-muted fw-bold">Críticas (Riesgo Alto)</span>
                                <i class="fa-solid fa-circle-exclamation text-danger"></i>
                            </div>
                            <h1 class="fw-bold"><%= criticas%></h1>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm p-4">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="text-muted fw-bold">Resueltas</span>
                                <i class="fa-solid fa-check text-success"></i>
                            </div>
                            <h1 class="fw-bold text-success"><%= resueltas%></h1>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm p-3">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0 fw-bold">Listado de Observaciones</h5>
                        <input type="text" class="form-control w-25" placeholder="Buscar postulante...">
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Postulante</th>
                                    <th>Evaluación</th>
                                    <th>Observación</th>
                                    <th>Gravedad</th>
                                    <th>Fecha</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try (Connection cn = Conexion.conectar()) {
                                        // Consulta detallada cruzada con Postulante
                                        String sqlList = "SELECT e.id_evaluacion, p.nombres, p.apellidos, e.tipo_evaluacion, e.observacion, "
                                                + "e.nivel_riesgo, e.fecha_eval, e.estado_obs "
                                                + "FROM evaluacion e "
                                                + "INNER JOIN postulante p ON e.id_postulante = p.id_postulante "
                                                + "WHERE e.resultado = 'Observado' ORDER BY e.fecha_eval DESC";

                                        PreparedStatement psL = cn.prepareStatement(sqlList);
                                        ResultSet rsL = psL.executeQuery();

                                        boolean hayDatos = false;
                                        while (rsL.next()) {
                                            hayDatos = true;
                                            // Estilos para Gravedad y Estado
                                            String gravClass = "Alto".equals(rsL.getString("nivel_riesgo")) ? "bg-danger" : "bg-warning text-dark";
                                            String estObs = rsL.getString("estado_obs");
                                %>
                                <tr>
                                    <td class="fw-bold"><%= rsL.getString("nombres")%> <%= rsL.getString("apellidos")%></td>
                                    <td><%= rsL.getString("tipo_evaluacion")%></td>
                                    <td class="text-muted small"><%= rsL.getString("observacion")%></td>
                                    <td><span class="badge <%= gravClass%>"><%= rsL.getString("nivel_riesgo")%></span></td>
                                    <td><%= rsL.getDate("fecha_eval")%></td>
                                    <td>
                                        <% if ("Pendiente".equals(estObs)) {%>
                                        <form action="ResolverObservacionServlet" method="POST" class="m-0">
                                            <input type="hidden" name="id_evaluacion" value="<%= rsL.getInt("id_evaluacion")%>">
                                            <button type="submit" class="btn badge bg-danger border-0" title="Click para resolver">
                                                <i class="fa-solid fa-clock"></i> Pendiente
                                            </button>
                                        </form>
                                        <% } else { %>
                                        <span class="badge bg-success">
                                            <i class="fa-solid fa-check-double"></i> Resuelta
                                        </span>
                                        <% } %>
                                    </td>
                                </tr>
                                <%
                                    }
                                    if (!hayDatos) {
                                %>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">No se encontraron observaciones pendientes.</td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.querySelector('input[placeholder="Buscar postulante..."]').addEventListener('keyup', function () {
                let valor = this.value.toLowerCase();
                let filas = document.querySelectorAll('tbody tr');

                filas.forEach(fila => {
                    let texto = fila.innerText.toLowerCase();
                    fila.style.display = texto.includes(valor) ? '' : 'none';
                });
            });
        </script>
    </body>
</html>