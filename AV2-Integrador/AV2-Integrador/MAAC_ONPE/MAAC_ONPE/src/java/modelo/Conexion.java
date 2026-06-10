package modelo;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    // Lee las variables de entorno que Railway provee automáticamente.
    // Si no existen (ej. en local), usa los valores por defecto de XAMPP.
    private static final String URL = System.getenv("DB_URL") != null
            ? System.getenv("DB_URL")
            : "jdbc:mysql://localhost:3307/onpe_maac";

    private static final String USER = System.getenv("DB_USER") != null
            ? System.getenv("DB_USER")
            : "root";

    private static final String PASSWORD = System.getenv("DB_PASSWORD") != null
            ? System.getenv("DB_PASSWORD")
            : "";

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
