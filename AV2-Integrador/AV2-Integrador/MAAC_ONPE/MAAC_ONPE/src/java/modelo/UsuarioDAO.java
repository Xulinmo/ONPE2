/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public Usuario validarAcceso(String user, String pass) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuario WHERE usuario = ? AND contraseña = ?";

        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, user);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombreUsuario(rs.getString("usuario"));
                usuario.setIdRol(rs.getInt("id_rol"));

                // Registrar en auditoría (CUS-05)
                registrarAuditoria(usuario.getIdUsuario(), "Inicio de sesión exitoso");
            }
        } catch (Exception e) {
            System.out.println("Error en Login: " + e.getMessage());
        }
        return usuario; // Si es null, el login falló
    }

    public Usuario buscarPorCorreo(String correo) {
        Usuario u = null;
        String sql = "SELECT * FROM usuario WHERE correo = ?";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setNombreUsuario(rs.getString("usuario")); // Cambiado para coincidir con el modelo
                u.setCorreo(rs.getString("correo")); // Recuperamos el nuevo campo
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }

    public boolean actualizarClave(int idUsuario, String nuevaClave) {
        String sql = "UPDATE usuario SET contraseña = ? WHERE id_usuario = ?";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, nuevaClave);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<HistorialPassword> listarHistorialPasswords() {
    List<HistorialPassword> lista = new ArrayList<>();
    String sql = "SELECT h.*, u.usuario FROM historial_password h " +
                 "JOIN usuario u ON h.id_usuario = u.id_usuario " +
                 "ORDER BY h.fecha_cambio DESC";
    try (Connection cn = Conexion.conectar();
         PreparedStatement ps = cn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            HistorialPassword hp = new HistorialPassword();
            hp.setIdHistorial(rs.getInt("id_historial"));
            hp.setNombreUsuario(rs.getString("usuario"));
            hp.setContraseñaAnterior(rs.getString("contraseña_anterior"));
            hp.setFechaCambio(rs.getTimestamp("fecha_cambio"));
            lista.add(hp);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return lista;
}

    // Cumpliendo con el CUS-05: Registro de accesos
    private void registrarAuditoria(int idUsuario, String accion) {
        String sql = "INSERT INTO auditoria (id_usuario, accion_realizada, fecha_auditoria) VALUES (?, ?, CURDATE())";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, accion);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al registrar auditoría: " + e.getMessage());
        }
    }
    
    public boolean registrarUsuario(Usuario u) {
    String sql = "INSERT INTO usuario (nombres, usuario, contraseña, correo, id_rol) VALUES (?, ?, ?, ?, ?)";
    try (Connection cn = Conexion.conectar();
         PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setString(1, u.getNombres()); // El campo que agregamos con el ALTER
        ps.setString(2, u.getNombreUsuario());
        ps.setString(3, u.getContraseña());
        ps.setString(4, u.getCorreo());
        ps.setInt(5, u.getIdRol());
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
    
    public List<Usuario> listarUsuarios() {
    List<Usuario> lista = new ArrayList<>();
    String sql = "SELECT * FROM usuario";
    try (Connection cn = Conexion.conectar();
         PreparedStatement ps = cn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Usuario u = new Usuario();
            u.setIdUsuario(rs.getInt("id_usuario"));
            u.setNombres(rs.getString("nombres"));
            u.setNombreUsuario(rs.getString("usuario"));
            u.setCorreo(rs.getString("correo"));
            u.setIdRol(rs.getInt("id_rol"));
            lista.add(u);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return lista;
}
    
    public boolean respaldarContraseñaAntigua(int idUsuario) {
    // 1. Buscamos la contraseña que tiene actualmente antes de borrarla
    String sqlSelect = "SELECT contraseña FROM usuario WHERE id_usuario = ?";
    String sqlInsert = "INSERT INTO historial_password (id_usuario, contraseña_anterior) VALUES (?, ?)";
    
    try (Connection cn = Conexion.conectar()) {
        // Obtener la actual
        String passAntigua = "";
        PreparedStatement ps1 = cn.prepareStatement(sqlSelect);
        ps1.setInt(1, idUsuario);
        ResultSet rs = ps1.executeQuery();
        if(rs.next()) passAntigua = rs.getString("contraseña");

        // Guardar en el historial específico
        PreparedStatement ps2 = cn.prepareStatement(sqlInsert);
        ps2.setInt(1, idUsuario);
        ps2.setString(2, passAntigua);
        return ps2.executeUpdate() > 0;
        
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
}
