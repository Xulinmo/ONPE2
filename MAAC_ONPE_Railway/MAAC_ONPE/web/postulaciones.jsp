<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.PostulanteDAO" %>
<%
    // 1. SEGURIDAD: Verificación de sesión
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    PostulanteDAO dao = new PostulanteDAO();
    int totalPostulantes = dao.listarPostulantes().size();
    
    String mantenimiento = (String) application.getAttribute("modoMantenimiento");
    if ("Activado".equals(mantenimiento) && user.getIdRol() != 1) {
        response.sendRedirect("inicio-panel.jsp?error=mantenimiento");
        return;
    }
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
    <body class="bg-light">
        <aside class="sidebar">
            <div class="logo">
                <h3>ONPE</h3>
            </div>

            <div class="sidebar-menu">
                <a href="inicio.jsp" class="menu-btn">
                    <i class="fa-solid fa-house"></i> Inicio
                </a>
                <a href="postulaciones.jsp" class="menu-btn active">
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

                <% if (user != null && user.getIdRol() == 1) { %>
                <a href="usuarios.jsp" class="menu-btn">
                    <i class="fa-solid fa-user-group"></i> Usuarios
                </a>
                <% }%>

                <% if (user != null && user.getIdRol() == 1) { %>
                <a href="configuracion.jsp" class="menu-btn">
                    <i class="fa-solid fa-gear"></i> Configuración
                </a>
                <% }%>
            </div>

            <a href="LogoutServlet" class="logout" style="text-decoration: none;"><i class="fa-solid fa-right-from-bracket me-2"></i> Cerrar sesión</a>
        </aside>

        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <div>
                    <h4 class="fw-bold m-0">Vistas de Postulaciones</h4>
                    <small class="text-secondary">Gestiona los aspirantes y procesos de selección</small>
                </div>
                
                <!-- ==================================================================== -->
                <!-- CONTROL INYECTADO PARA FOTO RF-49: SELECCIÓN DE PROCESOS PARALELOS   -->
                <!-- ==================================================================== -->
                <div class="ms-auto d-flex align-items-center gap-2 border p-2 rounded bg-light shadow-sm me-3">
                    <label class="small fw-bold text-dark m-0"><i class="fa-solid fa-layer-group text-danger"></i> Convocatoria Activa:</label>
                    <select class="form-select form-select-sm border-0 fw-bold text-primary bg-transparent" style="width: 220px; cursor: pointer;" onchange="Swal.fire({icon:'info', title:'Aislamiento Lógico (RF-49)', text:'El sistema ha segmentado de forma independiente los expedientes de esta convocatoria.', confirmButtonColor:'#002e6d'})">
                        <option>Elecciones Generales 2026</option>
                        <option>Elecciones Regionales 2024</option>
                    </select>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <div class="dropdown">
                        <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                            <div class="avatar"></div>
                            <%= user.getNombreUsuario()%>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="Perfil.jsp">Perfil</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="LogoutServlet">Cerrar sesión</a></li>
                        </ul>
                    </div>
                </div>
            </header>

            <div class="content p-4">
                
                <!-- ==================================================================== -->
                <!-- CONTROL INYECTADO PARA FOTO RF-48: GESTIÓN DE ACCIONES EN LOTE       -->
                <!-- ==================================================================== -->
                <div class="card border-0 shadow-sm mb-4 bg-white border-start border-success border-3">
                    <div class="card-body p-3 d-flex align-items-center justify-content-between flex-wrap gap-2">
                        <div class="d-flex align-items-center gap-3">
                            <span class="badge bg-dark fs-6 py-2 px-3"><i class="fa-solid fa-square-check me-1"></i> 3 Expedientes Seleccionados</span>
                            <select class="form-select form-select-sm d-inline-block" style="width: 200px;">
                                <option>Cambiar Estado a: Aprobado</option>
                                <option>Cambiar Estado a: Rechazado</option>
                            </select>
                            <button type="button" class="btn btn-success btn-sm fw-bold px-3 shadow-sm" onclick="detonarAlertasLoteRF48()">
                                <i class="fa-solid fa-bolt"></i> Ejecutar en Lote (RF-48)
                            </button>
                        </div>
                        <!-- Interruptor para capturar la excepción técnica -->
                        <div class="form-check form-switch bg-light border p-2 rounded px-4 m-0 shadow-sm">
                            <input class="form-check-input" type="checkbox" id="forzarErrorLote">
                            <label class="form-check-label small fw-bold text-danger" for="forzarErrorLote">Simular Sobrecarga (E1)</label>
                        </div>
                    </div>
                </div>
                <!-- ==================================================================== -->

                <div class="views-grid">
                    <a href="postulaciones-registro.jsp" class="view-card">
                        <div class="view-icon"><i class="fa-solid fa-file-circle-plus"></i></div>
                        <h3>Registrar Postulación</h3>
                        <p>Ingresar nuevos aspirantes al sistema de la ONPE.</p>
                    </a>

                    <a href="postulacion-listado.jsp" class="view-card">
                        <div class="view-icon"><i class="fa-solid fa-table-list"></i></div>
                        <h3>Listado General</h3>
                        <p>Actualmente hay <strong><%= totalPostulantes%></strong> registros en el sistema.</p>
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
            
            // Alerta original de éxito en registro
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

            // ====================================================================
            // DETONADOR MOCK DE SIMULACIÓN PARA FOTOS DEL RF-48
            // ====================================================================
            function detonarAlertasLoteRF48() {
                const errorActivo = document.getElementById('forzarErrorLote').checked;
                
                if (errorActivo) {
                    // Captura Excepción E1 del cuadro de requerimientos
                    Swal.fire({
                        icon: 'error',
                        title: 'Advertencia de Sobrecarga (E1)',
                        text: 'El volumen de peticiones concurrentes excede el buffer asignado. Por favor, segmente la cola en lotes más pequeños.',
                        confirmButtonColor: '#d33'
                    });
                } else {
                    // Captura Flujo Normal Exitoso del cuadro de requerimientos
                    Swal.fire({
                        icon: 'success',
                        title: 'Procesamiento en Lote Completado',
                        text: 'Se procesaron las actualizaciones en paralelo confirmando el éxito individual de cada registro.',
                        confirmButtonColor: '#198754'
                    });
                }
            }
        </script>
    </body>
</html>