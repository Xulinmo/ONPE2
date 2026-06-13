<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.postulante" %>
<%@ page import="modelo.PostulanteDAO" %>
<%
    // Seguridad
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Obtener datos del postulante a editar
    int id = Integer.parseInt(request.getParameter("id"));
    PostulanteDAO dao = new PostulanteDAO();
    postulante p = dao.obtenerPorId(id);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Editar Postulante - ONPE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="Diseno/fondo.css">
    </head>
    <body class="bg-light">
        <div class="container mt-5" style="max-width: 800px;">
            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold m-0 text-danger"><i class="fa-solid fa-pen-to-square"></i> Editar Datos del Postulante</h4>
                        <a href="postulacion-listado.jsp" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left"></i> Volver</a>
                    </div>

                    <form action="ActualizarDatosServlet" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="<%= p.getIdPostulante()%>">

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Nombres</label>
                                <input type="text" name="nombres" class="form-control" value="<%= p.getNombres() != null ? p.getNombres() : ""%>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Apellidos</label>
                                <input type="text" name="apellidos" class="form-control" value="<%= p.getApellidos() != null ? p.getApellidos() : ""%>" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">DNI</label>
                                <input type="text" name="dni" class="form-control" value="<%= p.getDni() != null ? p.getDni() : ""%>" maxlength="8" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Teléfono</label>
                                <input type="text" name="telefono" class="form-control" value="<%= p.getTelefono() != null ? p.getTelefono() : ""%>">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Correo</label>
                                <input type="email" name="correo" class="form-control" value="<%= p.getCorreo() != null ? p.getCorreo() : ""%>">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Cargo Postulado</label>
                                <select name="cargo" class="form-select">
                                    <option value="Coordinador" <%= "Coordinador".equals(p.getCargo()) ? "selected" : ""%>>Coordinador</option>
                                    <option value="Supervisor" <%= "Supervisor".equals(p.getCargo()) ? "selected" : ""%>>Supervisor</option>
                                    <option value="Operador" <%= "Operador".equals(p.getCargo()) ? "selected" : ""%>>Operador</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Modalidad</label>
                                <select name="modalidad" class="form-select">
                                    <option value="Presencial" <%= "Presencial".equals(p.getModalidad()) ? "selected" : ""%>>Presencial</option>
                                    <option value="Remoto" <%= "Remoto".equals(p.getModalidad()) ? "selected" : ""%>>Remoto</option>
                                    <option value="Híbrido" <%= "Híbrido".equals(p.getModalidad()) ? "selected" : ""%>>Híbrido</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-bold">Dirección</label>
                                <input type="text" name="direccion" class="form-control" value="<%= p.getDireccion() != null ? p.getDireccion() : ""%>">
                            </div>

                            <div class="row g-3 mt-3">
                                <div class="col-12">
                                    <label class="form-label fw-bold">Actualizar o Subir CV (PDF)</label>
                                    <input type="file" name="archivo_cv" class="form-control" accept=".pdf">
                                    <% if (p.getRutaCv() != null && !p.getRutaCv().isEmpty()) { %>
                                    <div class="form-text text-success">
                                        <i class="fa-solid fa-file-pdf"></i> Ya existe un archivo cargado.
                                    </div>
                                    <% } else { %>
                                    <div class="form-text text-danger">
                                        <i class="fa-solid fa-circle-exclamation"></i> Este postulante aún no tiene un CV subido.
                                    </div>
                                    <% }%>
                                </div>
                            </div>

                            <div class="col-12 mt-4 text-end">
                                <button type="submit" class="btn btn-danger px-4 fw-bold">Guardar Cambios</button>
                            </div>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </body>
</html>