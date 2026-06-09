package controlador;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.Usuario; // <-- ¡IMPORTANTE! Necesario para leer el rol del usuario

// Este filtro vigila todas las páginas JSP
@WebFilter(filterName = "FiltroSesion", urlPatterns = {"*.jsp"})
public class FiltroSesion implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {
    
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String uri = req.getRequestURI();

        // 1. Definimos qué páginas son públicas (No necesitan login)
        boolean isLoginPage = uri.endsWith("login.jsp");
        boolean isLoginServlet = uri.endsWith("LoginServlet");
        
        // Excepciones para recuperación de contraseña
        boolean isRecuperarPage = uri.endsWith("recuperar-password.jsp");
        boolean isActualizarPage = uri.endsWith("actualizar-password.jsp");
        boolean isRecuperarServlet = uri.endsWith("RecuperarPasswordServlet");
        boolean isActualizarServlet = uri.endsWith("ActualizarPasswordServlet");
        
        boolean isResource = uri.contains("/Diseno/");

        // 2. Definimos las URIs restringidas (Solo Administrador)
        boolean isRutaAdmin = uri.endsWith("usuarios.jsp") || 
                              uri.endsWith("usuario-registro.jsp") || 
                              uri.endsWith("usuario-listado.jsp") || 
                              uri.endsWith("rol-gestion.jsp");

        // 3. Verificamos si el usuario ya inició sesión
        boolean loggedIn = (session != null && session.getAttribute("usuario") != null);
        Usuario usuarioActual = loggedIn ? (Usuario) session.getAttribute("usuario") : null;

        // 4. Lógica estricta de control de acceso (CUS-04)
        if (loggedIn) {
            // Si intenta entrar a una vista de Admin pero su rol NO es 1 (Administrador)
            if (isRutaAdmin && usuarioActual.getIdRol() != 1) {
                // Es un analista forzando la URL: ¡Acceso Denegado!
                res.sendRedirect(req.getContextPath() + "/acceso-denegado.jsp");
            } else {
                // Es Admin, o es un Analista en una página permitida (Ej. postulaciones)
                chain.doFilter(request, response);
            }
        } else if (isLoginPage || isLoginServlet || isRecuperarPage || 
                   isActualizarPage || isRecuperarServlet || isActualizarServlet || isResource) {
            // No está logueado, pero va a una página pública: APROBADO
            chain.doFilter(request, response);
        } else {
            // No está logueado y va a zona privada: AL LOGIN
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    public void init(FilterConfig filterConfig) {}
    public void destroy() {}
}
