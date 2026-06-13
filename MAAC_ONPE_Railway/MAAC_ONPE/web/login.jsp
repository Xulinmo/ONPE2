<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Login - MAACC ONPE</title>
        <link rel="stylesheet" href="Diseno/estilos.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            /* CSS extra solo para centrar el login */
            body {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background-color: #f8f9fa;
            }
            .login-box {
                background: white;
                padding: 40px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                border-top: 5px solid var(--rojo-onpe);
                text-align: center;
                width: 320px; 
            }
            .login-box input {
                width: 90%;
                padding: 10px;
                margin: 10px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box; 
            }
            .login-box button[type="submit"] {
                width: 100%;
                padding: 10px;
                background: var(--azul-onpe);
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
            }
            .forgot-link {
                display: block;
                text-align: right;
                margin-bottom: 15px;
                font-size: 13px;
                text-decoration: none;
                color: var(--rojo-onpe);
                font-weight: 600;
            }
            .forgot-link:hover {
                text-decoration: underline;
            }
            /* --- ESTILOS NUEVOS PARA EL OJITO --- */
            .password-container {
                position: relative;
                width: 90%;
                margin: 10px auto;
            }
            .password-container input {
                width: 100%;
                margin: 0;
                padding-right: 40px; 
            }
            #togglePassword {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                background: transparent;
                border: none;
                color: #555;
                cursor: pointer;
                padding: 0;
                width: auto;
            }
        </style>
    </head>
    <body>
        <div class="login-box">
            <h2 style="color: var(--azul-onpe); margin-bottom: 25px;">MAACC ONPE</h2>

            <form action="LoginServlet" method="POST">
                <input type="text" name="txtUser" placeholder="Usuario" required>

                <div class="password-container">
                    <input type="password" name="txtPass" id="txtPass" placeholder="Contraseña" required>
                    <button type="button" id="togglePassword">
                        <i class="fa-solid fa-eye"></i>
                    </button>
                </div>

                <a href="recuperar-password.jsp" class="forgot-link">¿Olvidaste tu contraseña?</a>

                <button type="submit">Ingresar al Sistema</button>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        
        <script>
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');
            const intentos = urlParams.get('intentos');

            // --- ALERTAS DE SEGURIDAD Y BLOQUEO ---

            if (error === 'credenciales') {
                Swal.fire({
                    icon: 'warning',
                    title: 'Credenciales Incorrectas',
                    text: 'Usuario o contraseña errónea. Intento fallido ' + intentos + ' de 3.',
                    confirmButtonColor: '#f39c12'
                }).then(() => { window.history.replaceState(null, null, window.location.pathname); });
            }

            if (error === 'max_intentos') {
                Swal.fire({
                    icon: 'error',
                    title: '¡CUENTA BLOQUEADA!',
                    text: 'Ha superado los 3 intentos fallidos permitidos. Por seguridad, el acceso ha sido bloqueado por 3 minutos.',
                    confirmButtonColor: '#d33'
                }).then(() => { window.history.replaceState(null, null, window.location.pathname); });
            }

            if (error === 'bloqueado_temp') {
                Swal.fire({
                    icon: 'error',
                    title: 'Acceso Restringido',
                    text: 'Esta cuenta se encuentra bloqueada temporalmente. Por favor, espere unos minutos antes de volver a intentar.',
                    confirmButtonColor: '#d33'
                }).then(() => { window.history.replaceState(null, null, window.location.pathname); });
            }

            // Fallback genérico (por si acaso envías error=1 desde otra parte)
            if (error === '1') {
                Swal.fire({
                    icon: 'error',
                    title: 'Error de Acceso',
                    text: 'Las credenciales ingresadas no son válidas.',
                    confirmButtonColor: '#d33'
                }).then(() => { window.history.replaceState(null, null, window.location.pathname); });
            }

            // --- ALERTAS DE SESIÓN ---
            
            if (urlParams.get('logout') === 'true') {
                Swal.fire({
                    icon: 'info',
                    title: 'Sesión Finalizada',
                    text: 'Has salido del sistema de la ONPE correctamente.',
                    confirmButtonColor: '#002e6d'
                }).then(() => { window.history.replaceState(null, null, window.location.pathname); });
            }

            if (urlParams.get('update') === 'success') {
                Swal.fire({
                    icon: 'success',
                    title: '¡Clave Actualizada!',
                    text: 'Ya puedes ingresar con tu nueva contraseña.',
                    confirmButtonColor: '#198754'
                }).then(() => { window.history.replaceState(null, null, window.location.pathname); });
            }
        </script>
        
        <script>
            // Lógica del ojito para la contraseña
            const togglePassword = document.querySelector('#togglePassword');
            const password = document.querySelector('#txtPass');

            togglePassword.addEventListener('click', function () {
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);
                const icon = this.querySelector('i');
                icon.classList.toggle('fa-eye');
                icon.classList.toggle('fa-eye-slash');
            });
        </script>
    </body>
</html>