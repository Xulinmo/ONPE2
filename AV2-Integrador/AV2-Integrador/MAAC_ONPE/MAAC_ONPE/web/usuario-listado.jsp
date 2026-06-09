<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.UsuarioDAO" %>
<%@ page import="java.util.List" %>
<%
    Usuario admin = (Usuario) session.getAttribute("usuario");
    if (admin == null) { response.sendRedirect("login.jsp"); return; }
    
    UsuarioDAO dao = new UsuarioDAO();
    List<Usuario> lista = dao.listarUsuarios(); 
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Administración de Personal - ONPE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="Diseno/fondo.css">
</head>
<body>
    <div class="main p-4">
        <header class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="fw-bold m-0">Administración de Usuarios</h4>
                <small class="text-secondary">Control de personal y bloqueo de accesos</small>
            </div>
            <a href="usuarios.jsp" class="btn btn-outline-secondary btn-sm">Volver al Panel</a>
        </header>

        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Personal</th>
                            <th>ID Acceso</th>
                            <th>Correo</th>
                            <th>Rol</th>
                            <th>Acciones de Administración</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Usuario u : lista) { %>
                        <tr>
                            <td>
                                <div class="fw-bold"><%= u.getNombres() %></div>
                            </td>
                            <td><code><%= u.getNombreUsuario() %></code></td>
                            <td><%= u.getCorreo() %></td>
                            <td>
                                <span class="badge <%= u.getIdRol() == 1 ? "bg-primary" : "bg-info" %>">
                                    <%= u.getIdRol() == 1 ? "Administrador" : "Analista RRHH" %>
                                </span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-outline-warning" title="Bloquear Acceso">
                                    <i class="fa-solid fa-ban"></i> Bloquear
                                </button>
                                <button class="btn btn-sm btn-outline-danger" title="Eliminar">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>