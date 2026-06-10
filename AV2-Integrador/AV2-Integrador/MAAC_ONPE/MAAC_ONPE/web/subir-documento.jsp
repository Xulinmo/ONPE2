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
    <title>Subir Documento - ONPE</title>
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
            <a href="evaluaciones.jsp" class="menu-btn"><i class="fa-solid fa-clipboard-check"></i> Evaluaciones</a>
            <a href="documentos.jsp" class="menu-btn active"><i class="fa-solid fa-file-lines"></i> Documentos</a>
            <a href="reportes.jsp" class="menu-btn"><i class="fa-solid fa-chart-column"></i> Reportes</a>
        </div>
        <a href="LogoutServlet" class="logout" style="text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión</a>
    </aside>
//
    <div class="main">
        <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
            <h4 class="fw-bold m-0">Subir Documento Adicional</h4>
            <div class="ms-auto">
                <div class="dropdown">
                    <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                        <div class="avatar bg-dark" style="width: 25px; height: 25px; border-radius: 50%;"></div> <%= user.getNombreUsuario() %>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                        <li><a class="dropdown-item py-2 text-danger fw-bold" href="LogoutServlet">Cerrar sesión</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="content p-4">
            <div class="mb-4">
                <a href="documentos.jsp" class="btn btn-light border shadow-sm"><i class="fa-solid fa-arrow-left"></i> Volver</a>
            </div>

            <div class="card border-0 shadow-sm mx-auto" style="max-width: 600px;">
                <div class="card-header bg-white pt-3 pb-2 border-0">
                    <h5 class="fw-bold m-0 text-danger"><i class="fa-solid fa-cloud-arrow-up"></i> Carga de Archivos</h5>
                </div>
                <div class="card-body p-4">
                    <form action="SubirArchivoExtraServlet" method="POST" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label class="form-label fw-bold">DNI del Postulante</label>
                            <input type="text" name="dni" class="form-control" placeholder="Ingrese DNI" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tipo de Documento</label>
                            <select name="tipo_doc" class="form-select" required>
                                <option value="Declaración Jurada">Declaración Jurada</option>
                                <option value="Antecedentes Penales">Antecedentes Penales</option>
                                <option value="Certificado de Salud">Certificado de Salud</option>
                                <option value="Otro">Otro documento</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Seleccionar PDF</label>
                            <input type="file" name="archivo" class="form-control" accept=".pdf" required>
                        </div>
                        <button type="submit" class="btn btn-danger w-100 fw-bold py-2">Subir y Registrar</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
