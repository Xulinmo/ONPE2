package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class PostulanteDAO {

    // 1. MÉTODO ÚNICO PARA LISTAR POSTULANTES
    public List<postulante> listarPostulantes() {
        List<postulante> lista = new ArrayList<>();
        String sql = "SELECT * FROM postulante";

        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                postulante p = new postulante();
                p.setIdPostulante(rs.getInt("id_postulante"));
                p.setDni(rs.getString("dni"));
                p.setNombres(rs.getString("nombres"));
                p.setApellidos(rs.getString("apellidos"));
                p.setCorreo(rs.getString("correo"));
                p.setTelefono(rs.getString("telefono"));
                p.setCargo(rs.getString("cargo"));
                p.setModalidad(rs.getString("modalidad"));
                p.setDireccion(rs.getString("direccion"));
                p.setObservaciones(rs.getString("observaciones"));
                p.setRutaCv(rs.getString("ruta_cv"));
                p.setFechaRegistro(rs.getString("fecha_registro"));
                p.setEstado(rs.getString("estado"));

                lista.add(p);
            }
        } catch (Exception e) {
            System.out.println("Error al listar postulantes: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    // 2. MÉTODO PARA REGISTRAR NUEVO POSTULANTE
    // 2. MÉTODO PARA REGISTRAR NUEVO POSTULANTE (Actualizado con Estado)
    public boolean registrarPostulante(postulante p) {
        String sql = "INSERT INTO postulante (dni, nombres, apellidos, correo, telefono, cargo, modalidad, direccion, observaciones, ruta_cv, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, p.getDni());
            ps.setString(2, p.getNombres());
            ps.setString(3, p.getApellidos());
            ps.setString(4, p.getCorreo());
            ps.setString(5, p.getTelefono());
            ps.setString(6, p.getCargo());
            ps.setString(7, p.getModalidad());
            ps.setString(8, p.getDireccion());
            ps.setString(9, p.getObservaciones());
            ps.setString(10, p.getRutaCv());

            // Agregamos el estado que viene del formulario
            ps.setString(11, p.getEstado() != null ? p.getEstado() : "Pendiente");

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error al registrar: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // 3. MÉTODO PARA EL REQUERIMIENTO 5 (EVALUAR)
    public boolean actualizarEstado(int id, String nuevoEstado, String observaciones) {
        String sql = "UPDATE postulante SET estado = ?, observaciones = ? WHERE id_postulante = ?";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setString(2, observaciones);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. NUEVO MÉTODO NECESARIO PARA LA VISTA DE EVALUAR
    // Este método trae un solo postulante para mostrar sus datos en la pantalla de evaluación
    // 4. MÉTODO PARA TRAER TODOS LOS DATOS A LA VISTA DE EDITAR/EVALUAR
    public postulante obtenerPorId(int id) {
        postulante p = new postulante();
        String sql = "SELECT * FROM postulante WHERE id_postulante = ?";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p.setIdPostulante(rs.getInt("id_postulante"));
                    p.setDni(rs.getString("dni"));
                    p.setNombres(rs.getString("nombres"));
                    p.setApellidos(rs.getString("apellidos"));
                    p.setCorreo(rs.getString("correo"));
                    p.setTelefono(rs.getString("telefono"));
                    p.setCargo(rs.getString("cargo"));
                    p.setModalidad(rs.getString("modalidad"));
                    p.setDireccion(rs.getString("direccion"));
                    p.setEstado(rs.getString("estado"));
                    p.setObservaciones(rs.getString("observaciones"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }

    // 5. MÉTODO PARA EL BUSCADOR Y FILTROS (2 vistas en 1)
    public List<postulante> filtrarPostulantes(String buscar, String estado, String cargo) {
        List<postulante> lista = new ArrayList<>();
        // Empezamos con una consulta base que trae todo
        StringBuilder sql = new StringBuilder("SELECT * FROM postulante WHERE 1=1 ");

        // Si escribió algo en el buscador, lo añadimos al SQL
        if (buscar != null && !buscar.trim().isEmpty()) {
            sql.append(" AND (nombres LIKE ? OR apellidos LIKE ? OR dni LIKE ?) ");
        }
        // Si eligió un estado específico (diferente a "Todos")
        if (estado != null && !estado.equals("Todos")) {
            sql.append(" AND estado = ? ");
        }
        // Si eligió un cargo específico
        if (cargo != null && !cargo.equals("Todos")) {
            sql.append(" AND cargo = ? ");
        }

        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // Reemplazamos los "?" con los valores reales
            if (buscar != null && !buscar.trim().isEmpty()) {
                String parametroBusqueda = "%" + buscar + "%";
                ps.setString(paramIndex++, parametroBusqueda); // Para nombres
                ps.setString(paramIndex++, parametroBusqueda); // Para apellidos
                ps.setString(paramIndex++, parametroBusqueda); // Para dni
            }
            if (estado != null && !estado.equals("Todos")) {
                ps.setString(paramIndex++, estado);
            }
            if (cargo != null && !cargo.equals("Todos")) {
                ps.setString(paramIndex++, cargo);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    postulante p = new postulante();
                    p.setIdPostulante(rs.getInt("id_postulante"));
                    p.setDni(rs.getString("dni"));
                    p.setNombres(rs.getString("nombres"));
                    p.setApellidos(rs.getString("apellidos"));
                    p.setCargo(rs.getString("cargo"));
                    p.setFechaRegistro(rs.getString("fecha_registro"));
                    p.setEstado(rs.getString("estado"));
                    lista.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // MÉTODO PARA EDITAR DATOS DEL POSTULANTE
    public boolean actualizarDatos(postulante p) {
        String sql = "UPDATE postulante SET dni=?, nombres=?, apellidos=?, correo=?, telefono=?, cargo=?, modalidad=?, direccion=? WHERE id_postulante=?";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, p.getDni());
            ps.setString(2, p.getNombres());
            ps.setString(3, p.getApellidos());
            ps.setString(4, p.getCorreo());
            ps.setString(5, p.getTelefono());
            ps.setString(6, p.getCargo());
            ps.setString(7, p.getModalidad());
            ps.setString(8, p.getDireccion());
            ps.setInt(9, p.getIdPostulante());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // MÉTODO PARA ELIMINAR POSTULANTE
    public boolean eliminar(int id) {
        String sql = "DELETE FROM postulante WHERE id_postulante = ?";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0; // Esto garantiza que solo devuelva TRUE si realmente se borró algo
        } catch (Exception e) {
            e.printStackTrace(); // Esto te mostrará el error real en la consola de NetBeans
            return false;
        }
    }

    public boolean registrarConHistorial(postulante p) {
        // 1. Primero registramos al postulante (tu método de siempre)
        boolean ok = registrarPostulante(p);

        if (ok) {
            try (Connection cn = Conexion.conectar()) {
                // 2. Lógica para Requerimiento 13: Registro de carga
                String sqlCarga = "INSERT INTO carga_documento (id_documento, fecha, hora) VALUES (?, CURRENT_DATE, CURRENT_TIME)";
                // (Aquí usarías el ID del postulante recién creado)

                // 3. Lógica para Historial de carga
                String sqlHistorial = "INSERT INTO historial_carga (id_documento, fecha, usuario_responsable) VALUES (?, CURRENT_DATE, ?)";

                // Nota: Para estas tablas necesitas los IDs que definieron tus amigos
                return true;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return ok;
    }

    public boolean registrarConAuditoria(postulante p, String usuarioRegistro, String nombreArchivo) {
        Connection cn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        ResultSet rs = null;
        boolean exito = false;

        try {
            cn = Conexion.conectar();
            cn.setAutoCommit(false); // Iniciamos transacción para seguridad

            // PASO A: Insertar los datos personales en la tabla 'postulante'
            // Asegúrate de que el SQL sea idéntico a este:
            String sqlPost = "INSERT INTO postulante (dni, nombres, apellidos, correo, telefono, modalidad, direccion, cargo, estado, usuario_registro) VALUES (?,?,?,?,?,?,?,?,?,?)";
            ps1 = cn.prepareStatement(sqlPost, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, p.getDni());
            ps1.setString(2, p.getNombres());
            ps1.setString(3, p.getApellidos());
            ps1.setString(4, p.getCorreo());
            ps1.setString(5, p.getTelefono());
            ps1.setString(6, p.getModalidad());
            ps1.setString(7, p.getDireccion());
            ps1.setString(8, p.getCargo());
            ps1.setString(9, p.getEstado());
            ps1.setString(10, usuarioRegistro);
            ps1.executeUpdate();

            // Obtenemos el ID generado para el postulante
            rs = ps1.getGeneratedKeys();
            if (rs.next()) {
                int idGenerado = rs.getInt(1);

                // PASO B: Insertar el archivo en 'carga_documento' usando las columnas nuevas
                String sqlDoc = "INSERT INTO carga_documento (id_postulante, tipo_documento, nombre_archivo, ruta_archivo, estado) VALUES (?, 'Currículum Vitae', ?, ?, 'Pendiente')";
                ps2 = cn.prepareStatement(sqlDoc);
                ps2.setInt(1, idGenerado);
                ps2.setString(2, nombreArchivo); // El parámetro nuevo que daba error
                ps2.setString(3, p.getRutaCv());
                ps2.executeUpdate();

                cn.commit(); // Guardamos todo
                exito = true;
            }
        } catch (Exception e) {
            if (cn != null) try {
                cn.rollback();
            } catch (Exception ex) {
            }
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
            }
        }
        return exito;
    }

    // ==========================================
    // MÉTODOS PARA EL DASHBOARD ESTADÍSTICO
    // ==========================================
    // 1. Contar el total de postulantes registrados
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

    // 2. Contar postulantes según su estado (Pendiente, Aprobado, Rechazado)
    public int contarPorEstado(String estado) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM postulante WHERE estado = ?";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
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

    // 3. Contar alertas (Postulantes que tienen alguna observación escrita)
    public int contarAlertas() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM postulante WHERE observaciones IS NOT NULL AND observaciones != ''";
        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public boolean actualizarConArchivo(postulante p) {
        String sql;
        // Si p.getRutaCv() es null, no tocamos la columna del CV en la BD
        if (p.getRutaCv() != null) {
            sql = "UPDATE postulante SET dni=?, nombres=?, apellidos=?, correo=?, telefono=?, cargo=?, modalidad=?, direccion=?, ruta_cv=? WHERE id_postulante=?";
        } else {
            sql = "UPDATE postulante SET dni=?, nombres=?, apellidos=?, correo=?, telefono=?, cargo=?, modalidad=?, direccion=? WHERE id_postulante=?";
        }

        try (Connection cn = Conexion.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, p.getDni());
            ps.setString(2, p.getNombres());
            ps.setString(3, p.getApellidos());
            ps.setString(4, p.getCorreo());
            ps.setString(5, p.getTelefono());
            ps.setString(6, p.getCargo());
            ps.setString(7, p.getModalidad());
            ps.setString(8, p.getDireccion());

            if (p.getRutaCv() != null) {
                ps.setString(9, p.getRutaCv());
                ps.setInt(10, p.getIdPostulante());
            } else {
                ps.setInt(9, p.getIdPostulante());
            }

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
