package modelo;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    public static Connection conectar() {
        Connection cn = null;
        try {
            // Lee variables de entorno de Railway (o XAMPP local como fallback)
            String host     = getEnv("MYSQLHOST",     "localhost");
            String port     = getEnv("MYSQLPORT",     "3307");
            String database = getEnv("MYSQLDATABASE", "onpe_maac");
            String user     = getEnv("MYSQLUSER",     "root");
            String password = getEnv("MYSQLPASSWORD", "");

            String url = "jdbc:mysql://" + host + ":" + port + "/" + database
                       + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=America/Lima";

            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Error en la conexión: " + e.getMessage());
        }
        return cn;
    }

    private static String getEnv(String key, String defaultValue) {
        String val = System.getenv(key);
        return (val != null && !val.isEmpty()) ? val : defaultValue;
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
