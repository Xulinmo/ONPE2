<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.postulante" %>
<%@ page import="modelo.PostulanteDAO" %>
<%@ page import="java.util.List" %>
<%
    // BLOQUE DE SEGURIDAD
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 1. CAPTURAR LOS FILTROS QUE ENVÍA LA MISMA PÁGINA
    String buscar = request.getParameter("txtBuscar");
    String estado = request.getParameter("cboEstado");
    String cargo = request.getParameter("cboCargo");

    // 2. DECIDIR QUÉ MÉTODO USAR
    PostulanteDAO dao = new PostulanteDAO();
    List<postulante> listaPostulantes;

    // Si hay algún filtro activo, usamos el nuevo método
    if (buscar != null || estado != null || cargo != null) {
        listaPostulantes = dao.filtrarPostulantes(buscar, estado, cargo);
    } else {
        // Si es la primera vez que entra a la página, mostramos todos
        listaPostulantes = dao.listarPostulantes();
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Listado de Postulaciones - ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
        <link rel="stylesheet" href="Diseno/btn-vistas.css">
    </head>
    <body>
        <aside class="sidebar">
            <div class="logo"><h3>ONPE</h3></div>
            <div class="sidebar-menu">
                <a href="inicio.jsp" class="menu-btn"><i class="fa-solid fa-house"></i> Inicio</a>
                <a href="postulaciones.jsp" class="menu-btn active"><i class="fa-solid fa-users"></i> Postulaciones</a>
                <a href="evaluaciones.jsp" class="menu-btn"><i class="fa-solid fa-clipboard-check"></i> Evaluaciones</a>
                <a href="documentos.jsp" class="menu-btn"><i class="fa-solid fa-file-lines"></i> Documentos</a>
                <a href="reportes.jsp" class="menu-btn"><i class="fa-solid fa-chart-column"></i> Reportes</a>

                <%-- Validar Rol para ver Usuarios --%>
                <% if (user != null && user.getIdRol() == 1) { %>
                <a href="usuarios.jsp" class="menu-btn"><i class="fa-solid fa-user-group"></i> Usuarios</a>
                <% }%>
                <a href="config.jsp" class="menu-btn"><i class="fa-solid fa-gear"></i> Configuración</a>
            </div>
            <a href="LogoutServlet" class="logout" style="text-decoration:none;">
                <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
            </a>
        </aside>

        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <div>
                    <h4 class="fw-bold m-0">Listado General de Postulaciones</h4>
                    <small class="text-secondary">Visualiza y administra todas las postulaciones registradas.</small>
                </div>
                <div class="ms-auto d-flex align-items-center gap-3">
                    <div class="dropdown">
                        <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                            <div class="avatar"></div> <%= user.getNombreUsuario()%>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="config.jsp">Perfil</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="LogoutServlet">Cerrar sesión</a></li>
                        </ul>
                    </div>
                </div>
            </header>

            <div class="content p-4">
                <div class="top-actions mb-3">
                    <a href="postulaciones.jsp" class="btn btn-light shadow-sm back-btn">
                        <i class="fa-solid fa-arrow-left"></i> Volver a vistas
                    </a>
                </div>

                <div class="dashboard-content">
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-body">

                            <form action="postulacion-listado.jsp" method="GET">
                                <div class="row g-3">
                                    <div class="col-lg-4">
                                        <label class="form-label fw-semibold">Buscar Postulante</label>
                                        <input type="text" name="txtBuscar" class="form-control" placeholder="Buscar por nombre o DNI" 
                                               value="<%= buscar != null ? buscar : ""%>">
                                    </div>
                                    <div class="col-lg-3">
                                        <label class="form-label fw-semibold">Estado</label>
                                        <select name="cboEstado" class="form-select">
                                            <option value="Todos" <%= "Todos".equals(estado) ? "selected" : ""%>>Todos</option>
                                            <option value="Aprobado" <%= "Aprobado".equals(estado) ? "selected" : ""%>>Aprobado</option>
                                            <option value="Pendiente" <%= "Pendiente".equals(estado) ? "selected" : ""%>>Pendiente</option>
                                            <option value="Rechazado" <%= "Rechazado".equals(estado) ? "selected" : ""%>>Rechazado</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-3">
                                        <label class="form-label fw-semibold">Cargo</label>
                                        <select name="cboCargo" class="form-select">
                                            <option value="Todos" <%= "Todos".equals(cargo) ? "selected" : ""%>>Todos</option>
                                            <option value="Coordinador" <%= "Coordinador".equals(cargo) ? "selected" : ""%>>Coordinador</option>
                                            <option value="Supervisor" <%= "Supervisor".equals(cargo) ? "selected" : ""%>>Supervisor</option>
                                            <option value="Operador" <%= "Operador".equals(cargo) ? "selected" : ""%>>Operador</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-2 d-flex align-items-end">
                                        <button type="submit" class="btn btn-danger w-100">
                                            <i class="fa-solid fa-filter"></i> Filtrar
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table align-middle table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>#</th>
                                            <th>DNI</th>
                                            <th>Postulante</th>
                                            <th>Cargo</th>
                                            <th>Fecha</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            // BUCLE PARA RECORRER LA BASE DE DATOS
                                            int cont = 1;
                                            for (postulante p : listaPostulantes) {
                                                // Lógica para pintar la etiqueta según el estado
                                                String badgeClass = "bg-warning text-dark"; // Por defecto Pendiente
                                                if ("Aprobado".equalsIgnoreCase(p.getEstado()))
                                                    badgeClass = "bg-success";
                                                else if ("Rechazado".equalsIgnoreCase(p.getEstado()))
                                                    badgeClass = "bg-danger";
                                        %>
                                        <tr>
                                            <td><%= cont++%></td>
                                            <td><%= p.getDni()%></td>
                                            <td><%= p.getNombres()%> <%= p.getApellidos() != null ? p.getApellidos() : ""%></td>
                                            <td><%= p.getCargo() != null ? p.getCargo() : "No especificado"%></td>
                                            <td><%= p.getFechaRegistro() != null ? p.getFechaRegistro() : "---"%></td>
                                            <td>
                                                <span class="badge <%= badgeClass%>"><%= p.getEstado() != null ? p.getEstado() : "Pendiente"%></span>
                                            </td>

                                            <td>
                                                <div class="d-flex gap-2 align-items-center">
                                                    <%-- Botón 1: Ver CV (Ojito) --%>
                                                    <% if (p.getRutaCv() != null && !p.getRutaCv().isEmpty()) {%>
                                                    <a href="VerDocumentoServlet?id=<%= p.getIdPostulante()%>&ruta=<%= p.getRutaCv()%>" 
                                                       target="_blank" 
                                                       class="btn btn-sm btn-light border" 
                                                       title="Ver CV">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </a>
                                                    <% } else { %>
                                                    <button class="btn btn-sm btn-light border text-muted" title="Sin CV" disabled>
                                                        <i class="fa-solid fa-eye-slash"></i>
                                                    </button>
                                                    <% }%>

                                                    <%-- Botón 2: Evaluar (Tablero azul) --%>
                                                    <a href="evaluar-postulante.jsp?id=<%= p.getIdPostulante()%>" class="btn btn-sm btn-light border text-primary" title="Evaluar">
                                                        <i class="fa-solid fa-clipboard-check"></i>
                                                    </a>

                                                    <%-- Botón 3: Editar (Lápiz verde) --%>
                                                    <a href="editar-postulante.jsp?id=<%= p.getIdPostulante()%>" class="btn btn-sm btn-light border text-success" title="Editar Datos">
                                                        <i class="fa-solid fa-pen"></i>
                                                    </a>

                                                    <%-- Botón 4: Eliminar (Tacho rojo) --%>
                                                    <a href="EliminarPostulanteServlet?id=<%= p.getIdPostulante()%>" 
                                                       class="btn btn-sm btn-danger" 
                                                       onclick="return confirm('¿Estás seguro de eliminar a este postulante?');">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                        <% } %>

                                        <% if (listaPostulantes.isEmpty()) { %>
                                        <tr>
                                            <td colspan="7" class="text-center py-4 text-muted">No se encontraron postulantes.</td>
                                        </tr>
                                        <% }%>
                                    </tbody>
                                </table>
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

       // Alerta de Registro Exitoso (CUS-13)
       if (urlParams.get('msg') === 'exito') {
           Swal.fire({
               icon: 'success',
               title: '¡Registro Completado!',
               text: 'Los datos del postulante y su CV se guardaron correctamente.',
               confirmButtonColor: '#002e6d'
           }).then(() => {
               // Esto limpia la URL para que no salga la alerta cada vez que refrescas
               window.history.replaceState(null, null, window.location.pathname);
           });
       }

       // Alerta de Error
       if (urlParams.get('msg') === 'error') {
           Swal.fire({
               icon: 'error',
               title: 'Error en el Registro',
               text: 'No se pudo guardar la información. Revisa si el DNI ya existe.',
               confirmButtonColor: '#d33'
           });
       }

       // Alerta de Eliminación
       if (urlParams.get('msg') === 'eliminado') {
           Swal.fire({
               icon: 'warning',
               title: 'Postulante Eliminado',
               text: 'El registro ha sido borrado del sistema.',
               confirmButtonColor: '#002e6d'
           });
       }
        </script>
    </body>
</html>