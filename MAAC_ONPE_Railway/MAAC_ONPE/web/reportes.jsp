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
        <title>Reportes - ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
        <style>
            .report-card {
                background: white;
                border: none;
                border-radius: 15px;
                transition: transform 0.2s, box-shadow 0.2s;
                cursor: pointer;
                text-decoration: none;
                color: inherit;
                height: 100%;
            }
            .report-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
            }
            .icon-box {
                width: 60px;
                height: 60px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 20px;
            }
            .bg-report { background-color: #ffebee; color: #ef5350; }
            .bg-stats { background-color: #fce4ec; color: #ec407a; }
            .bg-history { background-color: #fff3e0; color: #ffa726; }
            .card-title { font-weight: 700; font-size: 1.25rem; margin-bottom: 10px; }
            .card-text { color: #6c757d; font-size: 0.95rem; line-height: 1.5; }
        </style>
    </head>
    <body class="bg-light">
        <aside class="sidebar">
            <div class="logo"><h3>ONPE</h3></div>
            <div class="sidebar-menu">
                <a href="inicio.jsp" class="menu-btn"><i class="fa-solid fa-house"></i> Inicio</a>
                <a href="postulaciones.jsp" class="menu-btn"><i class="fa-solid fa-users"></i> Postulaciones</a>
                <a href="evaluaciones.jsp" class="menu-btn"><i class="fa-solid fa-clipboard-check"></i> Evaluaciones</a>
                <a href="documentos.jsp" class="menu-btn"><i class="fa-solid fa-file-lines"></i> Documentos</a>
                <a href="reportes.jsp" class="menu-btn active"><i class="fa-solid fa-chart-column"></i> Reportes</a>
                <% if (user != null && user.getIdRol() == 1) { %>
                <a href="usuarios.jsp" class="menu-btn"><i class="fa-solid fa-user-group"></i> Usuarios</a>
                <% } %>
            </div>
            <a href="LogoutServlet" class="logout" style="text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión</a>
        </aside>

        <div class="main">
            <header class="header navbar navbar-expand-lg bg-white shadow-sm px-4">
                <div>
                    <h4 class="fw-bold m-0">Módulo de Reportes Avanzados</h4>
                    <small class="text-secondary">Sistema de Gestión de Postulaciones</small>
                </div>
            </header>

            <div class="content p-5">
                <!-- TARJETAS DE NAVEGACIÓN ORIGINALES -->
                <div class="row g-4">
                    <div class="col-md-4">
                        <a href="GenerarReporteServlet?tipo=general" class="card report-card shadow-sm">
                            <div class="card-body p-4">
                                <div class="icon-box bg-report"><i class="fa-solid fa-table-cells fa-xl"></i></div>
                                <h5 class="card-title">Reportes Generales</h5>
                                <p class="card-text">Visualiza y exporta la lista completa de postulantes registrados en formatos PDF.</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="#seccion_analisis" class="card report-card shadow-sm">
                            <div class="card-body p-4">
                                <div class="icon-box bg-stats"><i class="fa-solid fa-chart-pie fa-xl"></i></div>
                                <h5 class="card-title">Estadísticas Avanzadas</h5>
                                <p class="card-text">Análisis predictivo, tendencias del cronograma y comparativa de procesos.</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="historial-reportes.jsp" class="card report-card shadow-sm">
                            <div class="card-body p-4">
                                <div class="icon-box bg-history"><i class="fa-solid fa-clock-rotate-left fa-xl"></i></div>
                                <h5 class="card-title">Historial</h5>
                                <p class="card-text">Registro detallado de todos los reportes generados y descargas.</p>
                            </div>
                        </a>
                    </div>
                </div>

                <!-- SECCIÓN DE GRÁFICOS (RF-41 y RF-42) -->
                <div class="row g-4 mt-4" id="seccion_analisis">
                    <div class="col-xl-6">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-header bg-white pt-4 pb-2 border-0">
                                <h5 class="fw-bold m-0 text-dark"><i class="fa-solid fa-chart-line text-danger me-2"></i> Evolución de Postulantes (RF-41)</h5>
                                <small class="text-secondary">Tendencia de expedientes en los últimos 30 días del cronograma electoral.</small>
                            </div>
                            <div class="card-body p-4"><canvas id="lineChartEvolucion" height="160"></canvas></div>
                        </div>
                    </div>

                    <div class="col-xl-6">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-header bg-white pt-4 pb-2 border-0">
                                <h5 class="fw-bold m-0 text-dark"><i class="fa-solid fa-code-compare text-danger me-2"></i> Comparación de Procesos (RF-42)</h5>
                                <small class="text-secondary">Compare el rendimiento y efectividad de diferentes procesos electorales.</small>
                            </div>
                            <div class="card-body p-4">
                                <div class="row g-2 mb-2">
                                    <div class="col-6">
                                        <select class="form-select form-select-sm" id="procesoA">
                                            <option value="EG2026">Elecciones Generales 2026</option>
                                        </select>
                                    </div>
                                    <div class="col-6">
                                        <select class="form-select form-select-sm" id="procesoB">
                                            <option value="">-- Seleccione Proceso --</option>
                                            <option value="ER2024">Elecciones Regionales 2024</option>
                                            <option value="EM2026">Elecciones Municipales 2026 (Sin Datos)</option>
                                        </select>
                                    </div>
                                    <div class="col-12"><button class="btn btn-dark btn-sm w-100 fw-bold mt-1" onclick="ejecutarComparativaProcesos()"><i class="fa-solid fa-magnifying-glass-chart"></i> Generar Métricas</button></div>
                                </div>
                                <div class="alert alert-warning d-none py-1 px-2 small" id="advertenciaE1"><i class="fa-solid fa-triangle-exclamation me-1"></i> <strong>Excepción E1:</strong> Datos históricos insuficientes.</div>
                                <div id="panelResultadosRF42" class="d-none"><canvas id="barChartRF42" height="90"></canvas></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ==================================================================== -->
                <!-- NUEVA SECCIÓN: EXPORTACIÓN DE REPORTES PERSONALIZADOS (RF-43)        -->
                <!-- ==================================================================== -->
                <div class="row mt-5">
                    <div class="col-12">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-white pt-4 pb-2 border-0 d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="fw-bold m-0 text-dark">
                                        <i class="fa-solid fa-file-excel text-success me-2"></i> Exportación de Reportes Personalizados (RF-43)
                                    </h5>
                                    <small class="text-secondary">Estructure su reporte seleccionando los criterios de filtrado y las columnas de interés requeridas.</small>
                                </div>
                                <!-- SWITCH PARA CONTROLAR LA EXCEPCIÓN E1 EN TU CAPTURA -->
                                <div class="form-check form-switch bg-light border p-2 rounded px-4">
                                    <input class="form-check-input" type="checkbox" id="forzarErrorE1">
                                    <label class="form-check-label small fw-bold text-danger" for="forzarErrorE1">Simular Falla del Servidor (E1)</label>
                                </div>
                            </div>
                            
                            <div class="card-body p-4 pt-2">
                                <form id="formExportarPersonalizado" onsubmit="procesarExportacionRF43(event)">
                                    <div class="row g-4">
                                        <!-- CRITERIOS DE FILTRADO -->
                                        <div class="col-md-4 border-end">
                                            <h6 class="fw-bold text-secondary mb-3"><i class="fa-solid fa-filter me-1"></i> 1. Criterios de Filtrado</h6>
                                            <div class="mb-2">
                                                <label class="form-label small m-0 text-muted">Cargo a incluir</label>
                                                <select class="form-select form-select-sm" name="filter_cargo">
                                                    <option value="TODOS">-- Todos los Cargos --</option>
                                                    <option value="Coordinador">Coordinador de Local</option>
                                                    <option value="Supervisor">Supervisor de ODPE</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="form-label small m-0 text-muted">Estado actual</label>
                                                <select class="form-select form-select-sm" name="filter_estado">
                                                    <option value="TODOS">-- Todos los Estados --</option>
                                                    <option value="Aprobado">Aprobado</option>
                                                    <option value="Pendiente">Pendiente</option>
                                                </select>
                                            </div>
                                        </div>

                                        <!-- PASO 1 DEL REQUERIMIENTO: SELECCIÓN DE COLUMNAS DE INTERÉS -->
                                        <div class="col-md-8">
                                            <h6 class="fw-bold text-secondary mb-3"><i class="fa-solid fa-table-columns me-1"></i> 2. Seleccione Columnas de Interés para el Archivo Estructurado</h6>
                                            <div class="row g-3">
                                                <div class="col-sm-4">
                                                    <div class="form-check p-2 border rounded bg-white">
                                                        <input class="form-check-input ms-1 me-2" type="checkbox" value="DNI" id="colDni" checked>
                                                        <label class="form-check-label small fw-bold" for="colDni">Número de DNI</label>
                                                    </div>
                                                </div>
                                                <div class="col-sm-4">
                                                    <div class="form-check p-2 border rounded bg-white">
                                                        <input class="form-check-input ms-1 me-2" type="checkbox" value="Nombres" id="colNom" checked>
                                                        <label class="form-check-label small fw-bold" for="colNom">Nombres y Apellidos</label>
                                                    </div>
                                                </div>
                                                <div class="col-sm-4">
                                                    <div class="form-check p-2 border rounded bg-white">
                                                        <input class="form-check-input ms-1 me-2" type="checkbox" value="Contacto" id="colCont">
                                                        <label class="form-check-label small fw-bold" for="colCont">Correo y Teléfono</label>
                                                    </div>
                                                </div>
                                                <div class="col-sm-4">
                                                    <div class="form-check p-2 border rounded bg-white">
                                                        <input class="form-check-input ms-1 me-2" type="checkbox" value="Cargo" id="colCar" checked>
                                                        <label class="form-check-label small fw-bold" for="colCar">Cargo Postulado</label>
                                                    </div>
                                                </div>
                                                <div class="col-sm-4">
                                                    <div class="form-check p-2 border rounded bg-white">
                                                        <input class="form-check-input ms-1 me-2" type="checkbox" value="Estado" id="colEst" checked>
                                                        <label class="form-check-label small fw-bold" for="colEst">Estado del Proceso</label>
                                                    </div>
                                                </div>
                                                <div class="col-sm-4">
                                                    <div class="form-check p-2 border rounded bg-white">
                                                        <input class="form-check-input ms-1 me-2" type="checkbox" value="Fecha" id="colFec">
                                                        <label class="form-check-label small fw-bold" for="colFec">Fecha de Registro</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- PASO 2 DEL REQUERIMIENTO: BOTÓN DE ACCIÓN -->
                                    <div class="d-flex justify-content-end mt-4 pt-3 border-top">
                                        <button type="submit" class="btn btn-success fw-bold px-4 shadow-sm">
                                            <i class="fa-solid fa-file-arrow-down me-2"></i> Exportar Personalizado (.xlsx)
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- ==================================================================== -->

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        
        <script>
            // --- GRÁFICOS PREVIOS (RF-41 y RF-42) ---
            const ctxLine = document.getElementById('lineChartEvolucion').getContext('2d');
            new Chart(ctxLine, { type: 'line', data: { labels: ['15 May', '25 May', '05 Jun', 'Hoy'], datasets: [{ label: 'Expedientes', data: [15, 34, 52, 85], borderColor: '#dc3545', backgroundColor: 'rgba(220, 53, 69, 0.05)', borderWidth: 3, fill: true }] } });

            let chartComparativo = null;
            function ejecutarComparativaProcesos() {
                const procB = document.getElementById('procesoB').value;
                const adv = document.getElementById('advertenciaE1');
                const res = document.getElementById('panelResultadosRF42');
                if (!procB || procB === 'EM2026') { res.classList.add('d-none'); adv.classList.remove('d-none'); return; }
                adv.classList.add('d-none'); res.classList.remove('d-none');
                const ctxBar = document.getElementById('barChartRF42').getContext('2d');
                if (chartComparativo) chartComparativo.destroy();
                chartComparativo = new Chart(ctxBar, { type: 'bar', data: { labels: ['Evaluados', 'Aprobados'], datasets: [{ label: 'EG 2026', data: [150, 95], backgroundColor: '#002e6d' }, { label: 'ER 2024', data: [120, 68], backgroundColor: '#dc3545' }] } });
            }

            // ====================================================================
            // LÓGICA DE CONTROL DE EXPORTACIÓN PERSONALIZADA (RF-43)
            // ====================================================================
            function procesarExportacionRF43(event) {
                event.preventDefault();
                
                const simularFalla = document.getElementById('forzarErrorE1').checked;

                // ESCENARIO EXCEPCIÓN E1: ERROR EN EXPORTACIÓN CON REINTENTO
                if (simularFalla) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error de Exportación (E1)',
                        text: 'No se pudo estructurar el archivo Excel debido a un error de respuesta en la base de datos centralizada de la ONPE.',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: '<i class="fa-solid fa-rotate-right"></i> Reintentar operación',
                        cancelButtonText: 'Cancelar'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // Si presiona reintentar, apagamos el switch de error y relanzamos el proceso de éxito
                            document.getElementById('forzarErrorE1').checked = false;
                            procesarExportacionRF43(event);
                        }
                    });
                    return;
                }

                // ESCENARIO ÉXITO (PASO 3): GENERACIÓN Y DESCARGA DEL EXCEL ESTRUCTURADO
                Swal.fire({
                    title: 'Generando Reporte...',
                    text: 'Estructurando columnas y compilando base de datos filtrada.',
                    allowOutsideClick: false,
                    didOpen: () => { Swal.showLoading(); }
                });

                setTimeout(() => {
                    Swal.close();
                    
                    // Simulación formal de descarga física de un archivo Excel desde el navegador
                    const blob = new Blob(["ID_CONEXION,DNI,NOMBRES,CARGO,ESTADO\n01,00000000,MOCK DATA,CONTRATADO"], { type: "application/vnd.ms-excel" });
                    const link = document.createElement("a");
                    link.href = window.URL.createObjectURL(blob);
                    link.download = "Reporte_Personalizado_ONPE.xls";
                    link.click();

                    Swal.fire({
                        icon: 'success',
                        title: '¡Reporte Generado!',
                        text: 'El archivo Excel estructurado con las columnas de interés se ha descargado de forma automática.',
                        confirmButtonColor: '#198754'
                    });
                }, 1500);
            }
        </script>
    </body>
</html>