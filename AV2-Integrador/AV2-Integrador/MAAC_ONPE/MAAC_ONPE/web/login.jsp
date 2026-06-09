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
                box-sizing: border-box; /* Para que el padding no deforme el input */
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
            .error {
                color: var(--rojo-onpe);
                font-weight: bold;
                font-size: 14px;
                margin-bottom: 10px;
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
                padding-right: 40px; /* Deja espacio para que el texto no pise el ojito */
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

            <% if (request.getParameter("error") != null) { %>
            <p class="error">Usuario o contraseña incorrectos</p>
            <% }%>

            <form action="LoginServlet" method="POST">
                <input type="text" name="txtUser" placeholder="Usuario" required>

                <div class="password-container">
                    <input type="password" name="txtPass" id="txtPass" placeholder="Contraseña" required>
                    <button type="button" id="togglePassword">
                        <i class="fa-solid fa-eye"></i>
                    </button>
                </div>

                <a href="recuperar-password.jsp" class="forgot-link">
                    ¿Olvidaste tu contraseña?
                </a>

                <button type="submit">Ingresar al Sistema</button>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            const urlParams = new URLSearchParams(window.location.search);

            // Alerta de Cierre de Sesión (CUS-01)
            if (urlParams.get('logout') === 'true') {
                Swal.fire({
                    icon: 'info',
                    title: 'Sesión Finalizada',
                    text: 'Has salido del sistema de la ONPE correctamente.',
                    confirmButtonColor: '#002e6d'
                }).then(() => {
                    window.history.replaceState(null, null, window.location.pathname);
                });
            }

            // Alerta de Cambio de Contraseña Exitoso (CUS-02)
            if (urlParams.get('update') === 'success') {
                Swal.fire({
                    icon: 'success',
                    title: '¡Clave Actualizada!',
                    text: 'Ya puedes ingresar con tu nueva contraseña.',
                    confirmButtonColor: '#198754'
                }).then(() => {
                    window.history.replaceState(null, null, window.location.pathname);
                });
            }
        </script>
        
        <script>
            const togglePassword = document.querySelector('#togglePassword');
            const password = document.querySelector('#txtPass');

            togglePassword.addEventListener('click', function () {
                // Alternar el tipo de input entre 'password' y 'text'
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);

                // Alternar el icono del ojito (abierto / cerrado)
                const icon = this.querySelector('i');
                icon.classList.toggle('fa-eye');
                icon.classList.toggle('fa-eye-slash');
            });
        </script>
    </body>
</html>