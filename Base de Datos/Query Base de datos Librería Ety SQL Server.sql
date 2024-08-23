create DATABASE db_inventarios;

USE db_inventarios;

-- Tabla para usuarios del sistema					(Ya está)
create TABLE tbl_usuario (				
    id_usuario INT PRIMARY KEY identity(1,1),
    nombre_usuario VARCHAR(15) NOT NULL UNIQUE,
    contraseña_hash VARCHAR(75) NOT NULL,
	fecha_creacion datetime default getdate(), 
	correo_electronico varchar(50), /*Recuperación de contraseña en caso de que la perdieran.*/ 
	estado numeric(1), --Para ver si es activo (1) o inactivo (0)
	id_rol int,
	foreign key(id_rol) references tbl_rol(id_rol)
); 

/*insert into tbl_usuario(nombre_usuario,contraseña_hash,correo_electronico,estado,id_rol) values('Kalm_YT','12345','ericklopezca108@gmail.com',1,1);
select * from tbl_usuario;*/

/*alter table tbl_usuario 
alter column correo_electronico varchar(50) not null*/ 

/*delete from tbl_usuario where nombre_usuario='Juanxdxd';*/



--Tabla de roles:				(Ya está)
create table tbl_rol(
id_rol int primary key identity(1,1), 
nombre_rol varchar(15) not null,
descripcion_rol varchar(100)
)

/*insert into tbl_rol(nombre_rol,descripcion_rol) values('Administrador','el administrador del sistema');
  insert into tbl_rol(nombre_rol,descripcion_rol) values('Cajero','alguien que hará el cuadre y cierre de caja');
  insert into tbl_rol(nombre_rol,descripcion_rol) values('Inventario','alguien que verá entradas y salidas de productos');
  insert into tbl_rol(nombre_rol,descripcion_rol) values('Ventas','alguien que hará el cuadre y cierre de caja');

*/
--select * from tbl_rol;

-- Tabla para proveedores						(Ya está)
CREATE TABLE tbl_proveedores (
    id_proveedor INT identity(1,1) PRIMARY KEY,
    nombre_proveedor VARCHAR(100) NOT NULL,
    no_telefono VARCHAR(10) NOT NULL
);

-- insert into tbl_proveedores values('Coca Cola','45612378');
--select * from tbl_proveedores;

-- Tabla para productos					(Ya está)		
CREATE TABLE tbl_productos (
    id_producto INT identity(1,1) PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL, /*Precio con el que se compró*/
    precio_venta DECIMAL(10,2) NOT NULL, /*Precio con que se vende al mercado*/
    cantidad_stock INT NOT NULL,
    unidad_de_medida VARCHAR(50), /*Unidades, docenas, cajas, etc*/
    Estado_del_producto numeric(1), /*1 por si está activo y 0 para inactivo*/
    id_proveedor INT NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES tbl_proveedores(id_proveedor)
);
/*Insert into tbl_productos(nombre_producto, precio_compra, precio_venta, cantidad_stock, unidad_de_medida, Estado_del_producto,id_proveedor)
values('Pepsi de 1 litro',8,13,45,'Unidad',1,1);
*/
--select * from tbl_productos;

-- Tabla para ventas
CREATE TABLE tbl_ventas (
    id_venta INT identity(1,1) PRIMARY KEY,
    fecha_vendida DATE NOT NULL,
    total_vendido DECIMAL(10,2) NOT NULL,
    descripcion_venta VARCHAR(200) /*Por si desea agregar un mensaje sobre qué era la venta*/
);

--Select * from Tbl_ventas;

-- Tabla intermedia para relacionar ventas con productos
CREATE TABLE tbl_venta_productos (
    id_venta INT,
    id_producto INT,
    cantidad_producto INT NOT NULL,
    unidad_de_medida VARCHAR(50) NOT NULL, /*unidad, docena, caja, etc.*/
    FOREIGN KEY (id_venta) REFERENCES tbl_ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES tbl_productos(id_producto),
    PRIMARY KEY (id_venta, id_producto)
);

--Select * from tbl_venta_productos;

-- Tabla para el registro de la apertura y cierre de caja   (Ya está)
CREATE TABLE tbl_caja ( 
    id_caja INT identity(1,1) PRIMARY KEY,
	tipo_operacion varchar(10) not null,
    fecha_y_hora DATETIME NOT NULL, /*Registro de a qué hora y fecha se hizo la apertura y cierre*/
	dinero_inicial DECIMAL(10,2) NOT NULL,
	dinero_final DECIMAL(10,2) NOT NULL,
    balance_del_dia DECIMAL(10,2),
	observaciones varchar(255)
);

/*insert into tbl_caja(tipo_operacion,fecha_y_hora,dinero_inicial,dinero_final,balance_del_dia,observaciones) values('Apertura',getdate(),100.5,250,149.5,'Cuadre de caja de prueba');
select * from tbl_caja;
*/

-- Tabla para compras
CREATE TABLE tbl_compras (
    id_compra INT identity(1,1) PRIMARY KEY,
    fecha_de_compra DATE NOT NULL,
    total_de_la_compra DECIMAL(10,2),
    descripcion_compra VARCHAR(200),
    id_proveedor INT,
    FOREIGN KEY (id_proveedor) REFERENCES tbl_proveedores(id_proveedor)
);

-- Tabla intermedia para relacionar compras con productos
CREATE TABLE tbl_compra_productos (
    id_compra INT,
    id_producto INT,
    cantidad_comprado INT NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES tbl_compras(id_compra),
    FOREIGN KEY (id_producto) REFERENCES tbl_productos(id_producto),
    PRIMARY KEY (id_compra, id_producto)
);
 

 create table tbl_recuperarpassword(
 id_recuperar int primary key identity(1,1),
 nombre_usuario varchar(15) not null,
 correo_electronico varchar(50) not null
 );

 --insert into tbl_recuperarpassword values('Kalm_YT','ericklopezca108@gmail.com');