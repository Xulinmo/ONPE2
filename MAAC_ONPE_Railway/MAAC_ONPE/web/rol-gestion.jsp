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
        <title>Gestión de Roles - ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
    </head>
    <body>
        <div class="main p-4">
            <div class="top-actions mb-4">
                <a href="usuarios.jsp" class="btn btn-light shadow-sm border">
                    <i class="fa-solid fa-arrow-left"></i> Volver al Panel
                </a>
            </div>

            <header class="mb-4">
                <h4 class="fw-bold text-danger">Gestión de Roles y Permisos</h4>
                <p class="text-secondary">Configuración de accesos por nivel de usuario (CUS-04)</p>
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

            <div class="row">
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-body">
                            <h5 class="fw-bold"><i class="fa-solid fa-user-shield text-primary"></i> Administrador</h5>
                            <hr>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item"><i class="fa-solid fa-check text-success"></i> Acceso total a reportes</li>
                                <li class="list-group-item"><i class="fa-solid fa-check text-success"></i> Gestión de cuentas de usuario</li>
                                <li class="list-group-item"><i class="fa-solid fa-check text-success"></i> Auditoría de registros</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body">
                            <h5 class="fw-bold"><i class="fa-solid fa-user-pen text-danger"></i> Analista RRHH</h5>
                            <hr>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item"><i class="fa-solid fa-check text-success"></i> Registro de postulantes</li>
                                <li class="list-group-item"><i class="fa-solid fa-check text-success"></i> Evaluación curricular</li>
                                <li class="list-group-item"><i class="fa-solid fa-xmark text-danger"></i> Gestión de usuarios (Restringido)</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>