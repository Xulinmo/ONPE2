<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.Conexion" %>
<%@ page import="java.sql.*" %>
<%
    // 1. SEGURIDAD DE SESIÓN: Solo Administrador
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (user.getIdRol() != 1) {
        response.sendRedirect("inicio-panel.jsp?error=privilegios");
        return;
    }

    // 2. CONTROL DINÁMICO DE CONFIGURACIÓN (Variables en Memoria)
    // Inicializar el modo mantenimiento si no existe
    if (application.getAttribute("modoMantenimiento") == null) {
        application.setAttribute("modoMantenimiento", "Desactivado");
    }

    // Capturar acciones dinámicas enviadas por la misma página
    String accion = request.getParameter("accion");
    if (accion != null) {
        if (accion.equals("toggleMantenimiento")) {
            String estadoActual = (String) application.getAttribute("modoMantenimiento");
            String nuevoEstado = estadoActual.equals("Activado") ? "Desactivado" : "Activado";
            application.setAttribute("modoMantenimiento", nuevoEstado);
            response.sendRedirect("configuracion.jsp?res=mantenimiento_ok");
            return;
        }
        
        if (accion.equals("limpiarTablas")) {
            // Ejecución del bloque de limpieza seguro que armamos antes
            try (Connection cn = Conexion.conectar();
                 Statement st = cn.createStatement()) {
                st.executeUpdate("SET FOREIGN_KEY_CHECKS = 0");
                st.executeUpdate("TRUNCATE TABLE visualizacion_log");
                st.executeUpdate("TRUNCATE TABLE carga_documento");
                st.executeUpdate("TRUNCATE TABLE evaluacion");
                st.executeUpdate("TRUNCATE TABLE asignacion");
                st.executeUpdate("TRUNCATE TABLE historial");
                st.executeUpdate("TRUNCATE TABLE postulante");
                st.executeUpdate("SET FOREIGN_KEY_CHECKS = 1");
                response.sendRedirect("configuracion.jsp?res=limpieza_ok");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("configuracion.jsp?res=error_bd");
                return;
            }
        }
    }

    String modoMaint = (String) application.getAttribute("modoMantenimiento");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Configuración Avanzada - ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
        <link rel="stylesheet" href="Diseno/btn-vistas.css">
    </head>

    <body class="bg-light">
        <!-- BARRA LATERAL -->
        <aside class="sidebar">
            <div class="logo"><h3>ONPE</h3></div>
            <div class="sidebar-menu">
                <a href="inicio-panel.jsp" class="menu-btn"><i class="fa-solid fa-house"></i> Inicio</a>
                <a href="postulaciones.jsp" class="menu-btn"><i class="fa-solid fa-users"></i> Postulaciones</a>
                <a href="evaluaciones.jsp" class="menu-btn"><i class="fa-solid fa-clipboard-check"></i> Evaluaciones</a>
                <a href="documentos.jsp" class="menu-btn"><i class="fa-solid fa-file-lines"></i> Documentos</a>
                <a href="reportes.jsp" class="menu-btn"><i class="fa-solid fa-chart-column"></i> Reportes</a>
                <a href="usuarios.jsp" class="menu-btn"><i class="fa-solid fa-user-group"></i> Usuarios</a>
                <a href="configuracion.jsp" class="menu-btn active"><i class="fa-solid fa-gear"></i> Configuración</a>
            </div>
            <a href="LogoutServlet" class="logout" style="text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión</a>
        </aside>

        <!-- CONTENIDO PRINCIPAL -->
        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <div>
                    <h4 class="fw-bold m-0">Consola de Configuración Dinámica</h4>
                    <small class="text-secondary">Herramientas globales de control de entorno y diccionarios del sistema.</small>
                </div>
                <div class="ms-auto d-flex align-items-center gap-3">
                    <div class="dropdown">
                        <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                            <div class="avatar bg-dark" style="width: 25px; height: 25px; border-radius: 50%;"></div>
                            <%= user.getNombreUsuario() %> 
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
                
                <!-- SECCIÓN 1: PANEL DE OPERACIONES EN TIEMPO REAL (MÓDULO DINÁMICO) -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white pt-3 border-0">
                        <h5 class="fw-bold m-0 text-danger"><i class="fa-solid fa-sliders"></i> Acciones de Control en Caliente</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <!-- Interruptor Modo Mantenimiento -->
                            <div class="col-md-4">
                                <div class="p-3 border rounded bg-white text-center h-100 d-flex flex-column justify-content-between">
                                    <div>
                                        <h6 class="fw-bold text-dark"><i class="fa-solid fa-hammer"></i> Modo Mantenimiento</h6>
                                        <p class="text-muted small">Cambia el acceso global para analistas.</p>
                                        <span class="badge <%= modoMaint.equals("Activado") ? "bg-danger" : "bg-success" %> mb-3 px-3 py-2 fs-6">
                                            <%= modoMaint %>
                                        </span>
                                    </div>
                                    <a href="configuracion.jsp?accion=toggleMantenimiento" class="btn <%= modoMaint.equals("Activado") ? "btn-outline-success" : "btn-outline-danger" %> w-100 fw-bold">
                                        <%= modoMaint.equals("Activado") ? "Desactivar Modo" : "Activar Modo" %>
                                    </a>
                                </div>
                            </div>

                            <!-- Simulador de Alertas Dinámicas -->
                            <div class="col-md-4">
                                <div class="p-3 border rounded bg-white text-center h-100 d-flex flex-column justify-content-between">
                                    <div>
                                        <h6 class="fw-bold text-dark"><i class="fa-solid fa-bell"></i> Tester de Notificaciones</h6>
                                        <p class="text-muted small">Prueba el comportamiento del framework SweetAlert2 de forma inmediata.</p>
                                    </div>
                                    <button class="btn btn-outline-warning w-100 fw-bold mt-2" onclick="probarAlerta()">
                                        Lanzar Alerta de Prueba
                                    </button>
                                </div>
                            </div>

                            <!-- Mantenimiento de Datos Pruebas (TRUNCATE) -->
                            <div class="col-md-4">
                                <div class="p-3 border rounded bg-white text-center h-100 d-flex flex-column justify-content-between">
                                    <div>
                                        <h6 class="fw-bold text-danger"><i class="fa-solid fa-trash-can"></i> Purga de Datos (Truncate)</h6>
                                        <p class="text-muted small text-start">Limpia las tablas asociadas a postulantes conservando usuarios locales.</p>
                                    </div>
                                    <button class="btn btn-danger w-100 fw-bold" onclick="confirmarPurga()">
                                        <i class="fa-solid fa-triangle-exclamation"></i> Vaciar Tablas de Prueba
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECCIÓN 2: VISTAS DE LAS TABLAS MAESTRAS -->
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-header bg-white pt-3 border-0">
                                <h6 class="fw-bold m-0 text-secondary"><i class="fa-solid fa-user-lock"></i> Roles de Usuario</h6>
                            </div>
                            <div class="card-body">
                                <table class="table table-hover border-top">
                                    <thead class="table-light">
                                        <tr><th style="width: 20%;">ID</th><th>Nombre del Rol</th></tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try (Connection cn = Conexion.conectar(); Statement st = cn.createStatement(); ResultSet rs = st.executeQuery("SELECT * FROM rol")) {
                                                while(rs.next()) {
                                        %>
                                        <tr>
                                            <td><span class="badge bg-secondary"><%= rs.getInt("id_rol") %></span></td>
                                            <td class="fw-semibold text-dark"><%= rs.getString("nombre_rol") %></td>
                                        </tr>
                                        <% }} catch(Exception e) {} %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-header bg-white pt-3 border-0">
                                <h6 class="fw-bold m-0 text-secondary"><i class="fa-solid fa-traffic-light"></i> Estados de Documentos</h6>
                            </div>
                            <div class="card-body">
                                <table class="table table-hover border-top">
                                    <thead class="table-light">
                                        <tr><th style="width: 20%;">ID</th><th>Estado</th></tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try (Connection cn = Conexion.conectar(); Statement st = cn.createStatement(); ResultSet rs = st.executeQuery("SELECT * FROM estado")) {
                                                while(rs.next()) {
                                                    String color = "bg-warning text-dark";
                                                    if(rs.getInt("id_estado") == 3) color = "bg-success";
                                                    if(rs.getInt("id_estado") == 5) color = "bg-danger";
                                        %>
                                        <tr>
                                            <td><span class="badge bg-light text-dark border"><%= rs.getInt("id_estado") %></span></td>
                                            <td><span class="badge <%= color %>"><%= rs.getString("nombre_estado") %></span></td>
                                        </tr>
                                        <% }} catch(Exception e) {} %>
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
            // Respuestas dinámicas usando SweetAlert2
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('res') === 'mantenimiento_ok') {
                Swal.fire({ icon: 'info', title: 'Entorno Actualizado', text: 'Se ha cambiado el estado de mantenimiento del sistema.', confirmButtonColor: '#0d6efd' });
            }
            if (urlParams.get('res') === 'limpieza_ok') {
                Swal.fire({ icon: 'success', title: 'Purga Exitosa', text: 'Se han vaciado todas las tablas de prueba. IDs reiniciados a 1.', confirmButtonColor: '#198754' });
            }
            if (urlParams.get('res') === 'error_bd') {
                Swal.fire({ icon: 'error', title: 'Error Crítico', text: 'Hubo un fallo al intentar limpiar la base de datos.', confirmButtonColor: '#dc3545' });
            }

            // Función del botón de prueba de alertas
            function probarAlerta() {
                Swal.fire({
                    icon: 'question',
                    title: '¡Conexión Correcta!',
                    text: 'El disparador JS responde de manera dinámica.',
                    confirmButtonColor: '#ffc107'
                });
            }

            // Confirmación interactiva previa a la purga de base de datos
            function confirmarPurga() {
                Swal.fire({
                    title: '¿Estás completamente seguro?',
                    text: "Se borrarán de forma permanente todos los postulantes, documentos cargados y logs registrados. ¡Esta acción no se puede deshacer!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#dc3545',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Sí, vaciar tablas',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = "configuracion.jsp?accion=limpiarTablas";
                    }
                });
            }
        </script>
    </body>
</html>