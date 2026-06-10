# ─────────────────────────────────────────
# ETAPA 1: Compilar el proyecto con Ant
# ─────────────────────────────────────────
FROM tomcat:9-jdk11 AS builder

# Instalar Ant y herramientas necesarias
RUN apt-get update && apt-get install -y ant wget && rm -rf /var/lib/apt/lists/*

# Descargar el conector MySQL
RUN wget -q https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.0.0/mysql-connector-j-9.0.0.jar \
    -O /opt/mysql-connector-j.jar

# Descargar iTextPDF
RUN wget -q https://repo1.maven.org/maven2/com/itextpdf/itextpdf/5.5.13.3/itextpdf-5.5.13.3.jar \
    -O /opt/itextpdf.jar

# Copiar el código fuente
WORKDIR /build
COPY AV2-Integrador/AV2-Integrador/MAAC_ONPE/MAAC_ONPE/ .

# Copiar los JARs a WEB-INF/lib para que Ant los incluya en el WAR
RUN mkdir -p web/WEB-INF/lib && \
    cp /opt/mysql-connector-j.jar web/WEB-INF/lib/ && \
    cp /opt/itextpdf.jar web/WEB-INF/lib/

# Compilar con Ant (genera dist/MAAC_ONPE.war)
RUN ant -f build.xml -Dj2ee.server.home=/usr/local/tomcat \
        -Dfile.reference.mysql-connector-j-9.7.0.jar=/opt/mysql-connector-j.jar \
        -Dfile.reference.itextpdf-5.5.13.jar=/opt/itextpdf.jar \
        war 2>&1

# ─────────────────────────────────────────
# ETAPA 2: Imagen final con Tomcat
# ─────────────────────────────────────────
FROM tomcat:9-jdk11

# Limpiar apps por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el WAR generado como ROOT (se sirve en la raíz /)
COPY --from=builder /build/dist/MAAC_ONPE.war /usr/local/tomcat/webapps/ROOT.war

# Puerto que Railway/Docker expondrá
EXPOSE 8080

CMD ["catalina.sh", "run"]
