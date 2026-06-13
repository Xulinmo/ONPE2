<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.*" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    PostulanteDAO dao = new PostulanteDAO();
    postulante p = dao.obtenerPorId(id);

    // CAPTURAR LA FECHA ACTUAL DE FORMA AUTOMÁTICA (Formato yyyy-MM-dd)
    String fechaHoy = java.time.LocalDate.now().toString();
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
                    <a href="postulacion-listado.jsp" class="btn btn-light shadow-sm border">
                        <i class="fa-solid fa-arrow-left"></i> Volver a listado
                    </a>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white pt-3 pb-2">
                        <h5 class="fw-bold m-0 text-danger"><i class="fa-solid fa-clipboard-list"></i> Datos de la Evaluación</h5>
                    </div>
                    <div class="card-body p-4">

                        <%
                            // BARRERA DE SEGURIDAD 1: SI EL POSTULANTE YA JALÓ, NO SE MUESTRA EL FORMULARIO
                            String estadoActual = p.getEstado();
                            if (estadoActual != null && (estadoActual.equalsIgnoreCase("Rechazado") || estadoActual.equalsIgnoreCase("Desaprobado"))) {
                        %>
                        <div class="alert alert-danger text-center p-5 border-0 shadow-sm rounded-3">
                            <i class="fa-solid fa-ban fa-4x mb-3 text-danger"></i>
                            <h4 class="fw-bold text-dark">Acceso Restringido - Postulante Descalificado</h4>
                            <p class="text-muted fs-6 mx-auto mb-4" style="max-width: 550px;">
                                El postulante <strong><%= p.getNombres()%> <%= p.getApellidos()%></strong> tiene un estado de 
                                <span class="badge bg-danger fs-6"><%= estadoActual%></span>. 
                                Por normativas del proceso de selección, no es posible registrar nuevas evaluaciones para perfiles eliminados.
                            </p>
                            <a href="postulacion-listado.jsp" class="btn btn-danger px-4 fw-bold shadow-sm">Regresar al Listado</a>
                        </div>
                        <%
                        } else {
                        %>
                        <form action="RegistrarEvaluacionServlet" method="POST">
                            <input type="hidden" name="id_postulante" value="<%= id%>">

                            <div class="row g-4">
                                <div class="col-lg-4">
                                    <label class="form-label fw-semibold">DNI del Postulante</label>
                                    <input type="text" class="form-control bg-light" value="<%= p.getDni()%>" readonly>
                                </div>

                                <div class="col-lg-4">
                                    <label class="form-label fw-semibold">Nombre del Postulante</label>
                                    <input type="text" class="form-control bg-light" value="<%= p.getNombres()%> <%= p.getApellidos()%>" readonly>
                                </div>

                                <div class="col-lg-4">
                                    <label class="form-label fw-semibold">Cargo Postulado</label>
                                    <input type="text" class="form-control bg-light" value="<%= p.getCargo()%>" readonly>
                                </div>

                                <div class="col-12 my-2">
                                    <div class="p-3 rounded border bg-white shadow-sm d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="fw-bold mb-1 text-dark">
                                                <i class="fa-solid fa-id-card text-danger me-2"></i> Cotejo de Identidad en Sede (RF-32)
                                            </h6>
                                            <small class="text-secondary">Confirme que ha revisado visualmente el DNI físico original del postulante en la sede de la ODPE.</small>
                                        </div>
                                        <div class="d-flex align-items-center gap-4">

                                            <div id="indicador_identidad">
                                                <span class="badge bg-warning text-dark fs-6 px-3 py-2 shadow-sm">
                                                    <i class="fa-solid fa-triangle-exclamation me-1"></i> Pendiente de Cotejo
                                                </span>
                                            </div>

                                            <div class="form-check form-switch fs-5 m-0">
                                                <input class="form-check-input" type="checkbox" id="checkIdentidad" name="identidad_verificada" value="1" onchange="alternarEstadoConfianza(this)">
                                                <label class="form-check-label small fw-bold text-secondary" for="checkIdentidad" style="cursor: pointer;">
                                                    Identidad Verificada
                                                </label>
                                            </div>

                                        </div>
                                    </div>
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
                                    <input type="number" 
                                           name="puntaje" 
                                           id="puntaje" 
                                           class="form-control" 
                                           placeholder="0 - 100" 
                                           min="0" max="100" 
                                           required 
                                           oninput="validarCoherencia()">
                                </div>

                                <%
                                    java.time.LocalDate hoy = java.time.LocalDate.now();
                                %>
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-dark">
                                        <i class="fa-solid fa-calendar-day text-danger me-1"></i> Fecha de la Evaluación
                                    </label>
                                    <input type="date" name="fecha_evaluacion" class="form-control bg-light fw-bold text-secondary" 
                                           value="<%= hoy%>" readonly required>
                                    <small class="text-danger fw-bold">
                                        <i class="fa-solid fa-lock"></i> Campo protegido: El examen debe registrarse estrictamente con la fecha de hoy.
                                    </small>
                                </div>

                                <div class="col-lg-4">
                                    <label class="form-label fw-semibold">Resultado</label>
                                    <select name="resultado" id="resultado" class="form-select" required onchange="validarCoherencia()">
                                        <option value="" disabled selected>Seleccionar resultado</option>
                                        <option value="Aprobado">Aprobado</option>
                                        <option value="Observado">Observado</option>
                                        <option value="Rechazado">Rechazado</option>
                                    </select>
                                    <div class="invalid-feedback fw-bold" id="error_resultado">Seleccione un resultado coherente.</div>
                                </div>

                                <div class="col-lg-6">
                                    <label class="form-label fw-semibold">Evaluador Responsable</label>
                                    <input type="text" class="form-control bg-light" value="<%= user.getNombreUsuario()%>" readonly>
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
                        <%
                            }
                        %>

                    </div>
                </div>
            </div>  
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                        function validarCoherencia() {
                                            var inputPuntaje = document.getElementById('puntaje');
                                            var selectResultado = document.getElementById('resultado');
                                            var cajaError = document.getElementById('error_resultado');

                                            selectResultado.setCustomValidity('');

                                            var nota = parseInt(inputPuntaje.value);
                                            var estado = selectResultado.value;

                                            if (!isNaN(nota) && estado !== '') {

                                                var notaMinima = 65;

                                                if (nota < notaMinima && estado === 'Aprobado') {
                                                    selectResultado.setCustomValidity('Incoherencia');
                                                    cajaError.innerHTML = '¡Contradicción! No puede marcar <strong>Aprobado</strong> con una nota menor a ' + notaMinima + '.';

                                                } else if (nota >= notaMinima && estado === 'Rechazado') {
                                                    selectResultado.setCustomValidity('Incoherencia');
                                                    cajaError.innerHTML = '¡Contradicción! Tiene nota aprobatoria (' + nota + '), no debería ser <strong>Rechazado</strong>.';
                                                }
                                            }
                                        }
        </script>
        <script>
            function alternarEstadoConfianza(checkbox) {
                var contenedorIndicador = document.getElementById('indicador_identidad');

                if (checkbox.checked) {
                    // PASO 3 y 4 DEL RF-32: Actualiza a Confianza Alta y pinta el indicador visual VERDE
                    contenedorIndicador.innerHTML =
                            '<span class="badge bg-success text-white fs-6 px-3 py-2 shadow-sm border border-success animate__animated animate__fadeIn">' +
                            '<i class="fa-solid fa-circle-check me-1"></i> Identidad Verificada (Confianza Alta)' +
                            '</span>';
                } else {
                    // Regresa al estado inicial si se desmarca
                    contenedorIndicador.innerHTML =
                            '<span class="badge bg-warning text-dark fs-6 px-3 py-2 shadow-sm">' +
                            '<i class="fa-solid fa-triangle-exclamation me-1"></i> Pendiente de Cotejo' +
                            '</span>';
                }
            }
        </script>
    </body>
</html>