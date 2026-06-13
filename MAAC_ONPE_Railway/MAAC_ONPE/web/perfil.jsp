<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%
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
        <title>Mi Perfil - ONPE</title>
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
                <a href="documentos.jsp" class="menu-btn"><i class="fa-solid fa-file-lines"></i> Documentos</a>
                <a href="reportes.jsp" class="menu-btn"><i class="fa-solid fa-chart-column"></i> Reportes</a>
            </div>
            <a href="LogoutServlet" class="logout" style="text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión</a>
        </aside>

        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <div>
                    <h4 class="fw-bold m-0">Configuración de Perfil</h4>
                    <small class="text-secondary">Gestione su información personal y credenciales de seguridad.</small>
                </div>
            </header>

            <div class="content p-4">
                <div class="row justify-content-center g-4">
                    
                    <div class="col-lg-7">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-header bg-white pt-4 pb-2 border-0 text-center">
                                <div class="position-relative d-inline-block mb-3">
                                    <img src="uploads/perfiles/default.png" id="preview" class="rounded-circle border shadow-sm" style="width: 120px; height: 120px; object-fit: cover;" alt="Foto">
                                </div>
                                <h5 class="fw-bold m-0"><%= user.getNombreUsuario() %></h5>
                                <span class="badge bg-danger mt-1">Personal ODPE</span>
                            </div>

                            <div class="card-body p-4 pt-0">
                                <form action="ActualizarPerfilServlet" method="POST" enctype="multipart/form-data">
                                    <input type="hidden" name="tipo_operacion" value="datos">
                                    <input type="hidden" name="id_usuario" value="<%= user.getIdUsuario() %>">

                                    <div class="row g-3">
                                        <div class="col-12">
                                            <label class="form-label fw-semibold small">Fotografía Institucional</label>
                                            <input type="file" class="form-control" name="foto_perfil" accept="image/png, image/jpeg" onchange="document.getElementById('preview').src = window.URL.createObjectURL(this.files[0])">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold small">Correo Electrónico</label>
                                            <input type="email" class="form-control" name="correo" value="<%= user.getCorreo() != null ? user.getCorreo() : "" %>" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold small">Teléfono de Contacto</label>
                                            <input type="text" class="form-control" name="telefono" placeholder="Ej: 987654321" required>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-danger w-100 fw-bold mt-4 shadow-sm"><i class="fa-solid fa-floppy-disk"></i> Guardar Datos</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-5">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-header bg-white pt-4 pb-2 border-0">
                                <h5 class="fw-bold text-danger m-0"><i class="fa-solid fa-shield-halved"></i> Seguridad</h5>
                                <small class="text-muted">Actualice su contraseña de acceso.</small>
                            </div>
                            <div class="card-body p-4 pt-2">
                                <form action="ActualizarPerfilServlet" method="POST" enctype="multipart/form-data">
                                    <input type="hidden" name="tipo_operacion" value="password">

                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small">Contraseña Actual <span class="text-danger">*</span></label>
                                        <input type="password" name="pass_actual" class="form-control" placeholder="Ingrese contraseña actual" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small">Nueva Contraseña <span class="text-danger">*</span></label>
                                        <input type="password" name="pass_nueva" class="form-control" placeholder="Ingrese nueva contraseña" required>
                                    </div>
                                    <button type="submit" class="btn btn-dark w-100 fw-bold mt-2 shadow-sm"><i class="fa-solid fa-key"></i> Cambiar Contraseña</button>
                                </form>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('msg') === 'perfil_ok') { Swal.fire({ icon: 'success', title: '¡Actualizado!', text: 'Sus datos fueron actualizados correctamente.', confirmButtonColor: '#28a745' }); }
            if (urlParams.get('msg') === 'pass_ok') { Swal.fire({ icon: 'success', title: '¡Contraseña Cambiada!', text: 'Su contraseña fue actualizada con éxito.', confirmButtonColor: '#28a745' }); }
            if (urlParams.get('error') === 'pass_incorrecta') { Swal.fire({ icon: 'error', title: 'Acceso Denegado', text: 'La contraseña actual ingresada es incorrecta.', confirmButtonColor: '#d33' }); }
            if (urlParams.get('error') === 'formato_img') { Swal.fire({ icon: 'error', title: 'Error de Imagen', text: 'Solo se aceptan archivos JPG o PNG.', confirmButtonColor: '#d33' }); }
            if (urlParams.get('error') === 'bd') { Swal.fire({ icon: 'error', title: 'Error de Servidor', text: 'Ocurrió un problema con la base de datos.', confirmButtonColor: '#d33' }); }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
                                                               const urlParams = new URLSearchParams(window.location.search);

                                                               if (urlParams.get('msg') === 'perfil_ok') {
                                                                   Swal.fire({
                                                                       icon: 'success',
                                                                       title: 'Perfil Actualizado',
                                                                       text: 'Tus datos de contacto y fotografía se actualizaron correctamente.',
                                                                       confirmButtonColor: '#28a745'
                                                                   });
                                                               }

                                                               if (urlParams.get('error') === 'formato_img') {
                                                                   Swal.fire({
                                                                       icon: 'error',
                                                                       title: 'Formato Inválido',
                                                                       text: 'Solo se permiten subir archivos de imagen (JPG o PNG).',
                                                                       confirmButtonColor: '#d33'
                                                                   });
                                                               }

                                                               if (urlParams.get('error') === 'bd') {
                                                                   Swal.fire({
                                                                       icon: 'error',
                                                                       title: 'Error Interno',
                                                                       text: 'No se pudo actualizar la información en la base de datos.',
                                                                       confirmButtonColor: '#d33'
                                                                   });
                                                               }
        </script>
    </body>
</html>