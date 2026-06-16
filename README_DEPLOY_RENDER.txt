PALMAR WEB - GUÍA RÁPIDA PARA RENDER + SUPABASE

1) En Supabase crea un proyecto nuevo.
2) En Supabase abre SQL Editor y ejecuta todo el archivo schema_postgres.sql.
3) Copia el connection string de Supabase en modo Transaction pooler o Session pooler.
   Debe verse parecido a:
   postgresql://postgres.xxxxx:TU_PASSWORD@aws-0-us-east-1.pooler.supabase.com:6543/postgres
4) En GitHub sube esta carpeta Palmar_Web.
5) En Render crea un Web Service conectado al repositorio.
6) Configura:
   Build Command: pip install -r requirements.txt
   Start Command: gunicorn app:app
7) En Environment de Render agrega:
   DATABASE_URL = tu connection string de Supabase
   SECRET_KEY = una clave larga, por ejemplo palmar_2026_clave_segura
8) Deploy.

Usuario inicial:
admin / 123456

IMPORTANTE:
- No subas archivos .env a GitHub.
- Las carpetas facturas_pdf y ordenes_pdf no deben usarse como almacenamiento permanente en Render gratis.
