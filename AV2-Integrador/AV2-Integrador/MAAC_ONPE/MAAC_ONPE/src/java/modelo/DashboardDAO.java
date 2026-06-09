package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {

    // Método para obtener el conteo total de postulantes
    public int contarTotalPostulantes() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM postulante";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    // Método para obtener los últimos movimientos del historial (CUS-25)
    public List<String[]> obtenerActividadReciente() {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT accion, fecha, hora FROM historial ORDER BY fecha DESC, hora DESC LIMIT 5";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new String[]{rs.getString("accion"), rs.getString("fecha"), rs.getString("hora")});
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public String obtenerDatosGrafico(String tipo) {
        // Retornará algo como "31, 39, 28, 45, 50" para JS
        StringBuilder datos = new StringBuilder();
        // Filtramos por observación (aprobado/desaprobado) y mes (2026)
        String sql = "SELECT COUNT(*) FROM evaluacion WHERE observacion LIKE ? "
                + "AND YEAR(fecha_eval) = 2026 GROUP BY MONTH(fecha_eval)";

        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, "%" + tipo + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                datos.append(rs.getInt(1)).append(",");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return datos.length() > 0 ? datos.substring(0, datos.length() - 1) : "0,0,0,0,0";
    }
    
    public boolean registrarAccion(int idUsuario, String accion) {
    String sql = "INSERT INTO historial (id_usuario, accion, fecha, hora) VALUES (?, ?, CURDATE(), CURTIME())";
    try (Connection cn = Conexion.conectar();
         PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setInt(1, idUsuario);
        ps.setString(2, accion);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
    
    // Método actualizado para contar según la columna de texto 'estado' en la tabla postulante
    public int contarPorEstado(String estado) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM postulante WHERE estado = ?";
        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setString(1, estado);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return total;
    }
}
