<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Documentos - ONPE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="Diseno/fondo.css">
    <style>
        .doc-card { border: none; border-radius: 15px; transition: transform 0.2s; cursor: pointer; text-decoration: none; color: inherit; height: 100%; }
        .doc-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
        .icon-box { width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 20px; background-color: #ffebee; color: #d32f2f; }
    </style>
</head>
<body class="bg-light">

    <aside class="sidebar">
        <div class="logo"><h3>ONPE</h3></div>
        <div class="sidebar-menu">
            <a href="inicio.jsp" class="menu-btn"><i class="fa-solid fa-house"></i> Inicio</a>
            <a href="postulaciones.jsp" class="menu-btn"><i class="fa-solid fa-users"></i> Postulaciones</a>
            <a href="evaluaciones.jsp" class="menu-btn"><i class="fa-solid fa-clipboard-check"></i> Evaluaciones</a>
            <a href="documentos.jsp" class="menu-btn active"><i class="fa-solid fa-file-lines"></i> Documentos</a>
            <a href="reportes.jsp" class="menu-btn"><i class="fa-solid fa-chart-column"></i> Reportes</a>
            <% if (user.getIdRol() == 1) { %>
                <a href="usuarios.jsp" class="menu-btn"><i class="fa-solid fa-user-group"></i> Usuarios</a>
            <% } %>
        </div>
        <a href="LogoutServlet" class="logout" style="text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión</a>
    </aside>

    <div class="main">
        <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
            <div>
                <h4 class="fw-bold m-0">Panel Principal</h4>
                <small class="text-secondary">Sistema de Gestión de Postulaciones</small>
            </div>
            <div class="ms-auto">
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

        <div class="content p-5">
            <div class="row g-4">
                <div class="col-md-4">
                    <a href="lista-documentos.jsp" class="card doc-card shadow-sm">
                        <div class="card-body p-4">
                            <div class="icon-box"><i class="fa-solid fa-list-ul fa-xl"></i></div>
                            <h5 class="fw-bold mb-3">Lista de Documentos</h5>
                            <p class="text-muted small">Mira todos los archivos subidos al sistema y su estado.</p>
                        </div>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="subir-documento.jsp" class="card doc-card shadow-sm">
                        <div class="card-body p-4">
                            <div class="icon-box"><i class="fa-solid fa-cloud-arrow-up fa-xl"></i></div>
                            <h5 class="fw-bold mb-3">Subir Documento</h5>
                            <p class="text-muted small">Carga nuevos archivos y comprobantes al servidor.</p>
                        </div>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="validacion-documentos.jsp" class="card doc-card shadow-sm">
                        <div class="card-body p-4">
                            <div class="icon-box"><i class="fa-solid fa-file-circle-check fa-xl"></i></div>
                            <h5 class="fw-bold mb-3">Validación</h5>
                            <p class="text-muted small">Revisa, aprueba o rechaza los documentos pendientes.</p>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>