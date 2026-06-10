<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Acceso Restringido - ONPE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-light d-flex align-items-center vh-100">
    <div class="container text-center">
        <div class="display-1 text-danger"><i class="fa-solid fa-shield-halved"></i></div>
        <h1 class="fw-bold">Acceso Denegado</h1>
        <p class="lead text-secondary">No tienes los permisos necesarios para ver esta sección.</p>
        <hr class="my-4" style="max-width: 400px; margin: auto;">
        <p class="small">Este incidente será registrado en la bitácora de seguridad.</p>
        <a href="inicio.jsp" class="btn btn-danger px-4 py-2 mt-3 shadow-sm">
            Volver al Inicio Seguro
        </a>
    </div>
</body>
</html>
