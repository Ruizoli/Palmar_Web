USE master;
GO

IF DB_ID('Palmar') IS NULL
    CREATE DATABASE Palmar;
GO

USE Palmar;
GO

DROP TABLE IF EXISTS ingreso_recepcion;
DROP TABLE IF EXISTS orden_compra_detalle;
DROP TABLE IF EXISTS orden_compra;
DROP TABLE IF EXISTS detalle_venta;
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS usuarios;
GO

CREATE TABLE clientes (id INT PRIMARY KEY IDENTITY(1,1), nombre VARCHAR(100) NOT NULL, cedula VARCHAR(50), telefono VARCHAR(20), correo VARCHAR(100));
GO
CREATE TABLE categorias (id INT PRIMARY KEY IDENTITY(1,1), nombre VARCHAR(100) NOT NULL, descripcion VARCHAR(200));
GO
CREATE TABLE productos (id INT PRIMARY KEY IDENTITY(1,1), nombre VARCHAR(100) NOT NULL, categoria_id INT, precio DECIMAL(10,2) NOT NULL DEFAULT 0, stock INT NOT NULL DEFAULT 0, FOREIGN KEY (categoria_id) REFERENCES categorias(id));
GO
CREATE TABLE empleados (id INT PRIMARY KEY IDENTITY(1,1), nombre VARCHAR(100) NOT NULL, apellido VARCHAR(100), cedula VARCHAR(50), telefono VARCHAR(20), cargo VARCHAR(100), salario DECIMAL(10,2), estado VARCHAR(20) DEFAULT 'Activo', fecha_registro DATE DEFAULT GETDATE());
GO
CREATE TABLE ventas (id INT PRIMARY KEY IDENTITY(1,1), fecha DATETIME DEFAULT GETDATE(), total DECIMAL(10,2) NOT NULL DEFAULT 0, empleado_id INT, FOREIGN KEY (empleado_id) REFERENCES empleados(id));
GO
CREATE TABLE detalle_venta (id INT PRIMARY KEY IDENTITY(1,1), venta_id INT NOT NULL, producto_id INT NOT NULL, cantidad INT NOT NULL, precio DECIMAL(10,2) NOT NULL, subtotal DECIMAL(10,2) NOT NULL, FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE, FOREIGN KEY (producto_id) REFERENCES productos(id));
GO
CREATE TABLE usuarios (id INT PRIMARY KEY IDENTITY(1,1), usuario VARCHAR(100) UNIQUE NOT NULL, pass VARCHAR(100) NOT NULL, rol VARCHAR(30) NOT NULL);
GO
CREATE TABLE orden_compra (id INT PRIMARY KEY IDENTITY(1,1), po VARCHAR(50) UNIQUE NOT NULL, proveedor VARCHAR(150) NOT NULL, fecha VARCHAR(20), estado VARCHAR(20) DEFAULT 'Pendiente', memo VARCHAR(MAX));
GO
CREATE TABLE orden_compra_detalle (id INT PRIMARY KEY IDENTITY(1,1), po VARCHAR(50) NOT NULL, producto VARCHAR(100) NOT NULL, cantidad INT NOT NULL, precio DECIMAL(10,2) NOT NULL, subtotal DECIMAL(10,2) NOT NULL, FOREIGN KEY (po) REFERENCES orden_compra(po) ON DELETE CASCADE);
GO
CREATE TABLE ingreso_recepcion (id INT PRIMARY KEY IDENTITY(1,1), ir VARCHAR(50) UNIQUE NOT NULL, po VARCHAR(50) NOT NULL, recibido_por VARCHAR(150), numero_factura VARCHAR(100), memo VARCHAR(MAX), fecha_recepcion DATETIME DEFAULT GETDATE(), FOREIGN KEY (po) REFERENCES orden_compra(po));
GO

INSERT INTO categorias(nombre, descripcion) VALUES ('Herramientas', 'Herramientas de trabajo'), ('Pinturas', 'Pinturas para hogar'), ('Construcción', 'Materiales de construcción');
GO
INSERT INTO productos(nombre, categoria_id, precio, stock) VALUES ('Martillo', 1, 350, 20), ('Clavos', 1, 80, 100), ('Pintura Azul', 2, 500, 15), ('Cemento', 3, 420, 30);
GO
INSERT INTO clientes(nombre, cedula, telefono, correo) VALUES ('Juan Perez', '001-123456-0001A', '88888888', 'juan@gmail.com'), ('Ana Lopez', '001-123456-0002B', '77777777', 'ana@gmail.com');
GO
INSERT INTO empleados(nombre, apellido, cedula, telefono, cargo, salario, estado) VALUES ('Carlos', 'Ruiz', '', '', 'Administrador', 12000, 'Activo'), ('Maria', 'Lopez', '', '', 'Vendedora', 9000, 'Activo'), ('Oliver', 'Ruiz', '001-123456-0001A', '88888888', 'Administrador', 15000, 'Activo'), ('Yamil', 'Ruiz', '001-123456-0002A', '77777777', 'Administrador', 15000, 'Activo'), ('Diana', 'Aburto', '001-123456-0003A', '88887777', 'Vendedora', 9000, 'Activo');
GO
INSERT INTO usuarios(usuario, pass, rol) VALUES ('Oliver Ruiz', '123456', 'Administrador'), ('Yamil Ruiz', '123456', 'Administrador'), ('Diana Aburto', '123456', 'Vendedor'), ('Yamilito Ruiz', '123456', 'Cliente'), ('admin', '123456', 'Administrador');
GO
SELECT * FROM productos; SELECT * FROM empleados; SELECT * FROM usuarios;
GO

--CAMBIAS PARA CONTRASENA

USE Palmar;
GO

UPDATE usuarios
SET pass = 'oligazo.01'
WHERE usuario = 'Oliver Ruiz';
GO

--CAMBIO DE USUARIO 

USE Palmar;
GO

UPDATE usuarios
SET usuario = 'Diana Ruiz'
WHERE usuario = 'Diana Aburto';
GO

SELECT * FROM usuarios

-- asignar rol

UPDATE usuarios
SET rol = 'Administrador'
WHERE usuario = 'Yamil Ruiz';
GO


-- nueva tabla

USE Palmar;
GO

ALTER TABLE ventas
ADD cliente_id INT NULL;
GO

ALTER TABLE ventas
ADD CONSTRAINT FK_Ventas_Clientes
FOREIGN KEY (cliente_id) REFERENCES clientes(id);
GO

USE Palmar;
GO

DBCC CHECKIDENT ('ventas', RESEED, 14);
GO

SELECT MAX(id) AS UltimaFactura
FROM ventas;


SELECT * FROM ventas;
SELECT * FROM detalle_venta;


USE Palmar;
GO

DELETE FROM detalle_venta;
DELETE FROM ventas;
GO

DBCC CHECKIDENT ('ventas', RESEED, 0);
GO

USE Palmar;
GO
USE Palmar;
GO
--para basear las fact
DBCC CHECKIDENT ('ventas', RESEED, 0);
GO

USE Palmar;
GO

ALTER TABLE ventas
ADD observacion VARCHAR(MAX) NULL;
GO