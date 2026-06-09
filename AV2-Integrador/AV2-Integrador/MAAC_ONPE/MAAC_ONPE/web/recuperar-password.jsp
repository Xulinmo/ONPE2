<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Recuperar Contraseña - ONPE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="Diseno/fondo.css"> </head>
<body class="bg-light d-flex align-items-center vh-100">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card border-0 shadow-lg">
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <h3 class="fw-bold text-danger">ONPE</h3>
                            <h5 class="text-secondary">Recuperar Contraseña</h5>
                            <p class="small text-muted">Ingresa tu correo para recibir las instrucciones.</p>
                        </div>

                        <form action="RecuperarPasswordServlet" method="POST" class="needs-validation" novalidate>
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Correo Electrónico</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-secondary">
                                        <i class="fa-solid fa-envelope"></i>
                                    </span>
                                    <input type="email" name="correo" class="form-control border-start-0" 
                                           placeholder="ejemplo@onpe.gob.pe" required>
                                    <div class="invalid-feedback">Por favor, ingrese un correo válido.</div>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-danger w-100 py-2 fw-bold shadow-sm">
                                Enviar Solicitud
                            </button>
                            
                            <div class="text-center mt-4">
                                <a href="login.jsp" class="text-decoration-none small text-secondary">
                                    <i class="fa-solid fa-arrow-left"></i> Volver al Login
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
    const urlParams = new URLSearchParams(window.location.search);
    
    if (urlParams.get('status') === 'enviado') {
        Swal.fire({
            icon: 'success',
            title: 'Solicitud Enviada',
            text: 'Se ha validado tu correo. Presiona aceptar para establecer tu nueva contraseña.',
            confirmButtonColor: '#198754',
            confirmButtonText: 'Aceptar'
        }).then((result) => {
            if (result.isConfirmed) {
                // SIMULACIÓN: Redirigimos a la Vista 2 pasando el ID del usuario (ejemplo: id=1)
                window.location.href = "actualizar-password.jsp?id=1";
            }
        });
    } else if (urlParams.get('status') === 'no_existe') {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'El correo electrónico no se encuentra registrado en el sistema MAACC.',
            confirmButtonColor: '#d33'
        });
    }
</script>
</body>
</html>