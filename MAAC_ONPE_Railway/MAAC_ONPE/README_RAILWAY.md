# 🚀 Despliegue en Railway — MAAC ONPE

## Archivos agregados para Railway
- `Dockerfile` — construye el WAR y lo despliega en Tomcat 9
- `pom.xml` — gestión de dependencias con Maven
- `src/java/modelo/Conexion.java` — actualizado para leer variables de entorno
- `web/WEB-INF/web.xml` — configuración de la app web
- `.gitignore` — excluye archivos innecesarios de Git

---

## Pasos para publicar

### 1. Subir a GitHub
```bash
git init
git add .
git commit -m "Configurado para Railway"
git remote add origin https://github.com/TU_USUARIO/MAAC_ONPE.git
git push -u origin main
```

### 2. Crear base de datos MySQL en Railway
1. Entra a https://railway.app → New Project
2. Add Service → Database → MySQL
3. En la pestaña **"Data"**, importa tu dump SQL

### 3. Conectar tu repo en Railway
1. Add Service → GitHub Repo → selecciona MAAC_ONPE
2. Railway detectará el Dockerfile automáticamente

### 4. Agregar variables de entorno al servicio Java
En el servicio de tu app → Variables → Add Reference (selecciona el servicio MySQL):
- MYSQLHOST
- MYSQLPORT
- MYSQLDATABASE
- MYSQLUSER
- MYSQLPASSWORD

### 5. Deploy
Railway hará el build automáticamente. Tu app estará en:
`https://MAAC_ONPE.up.railway.app`

---

## ⚠️ Nota sobre archivos subidos (uploads)
Los archivos PDF que suben los usuarios se guardan en el servidor.
En Railway el disco es efímero (se borra al redeploy).
Para producción real considera mover los uploads a **Cloudinary** o **Amazon S3**.
