<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%
    // 1. SEGURIDAD DE SESIÓN (CUS-01)
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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Registro de Postulante - ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
        <link rel="stylesheet" href="Diseno/btn-vistas.css">
    </head>

    <body class="bg-light">
        <aside class="sidebar">
            <div class="logo"><h3>ONPE</h3></div>
            <div class="sidebar-menu">
                <a href="inicio.jsp" class="menu-btn"><i class="fa-solid fa-house"></i> Inicio</a>
                <a href="postulaciones.jsp" class="menu-btn active"><i class="fa-solid fa-users"></i> Postulaciones</a>
                <a href="evaluaciones.jsp" class="menu-btn"><i class="fa-solid fa-clipboard-check"></i> Evaluaciones</a>
                <a href="documentos.jsp" class="menu-btn"><i class="fa-solid fa-file-lines"></i> Documentos</a>
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
                    <h4 class="fw-bold m-0">Registro de Postulaciones</h4>
                    <small class="text-secondary">Complete la información del postulante.</small>
                </div>
                <div class="ms-auto d-flex align-items-center gap-3">
                    <div class="dropdown">
                        <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                            <div class="avatar bg-dark" style="width: 25px; height: 25px; border-radius: 50%;"></div>
                            <%= user.getNombreUsuario() %> 
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                            <li><a class="dropdown-item py-2 text-danger fw-bold" href="LogoutServlet">Cerrar sesión</a></li>
                        </ul>
                    </div>
                </div>
            </header>

            <div class="content p-4">
                <div class="mb-4">
                    <a href="postulaciones.jsp" class="btn btn-light border shadow-sm"><i class="fa-solid fa-arrow-left"></i> Volver a vistas</a>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white pt-3 border-0">
                        <h5 class="fw-bold m-0 text-danger"><i class="fa-solid fa-user-plus"></i> Formulario de Inscripción</h5>
                    </div>
                    <div class="card-body p-4">

                        <form action="RegistrarPostulanteServlet" method="POST" enctype="multipart/form-data" class="needs-validation" novalidate>

                            <div class="row g-3">
                                <%-- Sección de Datos Personales --%>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold small">Nombres <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="nombres" placeholder="Nombres completos" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold small">Apellidos <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="apellidos" placeholder="Apellidos completos" required>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-bold small">DNI <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="dni" maxlength="8" minlength="8" pattern="[0-9]{8}" required 
                                           oninput="validarSoloNumeros(this)">
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-bold small">Teléfono <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="telefono" maxlength="9" minlength="9" pattern="[0-9]{9}" required
                                           oninput="validarSoloNumeros(this)">
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-bold small">Correo <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" name="correo" placeholder="ejemplo@correo.com" required>
                                </div>

                                <%-- Sección de Datos de Postulación --%>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold small">Cargo Postulado <span class="text-danger">*</span></label>
                                    <select class="form-select" name="cargo" required>
                                        <option value="" selected disabled>Seleccione un cargo...</option>
                                        <option value="Coordinador">Coordinador</option>
                                        <option value="Supervisor">Supervisor</option>
                                        <option value="Operador">Operador</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-bold small">Modalidad <span class="text-danger">*</span></label>
                                    <select class="form-select" name="modalidad" required>
                                        <option value="" selected disabled>Seleccione modalidad...</option>
                                        <option value="Presencial">Presencial</option>
                                        <option value="Virtual">Virtual</option>
                                    </select>
                                </div>

                                <div class="col-md-8">
                                    <label class="form-label fw-bold small">Dirección de residencia <span class="text-danger">*</span></label>
                                    <input type="text" name="direccion" class="form-control" placeholder="Av. / Jr. / Calle / Distrito" required>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-bold small">Estado Inicial <span class="text-danger">*</span></label>
                                    <select name="estado" class="form-select" required>
                                        <option value="Pendiente" selected>Pendiente (Por evaluar)</option>
                                        <option value="Aprobado">Aprobado</option>
                                        <option value="Rechazado">Rechazado</option>
                                    </select>
                                </div>

                                <%-- CORRECCIÓN CLAVE: Envío del archivo y Tipo de Documento --%>
                                <div class="col-12 bg-light p-3 rounded border">
                                    <label class="form-label fw-bold text-danger"><i class="fa-solid fa-file-pdf"></i> Adjuntar Currículum Vitae (PDF) <span class="text-danger">*</span></label>
                                    <input type="file" class="form-control" name="archivo_cv" accept=".pdf" required>
                                    <%-- Campo oculto para que el Servlet sepa que este archivo es de tipo 'CV' --%>
                                    <input type="hidden" name="tipo_doc" value="Currículum Vitae">
                                    <div class="invalid-feedback">Debe adjuntar el archivo PDF para completar el registro.</div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-bold small text-muted">Observaciones Adicionales</label>
                                    <textarea class="form-control" name="observaciones" rows="3" placeholder="Información relevante del postulante..."></textarea>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-3 mt-4 border-top pt-3">
                                <button type="reset" class="btn btn-outline-secondary px-4">
                                    <i class="fa-solid fa-rotate-left"></i> Limpiar
                                </button>
                                <button type="submit" class="btn btn-danger px-5 fw-bold shadow-sm">
                                    <i class="fa-solid fa-floppy-disk"></i> Finalizar Registro
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> 

        <script>
            // Validación de Bootstrap y Alertas de SweetAlert2
            (function () {
                'use strict'
                var forms = document.querySelectorAll('.needs-validation')
                Array.prototype.slice.call(forms).forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                            Swal.fire({
                                icon: 'warning',
                                title: 'Campos incompletos',
                                text: 'Por favor, complete todos los campos obligatorios antes de continuar.',
                                confirmButtonColor: '#d33'
                            });
                        }
                        form.classList.add('was-validated');
                    }, false)
                })
            })()

            function validarSoloNumeros(input) {
                input.value = input.value.replace(/[^0-9]/g, '');
            }
        </script>
        <script>
    const urlParams = new URLSearchParams(window.location.search);
    
    // Si el registro fue exitoso
    if (urlParams.get('msg') === 'exito') {
        Swal.fire({
            icon: 'success',
            title: '¡Registrado!',
            text: 'El postulante y su CV se guardaron correctamente.',
            confirmButtonColor: '#28a745'
        });
    }

    // Si hubo un error en el DAO
    if (urlParams.get('error') === '1') {
        Swal.fire({
            icon: 'error',
            title: 'Error al registrar',
            text: 'No se pudo guardar la información. Revisa la consola de NetBeans.',
            confirmButtonColor: '#d33'
        });
    }
</script>
    </body>
</html>