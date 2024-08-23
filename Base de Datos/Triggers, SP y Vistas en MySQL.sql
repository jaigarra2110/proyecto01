/*Triggers para cambiar stock cuando ingresan datos en la tabla tbl_venta_productos:*/

/*DELIMITER $$

CREATE TRIGGER actualizar_stock_venta 
AFTER INSERT ON tbl_venta_productos
FOR EACH ROW
BEGIN
    UPDATE tbl_productos
    SET cantidad_stock = cantidad_stock - NEW.cantidad_producto
    WHERE id_producto = NEW.id_producto;
END$$

DELIMITER ;
*/

/*Trigger que actualiza el stock de la tabla productos cuando se ingresa un registro en la tabla tbl_compra_productos:*/
/*
DELIMITER $$

CREATE TRIGGER actualizar_stock_compra 
AFTER INSERT ON tbl_compra_productos
FOR EACH ROW
BEGIN
    UPDATE tbl_productos
    SET cantidad_stock = cantidad_stock + NEW.cantidad_comprado
    WHERE id_producto = NEW.id_producto;
END$$

DELIMITER ;
*/

insert into tbl_productos(nombre_producto,precio_compra,precio_venta,cantidad_stock,unidad_de_medida,Estado_del_producto,id_proveedor) values('Cocacola de 600 ML',5,8,50,'Unidad',1,1);

select * from tbl_productos;

insert into tbl_ventas(fecha_vendida,total_vendido,descripcion_venta) values(now(),2,null);
select * from tbl_ventas;

insert into tbl_venta_productos(id_venta,id_producto,cantidad_producto,unidad_de_medida) values(3,3,2,'Unidad');
select * from tbl_venta_productos; 

insert into tbl_compras(fecha_de_compra,total_de_la_compra,descripcion_compra,id_proveedor) values(curdate(),2,'',1);
select * from tbl_compras;

insert into tbl_compra_productos(id_compra,id_producto,cantidad_comprado,precio_compra) values(4,3,2,5);
select * from tbl_compra_productos;




/*Prueba de un SP para agregar productos en base a cierta especificación:*/ 

delimiter $$
create procedure sp_producto( 
in a_nombre_producto varchar(100),
in a_precio_compra decimal(10,2),
in a_precio_venta decimal(10,2),
in a_cantidad_stock int,
in a_unidad_de_medida varchar(30),
in a_Estado_del_producto tinyint(1),
in a_id_proveedor int )
begin 
declare producto_existe int; -- Variable local para que servirá para saber is el producto existe o no
 
-- Verificar que el nombre del producto no esté vacío: 
if(a_nombre_producto='' or a_nombre_producto is null) then

signal sqlstate '45000'
set message_text='El nombre del producto no puede estar vacío';
END if;

-- Verificar si un producto existe o no:
select count(*) into producto_existe  -- Verifica todos los productos en la base de datos no existan on el mismo nombre
from tbl_productos where nombre_producto=a_nombre_producto; 
if producto_existe>0 then 
signal sqlstate '45000'
set message_text='El producto ya existe en la base de datos'; 
end if; 

-- verificar que el stockingresado no sea menor a 0: 
if a_cantidad_stock<0 then
signal sqlstate '45000' 
set message_text='No puede ingresar un stock menor o igual a 0'; 
end if; 

-- Verificar que el precio compra y/o el precio venta no sean negativos: 
if (a_precio_compra <=0 or a_precio_venta <=0) then 
signal sqlstate '45000'
set message_text='No se puede ingresar precios negativos o iguales a 0'; 
end if; 

-- Verificar que el precio venta sea mayor al precio compra: 
if a_precio_venta<=a_precio_compra then 
signal sqlstate '45000' 
set message_text='El precio compra no puede ser mayor o igual al precio venta'; 
end if; 

-- Verificar que la unidad de medida no esté vacía: 
if (a_unidad_de_medida='' or a_unidad_de_medida is null) then 
signal sqlstate '45000' 
set message_text='La unidad de medida no puede ser nula'; 
end if; 

-- Verificar que el estado del producto sea válido (solo 0 o 1): 

if a_Estado_del_producto not in (0,1) then 
signal sqlstate '45000' 
set message_text='El estado del producto solo puede ser 0 o 1'; 
end if; 

-- Verificar que el ID_proveedor exista: 
if not exists( select 1 from tbl_proveedores where id_proveedor=a_id_proveedor) then 
signal sqlstate '45000' 
set message_text='El proveedor no existe'; 
end if; 

-- Inserción de los registros: 
-- Si todas las validaciones pasan, insertar el nuevo producto
    INSERT INTO tbl_productos (
        nombre_producto,
        precio_compra,
        precio_venta,
        cantidad_stock,
        unidad_de_medida,
        Estado_del_producto,
        id_proveedor
        ) VALUES (
        a_nombre_producto,
        a_precio_compra,
        a_precio_venta,
        a_cantidad_stock,
        a_unidad_de_medida,
        a_Estado_del_producto,
        a_id_proveedor
    );

end$$
delimiter ;


-- Ejecutando el SP para ver que funciona correctamente:  
select * from tbl_productos;

CALL sp_producto(
    'Coca de 1.5 litros',
    10.5,
    15.75,
    100,
    'Unidad',
    1,
    1
); 


-- Creación de una vista para ver los productos con stock menor o igual a 5:  
create view vw_lista_compra as
select p.nombre_producto, p.precio_venta, p.cantidad_stock, pr.nombre_proveedor, pr.no_telefono from tbl_productos p
inner join 
tbl_proveedores pr on p.id_proveedor=pr.id_proveedor
where cantidad_stock<=5 order by cantidad_stock asc;  

-- Ejecutando la vista: 
select * from vw_lista_compra;

-- Vista para ver los productos de menor a mayor: 
create view vw_productos as
select nombre_producto, precio_venta, cantidad_stock from tbl_productos order by cantidad_stock asc; 

-- Ejecutando la vista: 
select * from vw_productos;