<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.postulante" %>
<%@ page import="modelo.PostulanteDAO" %>
<%@ page import="java.util.List" %>
<%
    // Seguridad
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    // Capturar parámetros de búsqueda
    String dni = request.getParameter("dni");
    String nombre = request.getParameter("nombre");
    String estado = request.getParameter("estado");

    // Limpiar variables
    if (dni != null && dni.trim().isEmpty()) dni = null;
    if (nombre != null && nombre.trim().isEmpty()) nombre = null;
    if ("Todos".equals(estado)) estado = null;

    // Determinar qué buscar (Si mandan DNI, priorizamos DNI)
    String txtBuscar = (dni != null) ? dni : nombre;

    List<postulante> resultados = null;
    boolean busquedaActiva = (txtBuscar != null || estado != null);

    if (busquedaActiva) {
        PostulanteDAO dao = new PostulanteDAO();
        // Usamos tu método existente (buscar, estado, cargo)
        resultados = dao.filtrarPostulantes(txtBuscar, estado, null);
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Buscar Postulante - ONPE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="Diseno/fondo.css">
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
            <% if (user != null && user.getIdRol() == 1) { %>
                <a href="usuarios.jsp" class="menu-btn"><i class="fa-solid fa-user-group"></i> Usuarios</a>
            <% }%>
        </div>
        <a href="LogoutServlet" class="logout" style="text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión</a>
    </aside>

    <div class="main">
        <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
            <div>
                <h4 class="fw-bold m-0">Buscar Postulante</h4>
                <small class="text-secondary">Consulta información detallada de los postulantes registrados.</small>
            </div>
            <div class="ms-auto d-flex align-items-center">
                <div class="dropdown">
                    <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="avatar bg-dark" style="width: 25px; height: 25px; border-radius: 50%;"></div> <%= user.getNombreUsuario()%>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                        <li><a class="dropdown-item py-2 text-danger fw-bold" href="LogoutServlet"><i class="fa-solid fa-right-from-bracket me-2"></i> Cerrar sesión</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="content p-4">
            
            <a href="postulaciones.jsp" class="btn btn-light border shadow-sm mb-4">
                <i class="fa-solid fa-arrow-left"></i> Volver a vistas
            </a>

            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body p-4">
                    <form action="postulacion-busqueda.jsp" method="GET" class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label fw-bold">DNI</label>
                            <input type="text" name="dni" class="form-control" placeholder="Ingrese DNI" value="<%= (dni != null) ? dni : "" %>">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Nombre del Postulante</label>
                            <input type="text" name="nombre" class="form-control" placeholder="Ingrese nombre" value="<%= (nombre != null) ? nombre : "" %>">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold">Estado</label>
                            <select name="estado" class="form-select">
                                <option value="Todos" <%= (estado == null) ? "selected" : "" %>>Todos</option>
                                <option value="Aprobado" <%= ("Aprobado".equals(estado)) ? "selected" : "" %>>Aprobado</option>
                                <option value="Rechazado" <%= ("Rechazado".equals(estado)) ? "selected" : "" %>>Rechazado</option>
                                <option value="Pendiente" <%= ("Pendiente".equals(estado)) ? "selected" : "" %>>Pendiente</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-danger w-100 fw-bold"><i class="fa-solid fa-magnifying-glass"></i> Buscar</button>
                        </div>
                    </form>
                </div>
            </div>

            <% if (busquedaActiva) { %>
                <h5 class="fw-bold mb-3">Resultado de la Búsqueda</h5>
                
                <% if (resultados != null && !resultados.isEmpty()) { 
                    for (postulante p : resultados) { 
                        // Determinar color del badge de estado
                        String badgeClass = "bg-warning text-dark"; // Pendiente
                        if ("Aprobado".equals(p.getEstado())) badgeClass = "bg-success";
                        if ("Rechazado".equals(p.getEstado())) badgeClass = "bg-danger";
                %>
                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body p-4">
                        <div class="row align-items-center">
                            
                            <div class="col-md-3 text-center border-end">
                                <i class="fa-solid fa-user text-secondary mb-2" style="font-size: 3rem;"></i>
                                <h5 class="fw-bold m-0"><%= p.getNombres() %> <%= p.getApellidos() %></h5>
                                <small class="text-muted">Postulante</small>
                            </div>
                            
                            <div class="col-md-4 ps-4">
                                <div class="mb-3">
                                    <small class="text-muted d-block">DNI</small>
                                    <span class="fw-bold"><%= p.getDni() %></span>
                                </div>
                                <div class="mb-3">
                                    <small class="text-muted d-block">Correo</small>
                                    <span class="fw-bold"><%= (p.getCorreo() != null) ? p.getCorreo() : "No registrado" %></span>
                                </div>
                                <div>
                                    <small class="text-muted d-block">Estado</small>
                                    <span class="badge <%= badgeClass %>"><%= p.getEstado() %></span>
                                </div>
                            </div>
                            
                            <div class="col-md-5">
                                <div class="mb-3">
                                    <small class="text-muted d-block">Cargo Postulado</small>
                                    <span class="fw-bold"><%= p.getCargo() %></span>
                                </div>
                                <div class="mb-3">
                                    <small class="text-muted d-block">Teléfono</small>
                                    <span class="fw-bold"><%= (p.getTelefono() != null) ? p.getTelefono() : "No registrado" %></span>
                                </div>
                                <div>
                                    <small class="text-muted d-block">Observaciones</small>
                                    <span class="fw-bold"><%= ("Aprobado".equals(p.getEstado())) ? "Documentación completa y validada correctamente." : "Evaluación en curso / pendiente." %></span>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                <%  } 
                  } else { %>
                    <div class="alert alert-warning text-center" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i> No se encontraron postulantes con esos criterios.
                    </div>
                <% } %>
            <% } else { %>
                <div class="text-center text-muted mt-5">
                    <i class="fa-solid fa-magnifying-glass fa-3x mb-3 opacity-50"></i>
                    <h5>Ingrese el DNI o nombre para iniciar la búsqueda</h5>
                </div>
            <% } %>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
