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

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cedula VARCHAR(50),
    telefono VARCHAR(20),
    correo VARCHAR(100)
);

CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200)
);

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria_id INT REFERENCES categorias(id),
    precio NUMERIC(10,2) NOT NULL DEFAULT 0,
    stock INT NOT NULL DEFAULT 0
);

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    cedula VARCHAR(50),
    telefono VARCHAR(20),
    cargo VARCHAR(100),
    salario NUMERIC(10,2),
    estado VARCHAR(20) DEFAULT 'Activo',
    fecha_registro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    usuario VARCHAR(100) UNIQUE NOT NULL,
    pass VARCHAR(100) NOT NULL,
    rol VARCHAR(30) NOT NULL
);

CREATE TABLE ventas (
    id SERIAL PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total NUMERIC(10,2) NOT NULL DEFAULT 0,
    empleado_id INT REFERENCES empleados(id),
    cliente_id INT REFERENCES clientes(id),
    observacion TEXT
);

CREATE TABLE detalle_venta (
    id SERIAL PRIMARY KEY,
    venta_id INT NOT NULL REFERENCES ventas(id) ON DELETE CASCADE,
    producto_id INT NOT NULL REFERENCES productos(id),
    cantidad INT NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL
);

CREATE TABLE orden_compra (
    id SERIAL PRIMARY KEY,
    po VARCHAR(50) UNIQUE NOT NULL,
    proveedor VARCHAR(150) NOT NULL,
    fecha VARCHAR(20),
    estado VARCHAR(20) DEFAULT 'Pendiente',
    memo TEXT
);

CREATE TABLE orden_compra_detalle (
    id SERIAL PRIMARY KEY,
    po VARCHAR(50) NOT NULL REFERENCES orden_compra(po) ON DELETE CASCADE,
    producto VARCHAR(100) NOT NULL,
    cantidad INT NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL
);

CREATE TABLE ingreso_recepcion (
    id SERIAL PRIMARY KEY,
    ir VARCHAR(50) UNIQUE NOT NULL,
    po VARCHAR(50) NOT NULL REFERENCES orden_compra(po),
    recibido_por VARCHAR(150),
    numero_factura VARCHAR(100),
    memo TEXT,
    fecha_recepcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO categorias(nombre, descripcion) VALUES
('Herramientas', 'Herramientas de trabajo'),
('Pinturas', 'Pinturas para hogar'),
('Construcción', 'Materiales de construcción');

INSERT INTO productos(nombre, categoria_id, precio, stock) VALUES
('Martillo', 1, 350, 20),
('Clavos', 1, 80, 100),
('Pintura Azul', 2, 500, 15),
('Cemento', 3, 420, 30);

INSERT INTO clientes(nombre, cedula, telefono, correo) VALUES
('Juan Perez', '001-123456-0001A', '88888888', 'juan@gmail.com'),
('Ana Lopez', '001-123456-0002B', '77777777', 'ana@gmail.com');

INSERT INTO empleados(nombre, apellido, cedula, telefono, cargo, salario, estado) VALUES
('Carlos', 'Ruiz', '', '', 'Administrador', 12000, 'Activo'),
('Maria', 'Lopez', '', '', 'Vendedora', 9000, 'Activo'),
('Oliver', 'Ruiz', '001-123456-0001A', '88888888', 'Administrador', 15000, 'Activo'),
('Yamil', 'Ruiz', '001-123456-0002A', '77777777', 'Administrador', 15000, 'Activo'),
('Diana', 'Aburto', '001-123456-0003A', '88887777', 'Vendedora', 9000, 'Activo');

INSERT INTO usuarios(usuario, pass, rol) VALUES
('Oliver Ruiz', 'oligazo.01', 'Administrador'),
('Yamil Ruiz', '123456', 'Administrador'),
('Diana Ruiz', '123456', 'Vendedor'),
('Yamilito Ruiz', '123456', 'Cliente'),
('admin', '123456', 'Administrador');