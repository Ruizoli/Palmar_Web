PALMAR WEB - Sistema de Ferretería

1) Primero ejecuta en SQL Server el script: Palmar_base_datos.sql
2) Instala dependencias:
   py -m pip install -r requirements.txt
3) Revisa database.py:
   SERVER = "OLIVER-RUIZ"
   DATABASE = "Palmar"
4) Ejecuta:
   py app.py
5) Abre en tu PC:
   http://127.0.0.1:5000
6) Desde celular en el mismo Wi-Fi:
   http://IP-DE-TU-PC:5000

Usuarios de prueba:
Oliver Ruiz / 123456
Yamil Ruiz / 123456
Diana Aburto / 123456

Notas:
- El sistema usa Flask + SQL Server + Bootstrap.
- Las ventas descuentan stock con transacción para evitar stock negativo.
- Gestión de órdenes suma al stock cuando marcas una orden como recibida.
