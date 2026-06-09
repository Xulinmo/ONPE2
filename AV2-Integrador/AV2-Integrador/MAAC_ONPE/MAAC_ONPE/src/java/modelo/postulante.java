package modelo;

public class postulante {
    
    // 1. DECLARACIÓN DE VARIABLES
    private int idPostulante;
    private String dni;
    private String nombres;
    private String apellidos;
    private String correo;
    private String telefono;
    private String cargo;
    private String modalidad;
    private String direccion;
    private String observaciones;
    private String rutaCv;
    
    // --- VARIABLES NUEVAS PARA LA TABLA Y EVALUACIÓN ---
    private String fechaRegistro;
    private String estado;

    // 2. CONSTRUCTOR VACÍO
    public postulante() {
    }

    // 3. GETTERS Y SETTERS
    public int getIdPostulante() {
        return idPostulante;
    }

    public void setIdPostulante(int idPostulante) {
        this.idPostulante = idPostulante;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public String getModalidad() {
        return modalidad;
    }

    public void setModalidad(String modalidad) {
        this.modalidad = modalidad;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public String getRutaCv() {
        return rutaCv;
    }

    public void setRutaCv(String rutaCv) {
        this.rutaCv = rutaCv;
    }

    // --- GETTERS Y SETTERS NUEVOS ---
    public String getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(String fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
