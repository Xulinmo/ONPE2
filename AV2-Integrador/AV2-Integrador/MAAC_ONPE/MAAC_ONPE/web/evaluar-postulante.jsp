<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.*" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    int id = Integer.parseInt(request.getParameter("id"));
    PostulanteDAO dao = new PostulanteDAO();
    postulante p = dao.obtenerPorId(id); 
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Evaluar Postulante - ONPE</title>
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
                <h4 class="fw-bold m-0">Registrar Evaluación</h4>
                <small class="text-secondary">Registro de resultados y observaciones de postulantes evaluados.</small>
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
            <div class="mb-4">
                <a href="postulacion-listado.jsp" class="btn btn-light shadow-sm border">
                    <i class="fa-solid fa-arrow-left"></i> Volver a listado
                </a>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white pt-3 pb-2">
                    <h5 class="fw-bold m-0 text-danger"><i class="fa-solid fa-clipboard-list"></i> Datos de la Evaluación</h5>
                </div>
                <div class="card-body p-4">
                    
                    <form action="RegistrarEvaluacionServlet" method="POST">
                        <input type="hidden" name="id_postulante" value="<%= id %>">

                        <div class="row g-4">
                            <div class="col-lg-4">
                                <label class="form-label fw-semibold">DNI del Postulante</label>
                                <input type="text" class="form-control bg-light" value="<%= p.getDni() %>" readonly>
                            </div>

                            <div class="col-lg-4">
                                <label class="form-label fw-semibold">Nombre del Postulante</label>
                                <input type="text" class="form-control bg-light" value="<%= p.getNombres() %> <%= p.getApellidos() %>" readonly>
                            </div>

                            <div class="col-lg-4">
                                <label class="form-label fw-semibold">Cargo Postulado</label>
                                <input type="text" class="form-control bg-light" value="<%= p.getCargo() %>" readonly>
                            </div>

                            <div class="col-lg-4">
                                <label class="form-label fw-semibold">Tipo de Evaluación</label>
                                <select name="tipo_evaluacion" class="form-select" required>
                                    <option value="" disabled selected>Seleccionar evaluación</option>
                                    <option value="Entrevista">Entrevista</option>
                                    <option value="Examen Técnico">Examen Técnico</option>
                                    <option value="Evaluación Psicológica">Evaluación Psicológica</option>
                                </select>
                            </div>

                            <div class="col-lg-4">
                                <label class="form-label fw-semibold">Puntaje</label>
                                <input type="number" name="puntaje" class="form-control" placeholder="0 - 100" min="0" max="100" required>
                            </div>

                            <div class="col-lg-4">
                                <label class="form-label fw-semibold">Resultado</label>
                                <select name="resultado" class="form-select" required>
                                    <option value="" disabled selected>Seleccionar resultado</option>
                                    <option value="Aprobado">Aprobado</option>
                                    <option value="Observado">Observado</option>
                                    <option value="Rechazado">Rechazado</option>
                                </select>
                            </div>

                            <div class="col-lg-6">
                                <label class="form-label fw-semibold">Fecha de Evaluación</label>
                                <input type="date" name="fecha_eval" class="form-control" required>
                            </div>

                            <div class="col-lg-6">
                                <label class="form-label fw-semibold">Evaluador Responsable</label>
                                <input type="text" class="form-control bg-light" value="<%= user.getNombreUsuario() %>" readonly>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold">Observaciones</label>
                                <textarea name="observacion" class="form-control" rows="4" placeholder="Ingrese observaciones de la evaluación" required></textarea>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-3 mt-4">
                            <a href="postulacion-listado.jsp" class="btn btn-light border"><i class="fa-solid fa-xmark"></i> Cancelar</a>
                            <button type="submit" class="btn btn-danger px-4"><i class="fa-solid fa-floppy-disk"></i> Guardar Evaluación</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>