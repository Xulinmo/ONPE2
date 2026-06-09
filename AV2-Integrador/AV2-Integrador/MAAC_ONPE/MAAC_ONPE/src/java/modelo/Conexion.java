package modelo;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    // Configuración para XAMPP en el puerto 3307
    private static final String URL = "jdbc:mysql://localhost:3307/onpe_maac";
    private static final String USER = "root";
    private static final String PASSWORD = ""; 

    public static Connection conectar() {
        Connection cn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Error en la conexión: " + e.getMessage());
        }
        return cn;
    }
    public static void main(String[] args) {
    Connection prueba = Conexion.conectar();
    if (prueba != null) {
        System.out.println("¡Conexión exitosa al sistema MAACC!");
    } else {
        System.out.println("Error: No se pudo establecer la conexión.");
    }
}
}

