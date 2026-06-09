<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.PostulanteDAO" %>
<%
    // 1. SEGURIDAD: Solo entra si está logueado (CUS-01)
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. LÓGICA DE BD: Obtenemos el total para mostrarlo en la tarjeta
    PostulanteDAO dao = new PostulanteDAO();
    int totalPostulantes = dao.listarPostulantes().size(); // Esto cuenta cuántos hay en la BD
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Postulaciones - ONPE</title>
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
            <% } %>
            
        </div>
        <a href="LogoutServlet" class="logout" style="text-decoration: none;">
            <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
        </a>
    </aside>

    <div class="main">
        <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
            <div>
                <h4 class="fw-bold m-0">Vistas de Postulaciones</h4>
                <small class="text-secondary">Gestiona los aspirantes y procesos de selección</small>
            </div>
            <div class="ms-auto d-flex align-items-center gap-3">
                <div class="dropdown">
                    <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                        <div class="avatar"></div>
                        <%= user.getNombreUsuario() %>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#">Perfil</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="LogoutServlet">Cerrar sesión</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="content p-4">
            <div class="views-grid">
                <a href="postulaciones-registro.jsp" class="view-card">
                    <div class="view-icon"><i class="fa-solid fa-file-circle-plus"></i></div>
                    <h3>Registrar Postulación</h3>
                    <p>Ingresar nuevos aspirantes al sistema de la ONPE.</p>
                </a>

                <a href="postulacion-listado.jsp" class="view-card">
                    <div class="view-icon"><i class="fa-solid fa-table-list"></i></div>
                    <h3>Listado General</h3>
                    <p>Actualmente hay <strong><%= totalPostulantes %></strong> registros en el sistema.</p>
                </a>
                
                <a href="postulacion-busqueda.jsp" class="view-card">
                    <div class="view-icon"><i class="fa-solid fa-magnifying-glass"></i></div>
                    <h3>Busqueda de postulantes</h3>
                    <p>Buscar postulantes mediante DNI o nombres</p>
                </a>

                <a href="postulacion-estado.jsp" class="view-card">
                    <div class="view-icon"><i class="fa-solid fa-chart-line"></i></div>
                    <h3>Estado de Postulación</h3>
                    <p>Consultar avances, pendientes o aprobados.</p>
                </a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('msg') === 'exito') {
            Swal.fire({
                icon: 'success',
                title: '¡Registro Exitoso!',
                text: 'La información del postulante se guardó correctamente en la base de datos.',
                confirmButtonColor: '#198754'
            }).then(() => {
                window.history.replaceState(null, null, window.location.pathname);
            });
        }
    </script>
</body>
</html>