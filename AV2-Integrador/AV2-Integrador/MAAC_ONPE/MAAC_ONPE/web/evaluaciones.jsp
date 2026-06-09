<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%
    // Seguridad
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vistas de Evaluaciones - ONPE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="Diseno/fondo.css">
    
    <style>
        .views-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .view-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-decoration: none;
            color: #333;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }
        .view-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0,0,0,0.1);
            color: #333;
        }
        .view-icon {
            background-color: #ffebee;
            color: #dc3545;
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 15px;
        }
        .view-card h3 {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .view-card p {
            font-size: 0.9rem;
            color: #6c757d;
            margin: 0;
        }
    </style>
</head>

<body class="bg-light">
    <aside class="sidebar">
        <div class="logo">
            <h3>ONPE</h3>
        </div>
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
        <a href="LogoutServlet" class="logout" style="text-decoration: none;">
            <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
        </a>
    </aside>

    <div class="main">
        <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
            <div>
                <h4 class="fw-bold m-0">Vistas de Evaluaciones</h4>
                <small class="text-secondary">Selecciona una opción para gestionar las evaluaciones del sistema.</small>
            </div>
            <div class="ms-auto d-flex align-items-center gap-3">
                <div class="dropdown">
                    <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                        <div class="avatar bg-dark" style="width: 25px; height: 25px; border-radius: 50%;"></div> <%= user.getNombreUsuario() %>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                        <li><a class="dropdown-item py-2 text-danger fw-bold" href="LogoutServlet"><i class="fa-solid fa-right-from-bracket me-2"></i> Cerrar sesión</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="content p-4">
            <div class="views-grid">

                <a href="postulacion-listado.jsp" class="view-card">
                    <div class="view-icon"><i class="fa-solid fa-clipboard-check"></i></div>
                    <h3>Registrar Evaluación</h3>
                    <p>Registrar resultados y observaciones de postulantes.</p>
                </a>

                <a href="listado-evaluaciones.jsp" class="view-card">
                    <div class="view-icon"><i class="fa-solid fa-table-list"></i></div>
                    <h3>Listado de Evaluaciones</h3>
                    <p>Visualizar todas las evaluaciones registradas.</p>
                </a>

                <a href="resultados-evaluacion.jsp" class="view-card">
                    <div class="view-icon"><i class="fa-solid fa-chart-line"></i></div>
                    <h3>Resultados de Evaluación</h3>
                    <p>Consultar aprobados, observados y rechazados.</p>
                </a>

                <a href="observaciones.jsp" class="view-card">
                    <div class="view-icon"><i class="fa-solid fa-circle-exclamation"></i></div>
                    <h3>Observaciones</h3>
                    <p>Revisar incidencias detectadas durante evaluaciones.</p>
                </a>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>