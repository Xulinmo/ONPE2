package modelo;

import java.sql.Timestamp;

public class HistorialPassword {
    private int idHistorial;
    private int idUsuario;
    private String nombreUsuario; // Para mostrar el nombre en lugar de solo el ID
    private String contraseñaAnterior;
    private Timestamp fechaCambio;

    public HistorialPassword() {}

    // Getters y Setters
    public int getIdHistorial() { return idHistorial; }
    public void setIdHistorial(int idHistorial) { this.idHistorial = idHistorial; }
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }
    public String getContraseñaAnterior() { return contraseñaAnterior; }
    public void setContraseñaAnterior(String contraseñaAnterior) { this.contraseñaAnterior = contraseñaAnterior; }
    public Timestamp getFechaCambio() { return fechaCambio; }
    public void setFechaCambio(Timestamp fechaCambio) { this.fechaCambio = fechaCambio; }
}