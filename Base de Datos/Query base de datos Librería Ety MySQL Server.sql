create DATABASE db_inventarios;

USE db_inventarios;

-- Tabla de roles:
create table tbl_rol(
id_rol int primary key auto_increment, 
nombre_rol varchar(20) not null,
descripcion_rol varchar(100)
)


-- Tabla para usuarios del sistema
CREATE TABLE tbl_usuario (
    id_usuario INT PRIMARY KEY auto_increment,
    nombre_usuario VARCHAR(15) NOT NULL UNIQUE,
    contraseña_hash VARCHAR(20) NOT NULL,
	fecha_creacion datetime default current_timestamp, 
	correo_electronico varchar(30) unique, /*Recuperación de contraseña en caso de que la perdieran.*/ 
	estado tinyint(1), --Para ver si es activo (1) o inactivo (0)
	id_rol int,
	foreign key(id_rol) references tbl_rol(id_rol)
   
);

-- Tabla para proveedores
CREATE TABLE tbl_proveedores (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_proveedor VARCHAR(50) NOT NULL,
    no_telefono VARCHAR(10) NOT NULL
);

-- Tabla para el registro de la apertura y cierre de caja
CREATE TABLE tbl_caja (
    id_caja INT auto_increment PRIMARY KEY,
	tipo_operacion varchar(10) not null,
    fecha_y_hora DATETIME NOT NULL, /*Registro de a qué hora y fecha se hizo la apertura y cierre*/
	dinero_inicial DECIMAL(10,2) NOT NULL,
	dinero_final DECIMAL(10,2) NOT NULL,
    balance_del_dia DECIMAL(10,2),
	observaciones varchar(100)
);

-- Tabla para productos
CREATE TABLE tbl_productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR(100) NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL, /*Precio con el que se compró*/
    precio_venta DECIMAL(10,2) NOT NULL, /*Precio con que se vende al mercado*/
    cantidad_stock INT NOT NULL,
    unidad_de_medida VARCHAR(30), /*Unidades, docenas, cajas, etc*/
    Estado_del_producto tinyint(1), /*1 por si está activo y 0 para inactivo*/
    id_proveedor INT NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES tbl_proveedores(id_proveedor)
);

-- Tabla para ventas
CREATE TABLE tbl_ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    fecha_vendida DATE NOT NULL,
    total_vendido DECIMAL(10,2) NOT NULL,
    descripcion_venta VARCHAR(100) /*Por si desea agregar un mensaje sobre qué era la venta*/
);

-- Tabla intermedia para relacionar ventas con productos
CREATE TABLE tbl_venta_productos (
    id_venta INT,
    id_producto INT,
    cantidad_producto INT NOT NULL,
    unidad_de_medida VARCHAR(30) NOT NULL, /*unidad, docena, caja, etc.*/
    FOREIGN KEY (id_venta) REFERENCES tbl_ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES tbl_productos(id_producto),
    PRIMARY KEY (id_venta, id_producto)
);



-- Tabla para compras
CREATE TABLE tbl_compras (
    id_compra INT PRIMARY KEY AUTO_INCREMENT,
    fecha_de_compra DATE NOT NULL,
    total_de_la_compra DECIMAL(10,2),
    descripcion_compra VARCHAR(100),
    id_proveedor INT,
    FOREIGN KEY (id_proveedor) REFERENCES tbl_proveedores(id_proveedor)
);

-- Tabla intermedia para relacionar compras con productos
CREATE TABLE tbl_compra_productos (
    id_compra INT,
    id_producto INT,
    cantidad_comprado numeric(5,0) NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES tbl_compras(id_compra),
    FOREIGN KEY (id_producto) REFERENCES tbl_productos(id_producto),
    PRIMARY KEY (id_compra, id_producto)
);
