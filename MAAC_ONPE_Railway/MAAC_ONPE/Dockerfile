# ─── ETAPA 1: Compilar el proyecto con Maven ───────────────────────────────
FROM maven:3.9-eclipse-temurin-11 AS build

WORKDIR /app

# Copiar todo el proyecto
COPY . .

# Compilar y empaquetar como WAR (sin tests)
RUN mvn clean package -DskipTests

# ─── ETAPA 2: Desplegar en Tomcat 9 ───────────────────────────────────────
FROM tomcat:9.0-jdk11

# Eliminar la app por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copiar el WAR generado como ROOT (accesible en /)
COPY --from=build /app/target/MAAC_ONPE.war /usr/local/tomcat/webapps/ROOT.war

# Crear carpeta de uploads persistente dentro del contenedor
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/uploads

# Puerto que usa Tomcat
EXPOSE 8080

# Iniciar Tomcat
CMD ["catalina.sh", "run"]
