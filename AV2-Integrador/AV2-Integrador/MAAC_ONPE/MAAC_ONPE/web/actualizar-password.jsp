<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Actualizar Contraseña - ONPE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="Diseno/fondo.css">
</head>
<body class="bg-light d-flex align-items-center vh-100">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card border-0 shadow-lg">
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <h3 class="fw-bold text-danger">ONPE</h3>
                            <h5 class="text-secondary">Establecer Nueva Contraseña</h5>
                            <p class="small text-muted">Requerimiento 2 - Vista 2 (CUS-02)</p>
                        </div>

                        <form action="ActualizarPasswordServlet" method="POST" class="needs-validation" novalidate>
                            <input type="hidden" name="idUsuario" value="<%= request.getParameter("id") %>">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nueva Contraseña</label>
                                <input type="password" name="nuevaClave" class="form-control" placeholder="Mínimo 6 caracteres" required minlength="6">
                                <div class="invalid-feedback">La contraseña debe tener al menos 6 caracteres.</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Confirmar Contraseña</label>
                                <input type="password" class="form-control" placeholder="Repita su contraseña" required>
                                <div class="invalid-feedback">Las contraseñas deben coincidir.</div>
                            </div>

                            <button type="submit" class="btn btn-danger w-100 py-2 fw-bold">
                                Guardar Cambios
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>