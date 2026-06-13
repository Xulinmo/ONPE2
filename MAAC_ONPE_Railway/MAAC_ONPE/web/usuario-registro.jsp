<%@ page import="modelo.Usuario" %>
<%
    // SEGURIDAD: Solo el Administrador debería poder registrar otros usuarios
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
        <title>Registro de Usuarios - ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
        <link rel="stylesheet" href="Diseno/btn-vistas.css">
    </head>
    <body>
        <aside class="sidebar">
            <div class="logo"><h3>ONPE</h3></div>
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
            <a href="LogoutServlet" class="logout" style="text-decoration: none;">
                <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
            </a>
        </aside>

        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <h4 class="fw-bold m-0">Requerimiento 3: Registro de Usuarios</h4>
                <div class="ms-auto d-flex align-items-center gap-2">
                    <div class="avatar"></div> <%= user.getNombreUsuario()%>
                </div>
            </header>

            <div class="content p-4">
                <div class="top-actions mb-4">
                    <a href="usuarios.jsp" class="btn btn-light shadow-sm back-btn">
                        <i class="fa-solid fa-arrow-left"></i> Volver
                    </a>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <form action="RegistrarUsuarioServlet" method="POST" class="needs-validation" novalidate>
                            <div class="row g-4">
                                <div class="col-md-12">
                                    <label class="form-label fw-semibold">Nombre Completo</label>
                                    <input type="text" name="nombres" class="form-control" placeholder="Ej. Juan Pérez" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Nombre de Usuario (ID Acceso)</label>
                                    <input type="text" name="usuario" class="form-control" placeholder="jperez_onpe" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Correo Institucional</label>
                                    <input type="email" name="correo" class="form-control" placeholder="jperez@onpe.gob.pe" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Contraseña Temporal</label>
                                    <input type="password" name="contrasena" class="form-control" required minlength="6">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Rol del Sistema</label>
                                    <select name="id_rol" class="form-select" required>
                                        <option value="" selected disabled>Seleccione un rol</option>
                                        <option value="1">Administrador</option>
                                        <option value="2">Analista RRHH</option>
                                    </select>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-3 mt-4">
                                <button type="submit" class="btn btn-danger">
                                    <i class="fa-solid fa-user-plus"></i> Crear Cuenta
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            // Alerta de éxito si el servlet redirige aquí
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('msg') === 'usuario_creado') {
                Swal.fire({icon: 'success', title: 'Usuario Registrado', text: 'La cuenta ha sido creada exitosamente.'});
            }
        </script>
    </body>
</html>
