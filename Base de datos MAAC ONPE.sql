CREATE DATABASE IF NOT EXISTS onpe_maac;
USE onpe_maac;

-- 2. TABLAS MAESTRAS (Sin llaves foráneas)

CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL
);

CREATE TABLE estado (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado VARCHAR(50) NOT NULL
);

CREATE TABLE postulante (
    id_postulante INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(8) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    correo VARCHAR(100),
    telefono VARCHAR(15)
);

CREATE TABLE proceso_seleccion (
    id_proceso INT AUTO_INCREMENT PRIMARY KEY,
    nombre_proceso VARCHAR(100) NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
    estado_proceso VARCHAR(50)
);

-- 3. TABLAS DEPENDIENTES (Nivel 1)

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL,
    contraseña VARCHAR(100) NOT NULL,
    id_rol INT,
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE documento (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_documento VARCHAR(100) NOT NULL,
    tipo_archivo VARCHAR(50),
    tamaño INT,
    id_postulante INT,
    FOREIGN KEY (id_postulante) REFERENCES postulante(id_postulante) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE evaluacion (
    id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
    id_postulante INT,
    observacion TEXT,
    fecha_eval DATE,
    FOREIGN KEY (id_postulante) REFERENCES postulante(id_postulante) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE asignacion (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_postulante INT,
    id_proceso INT,
    fecha_asignacion DATE,
    FOREIGN KEY (id_postulante) REFERENCES postulante(id_postulante) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_proceso) REFERENCES proceso_seleccion(id_proceso) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE historial_password (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    contraseña_anterior VARCHAR(100),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

-- 4. TABLAS DEPENDIENTES (Nivel 2)

CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    accion_realizada TEXT NOT NULL,
    fecha_auditoria DATE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE historial (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    accion VARCHAR(100) NOT NULL,
    fecha DATE,
    hora TIME,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE documento_estado (
    id_doc_estado INT AUTO_INCREMENT PRIMARY KEY,
    id_documento INT,
    id_estado INT,
    FOREIGN KEY (id_documento) REFERENCES documento(id_documento) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Asegúrate de tener roles definidos (CUS-03)
INSERT INTO rol (nombre_rol) VALUES ('Administrador'), ('Analista RRHH'); 

-- Crea un usuario de prueba vinculado a un rol
INSERT INTO usuario (usuario, contraseña, id_rol) 
VALUES  ('admin_onpe', 'clave123', 1),('analista_onpe', 'onpe2026',2);

update usuario set correo = "adminOnpe@gmail.com" where id_usuario = 1;
update usuario set correo = "analistaOnpe@gmail.com" where id_usuario = 3;

select * from usuario;
delete from usuario where id_usuario = 2;

-- Estados del proceso (CUS-09)
INSERT INTO estado (nombre_estado) VALUES 
('Pendiente'), 
('En Evaluación'), 
('Aprobado'), 
('Observado'), 
('Desaprobado');

INSERT INTO proceso_seleccion (nombre_proceso, fecha_inicio, fecha_fin, estado_proceso) VALUES 
('Selección Coordinadores ODPE 2026', '2026-05-01', '2026-06-15', 'Activo'),
('Convocatoria Asistentes Administrativos', '2026-05-10', '2026-07-20', 'Activo'),
('Técnicos de Soporte Informático - Lima', '2026-04-15', '2026-05-30', 'En Cierre');

INSERT INTO postulante (dni, nombres, correo, telefono) VALUES 
('75554444', 'Elena Salazar Vizcarra', 'esalazar@mail.com', '988111222'),
('76665555', 'Roberto Díaz Flores', 'rdiaz@mail.com', '977222333'),
('77776666', 'Luciana Castro Rivadeneyra', 'lcastro@mail.com', '966333444'),
('78887777', 'Marcos Ruiz Tello', 'mruiz@mail.com', '955444555');

-- Asignamos a los primeros 3 al proceso 1
INSERT INTO asignacion (id_postulante, id_proceso, fecha_asignacion) VALUES 
(1, 1, '2026-05-02'),
(2, 1, '2026-05-03'),
(3, 1, '2026-05-05');

-- Creamos evaluaciones con observaciones (CUS-36)
INSERT INTO evaluacion (id_postulante, observacion, fecha_eval) VALUES 
(1, 'Perfil técnico sólido, cumple con los años de experiencia.', '2026-05-10'),
(2, 'Excelente manejo de grupos, recomendada para coordinación.', '2026-05-11'),
(4, 'Documentación pendiente de legalizar.', '2026-05-12');

-- Subida de archivos
INSERT INTO documento (nombre_documento, tipo_archivo, tamaño, id_postulante) VALUES 
('CV_Carlos_Ramos', 'PDF', 1024, 1),
('DNI_Patricia_Mendez', 'JPG', 512, 2),
('Certificado_Estudios_Juan', 'PDF', 2048, 3);

-- Un par de registros de historial para el Dashboard
INSERT INTO historial (id_usuario, accion, fecha, hora) VALUES 
(1, 'Validación de CV - Postulante 75554444', '2026-05-11', '09:15:00'),
(1, 'Actualización de perfil: Elena Salazar', '2026-05-11', '10:30:25'),
(1, 'Carga de documentos - Proceso ODPE', '2026-05-11', '11:45:10'),
(1, 'Generación de reporte mensual', '2026-05-11', '14:20:05');

-- Primero el documento
INSERT INTO documento (nombre_documento, tipo_archivo, tamaño, id_postulante) 
VALUES ('Ficha_Datos_Elena', 'PDF', 1200, 6);

-- Luego su estado (id_estado 3 = Aprobado, id_estado 4 = Observado)
INSERT INTO documento_estado (id_documento, id_estado) VALUES (4, 3);

INSERT INTO evaluacion (id_postulante, observacion, fecha_eval) VALUES 
(6, 'Postulante Aprobado - Cumple perfil', '2026-05-11'),
(7, 'Documento Observado - DNI ilegible', '2026-05-10'),
(8, 'Evaluación Pendiente de firma', '2026-05-09');

-- Pasos para subir Aprobados, Pendientes y Alertas:

-- A. Primero, registramos documentos para los postulantes que ya tienes (IDs 1 al 5)
INSERT INTO documento (nombre_documento, tipo_archivo, tamaño, id_postulante) VALUES 
('CV_Juan_Perez', 'PDF', 1024, 1),
('DNI_Patricia_Mendez', 'JPG', 512, 2),
('Certificado_Estudios', 'PDF', 2048, 3),
('Antecedentes_Penales', 'PDF', 1500, 4);

-- B. Ahora asignamos estados a esos documentos (Esto es lo que sube los contadores)
INSERT INTO documento_estado (id_documento, id_estado) VALUES 
(1, 3), -- Juan Perez -> Aprobado (ID 3)
(2, 1), -- Patricia Mendez -> Pendiente (ID 1)
(3, 4), -- Juan Torres -> Observado/Alerta (ID 4)
(4, 3); -- Lucia Castro -> Aprobado (ID 3)

INSERT INTO historial (id_usuario, accion, fecha, hora) VALUES 
(1, 'Documento de Juan Pérez aprobado', '2026-05-11', '23:15:00'),
(1, 'Se generó alerta por documento observado', '2026-05-11', '23:20:00');

select * from postulante;
delete from postulante where id_postulante = 11;

-- Ejecuta esto en MySQL si tu tabla no tiene estas columnas aún
ALTER TABLE postulante 
ADD COLUMN apellidos VARCHAR(100),
ADD COLUMN cargo VARCHAR(50),
ADD COLUMN modalidad VARCHAR(50),
ADD COLUMN direccion VARCHAR(200),
ADD COLUMN observaciones TEXT,
ADD COLUMN ruta_cv VARCHAR(255);

-- Registramos movimientos de auditoría (CUS-25)
INSERT INTO historial (id_usuario, accion, fecha, hora) VALUES 
(1, 'Inicio de sesión: Administrador', CURDATE(), '08:30:00'),
(1, 'Nuevo postulante: 71234567 registrado', CURDATE(), '09:15:22'),
(1, 'Validación de documentos: Carlos Ramos', CURDATE(), '10:05:10'),
(1, 'Evaluación técnica completada: Patricia Méndez', CURDATE(), '11:45:00');

ALTER TABLE usuario 
ADD COLUMN correo VARCHAR(100) NOT NULL AFTER contraseña;
ALTER TABLE usuario 
ADD COLUMN nombres VARCHAR(100) NOT NULL AFTER id_usuario;

-- 1. Tabla de Permisos (Vista 2 - 2FN1)
CREATE TABLE permiso (
    id_permiso INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL -- Ej: "Registrar Postulante", "Eliminar Usuario"
);

-- 2. Tabla Intermedia (Vista 2 - 3FN)
-- Relaciona Roles con Permisos (Muchos a Muchos)
CREATE TABLE permiso_rol (
    id_rol INT,
    id_permiso INT,
    PRIMARY KEY (id_rol, id_permiso),
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE CASCADE,
    FOREIGN KEY (id_permiso) REFERENCES permiso(id_permiso) ON DELETE CASCADE
);

-- 3. Insertar datos de prueba para la ONPE
INSERT INTO permiso (descripcion) VALUES 
('Ver Dashboard'), ('Registrar Postulante'), ('Modificar Postulante'), ('Gestionar Usuarios');

-- Asignar todos los permisos al Administrador (ID 1)
INSERT INTO permiso_rol (id_rol, id_permiso) VALUES (1,1), (1,2), (1,3), (1,4);

ALTER TABLE postulante 
ADD COLUMN fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN estado VARCHAR(20) DEFAULT 'Pendiente';

select * from postulante;

-- Se eliminan los DEFAULT que fallan y se recomienda usar DATETIME para mayor compatibilidad
CREATE TABLE carga_documento (
    id_carga INT AUTO_INCREMENT PRIMARY KEY,
    id_postulante INT,
    fecha DATE, 
    hora TIME,
    FOREIGN KEY (id_postulante) REFERENCES postulante(id_postulante)
);

-- 2. Tabla para el Requerimiento 13: Historial de carga
CREATE TABLE historial_carga (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_postulante INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP, -- DATETIME sí acepta CURRENT_TIMESTAMP sin errores
    usuario_responsable VARCHAR(100),
    FOREIGN KEY (id_postulante) REFERENCES postulante(id_postulante)
);

-- 3. Tabla para el Requerimiento 12: Auditoría de Visualización
CREATE TABLE visualizacion_log (
    id_visualizacion INT AUTO_INCREMENT PRIMARY KEY,
    id_postulante INT,
    fecha_visualizacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_que_vio VARCHAR(100),
    FOREIGN KEY (id_postulante) REFERENCES postulante(id_postulante)
);

CREATE TABLE log_descargas (
    id_descarga INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    nombre_archivo VARCHAR(255),
    fecha_descarga DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

select * from usuario;

-- Agregamos el borrado en cascada a las tablas de auditoría
ALTER TABLE carga_documento 
ADD CONSTRAINT fk_postulante_carga FOREIGN KEY (id_postulante) 
REFERENCES postulante(id_postulante) ON DELETE CASCADE;

ALTER TABLE historial_carga 
ADD CONSTRAINT fk_postulante_historial FOREIGN KEY (id_postulante) 
REFERENCES postulante(id_postulante) ON DELETE CASCADE;

ALTER TABLE visualizacion_log 
ADD CONSTRAINT fk_postulante_vis FOREIGN KEY (id_postulante) 
REFERENCES postulante(id_postulante) ON DELETE CASCADE;

DROP TABLE IF EXISTS evaluacion;

CREATE TABLE evaluacion (
    id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
    id_postulante INT,
    id_usuario INT, -- El administrador que evalúa (Req. 34)
    tipo_evaluacion VARCHAR(100),
    puntaje INT,
    resultado VARCHAR(50),
    observacion TEXT,
    fecha_eval DATE,
    FOREIGN KEY (id_postulante) REFERENCES postulante(id_postulante) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
);

ALTER TABLE evaluacion ADD COLUMN estado_obs VARCHAR(20) DEFAULT 'Pendiente';
-- Primero asegúrate de tener la columna de estado

ALTER TABLE evaluacion ADD COLUMN nivel_riesgo VARCHAR(20) AFTER resultado;

-- Insertar datos de prueba (Asegúrate que los id_postulante 1, 2 y 3 existan)
INSERT INTO evaluacion (id_postulante, id_usuario, tipo_evaluacion, puntaje, resultado, nivel_riesgo, observacion, fecha_eval, estado_obs) 
VALUES 
(1, 1, 'Evaluación Técnica', 50, 'Observado', 'Medio', 'Inconsistencia en respuestas', '2026-05-10', 'Pendiente'),
(2, 1, 'Entrevista Personal', 40, 'Observado', 'Alto', 'No cumplió criterio de comunicación', '2026-05-09', 'Resuelta'),
(3, 1, 'Prueba Psicológica', 45, 'Observado', 'Medio', 'Resultados fuera de rango esperado', '2026-05-08', 'Pendiente');

-- Primero eliminamos las relaciones viejas para recrearlas correctamente
ALTER TABLE evaluacion DROP FOREIGN KEY evaluacion_ibfk_1;
ALTER TABLE carga_documento DROP FOREIGN KEY carga_documento_ibfk_1;

-- Las recreamos con ON DELETE CASCADE
ALTER TABLE evaluacion 
ADD CONSTRAINT fk_postulante_eval 
FOREIGN KEY (id_postulante) REFERENCES postulante(id_postulante) 
ON DELETE CASCADE;

ALTER TABLE carga_documento 
ADD CONSTRAINT fk_postulante_doc 
FOREIGN KEY (id_postulante) REFERENCES postulante(id_postulante) 
ON DELETE CASCADE;

-- Ejecuta esto en tu herramienta de SQL
ALTER TABLE carga_documento ADD COLUMN tipo_documento VARCHAR(100);

-- Agregamos las columnas para el archivo y el estado
ALTER TABLE carga_documento ADD COLUMN nombre_archivo VARCHAR(255);
ALTER TABLE carga_documento ADD COLUMN ruta_archivo VARCHAR(255);
ALTER TABLE carga_documento ADD COLUMN estado VARCHAR(20) DEFAULT 'Pendiente';

-- Opcional: Si quieres guardar la fecha y hora en una sola columna más moderna
ALTER TABLE carga_documento ADD COLUMN fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Esto borrará las filas que salen con "null" en tu pantalla
/* 1. LIMPIEZA: Borramos los registros con datos 'null' que rompen el sistema */
DELETE FROM carga_documento;

/* 2. ESTRUCTURA: Agregamos todas las columnas que el código Java necesita */
ALTER TABLE carga_documento 
ADD COLUMN tipo_documento VARCHAR(100),
ADD COLUMN nombre_archivo VARCHAR(255),
ADD COLUMN ruta_archivo VARCHAR(255),
ADD COLUMN estado VARCHAR(20) DEFAULT 'Pendiente',
ADD COLUMN fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- 1. Desactivamos la revisión de llaves foráneas
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Vaciamos primero la tabla hija (los logs)
TRUNCATE TABLE visualizacion_log;

-- 3. Ahora sí podemos vaciar la tabla de documentos
TRUNCATE TABLE carga_documento;

-- 4. Reactivamos la seguridad
SET FOREIGN_KEY_CHECKS = 1;



/* 4. Verificación: La tabla debe aparecer vacía pero con todas sus columnas */
SELECT * FROM carga_documento;

/* 1. Eliminamos la versión anterior si existe */
DROP TABLE IF EXISTS visualizacion_log;

/* 2. Creamos la versión optimizada vinculada al documento */
CREATE TABLE visualizacion_log (
    id_visualizacion INT AUTO_INCREMENT PRIMARY KEY,
    id_carga INT, -- Vinculamos al documento específico
    usuario_visor VARCHAR(100), -- Nombre del admin/analista que lo vio
    fecha_vista DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_documento_vis FOREIGN KEY (id_carga) 
        REFERENCES carga_documento(id_carga) ON DELETE CASCADE
);

/* Verificamos la estructura */
DESCRIBE visualizacion_log;
DESCRIBE carga_documento;
select * from carga_documento;
select * from postulante;

USE onpe_maac;

-- 1. Agregamos la columna de auditoría que le falta a la tabla
ALTER TABLE postulante ADD COLUMN usuario_registro VARCHAR(100);

-- 2. Limpieza de seguridad (para evitar IDs duplicados o nulos de pruebas fallidas)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE visualizacion_log;
TRUNCATE TABLE carga_documento;
TRUNCATE TABLE postulante;
SET FOREIGN_KEY_CHECKS = 1;

-- 3. Verificación final
DESCRIBE postulante;