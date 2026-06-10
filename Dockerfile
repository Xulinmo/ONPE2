FROM tomcat:9-jdk11

# Copia el WAR compilado al directorio de Tomcat
COPY MAAC_ONPE/dist/MAAC_ONPE.war /usr/local/tomcat/webapps/ROOT.war
https://github.com/Xulinmo/ONPE2/tree/main
EXPOSE 8080
CMD ["catalina.sh", "run"]
