--use db_inventarios; 

create view vw_lista_compra 
as
select nombre_producto, precio_venta, cantidad_stock, pr.nombre_proveedor, pr.no_telefono from tbl_productos p
inner join 
tbl_proveedores pr on p.id_proveedor=pr.id_proveedor 
where cantidad_stock<=5 
go 

select * from vw_lista_compra; 

select * from tbl_proveedores;

create view vw_productos as
select nombre_producto, precio_venta, cantidad_stock from tbl_productos 
go


--Procedimiento almacenado: 

create procedure sp_productos(
 @nombre_producto varchar(100),
@precio_compra decimal(10,2),
@precio_venta decimal(10,2),
@cantidad_stock int,
@unidad_de_medida varchar(30),
@Estado_del_producto numeric(1,0),
@id_proveedor int
)
as
begin
declare @producto_existente int

--Verificar si el producto ingresado est� vac�o o nulo:
if(@nombre_producto='' or @nombre_producto is null)
begin 
raiserror('El producto ingresado no puede estar vac�o o nulo',16,1)
return;

end 
--Verificar si el producto ya existe en la base de datos o no:

select @producto_existente=count(*) from tbl_productos where nombre_producto=@nombre_producto;
if (@producto_existente>0)
begin
raiserror('El producto ya existe en la base de datos',16,1)
return;
end
--Verificar que la cantidad en stock no sea menor a 0
if @cantidad_stock<0
begin
raiserror('El stock ingresado no puede ser menor a 0',16,1)
return;
end
--Verificar que el precio compra y/o venta no sean menor a 0
if(@precio_compra<=0 or @precio_venta<=0)
begin
raiserror('El Precio ingresado no puede ser menor o igual a 0',16,1)
return;
end
--Verificar que el precio venta sea mayor al precio compra
if(@precio_venta<=@precio_compra)
begin
raiserror('El precio de venta no puede ser menor al precio de compra',16,1) 
return;
end
--Verificar que la unidad de medida no est� vac�a
if(@unidad_de_medida='' or @unidad_de_medida is null)
begin
raiserror('La unidad de medida no puede estar vac�a',16,1)
return;
end
if @Estado_del_producto not in(0,1)
begin
raiserror('El estado del producto solo puede ser 0 o 1',16,1)
return;
end
--Verificar que el proveedor exista
if not exists(select 1 from tbl_proveedores where id_proveedor=@id_proveedor)
begin
raiserror('Por favor, ingrese un proveedor que exista',16,1)
return;
end
--Inserci�n de los valores
  INSERT INTO tbl_productos (
        nombre_producto,
        precio_compra,
        precio_venta,
        cantidad_stock,
        unidad_de_medida,
        Estado_del_producto,
        id_proveedor
        ) VALUES (
        @nombre_producto,
        @precio_compra,
        @precio_venta,
        @cantidad_stock,
        @unidad_de_medida,
        @Estado_del_producto,
        @id_proveedor
    );

end
/*
exec sp_productos
'Lapicero bic azul',
 4,
5,
100,
'Unidad',
1,
1*/

/*select * from tbl_productos;

delete from tbl_productos where id_producto=9 */

--SP para el registro de usuario: 

create procedure sp_registrar_usuario(
	@nombre_usuario VARCHAR(15), 
    @contrase�a_hash VARCHAR(64),  
	@correo_electronico varchar(50), 
	@estado numeric(1),
	@id_rol int
)
as
begin
declare @usuario_existente int;
--Verificar que no ingrese usuarios nulos o vac�os: 
if(@nombre_usuario='' or @nombre_usuario is null)
begin
raiserror('El nombre de usuario no puede estar vac�o',16,1);
return;
end
--Verificar que la contrase�a no est� nula o vac�a: 
if(@contrase�a_hash='' or @contrase�a_hash is null)
begin
raiserror('La contrase�a no puede estar vac�a',16,1);
return;
end
--Verificar que el nombre de usuario no exista: 
select @usuario_existente=count(*) from tbl_usuario where nombre_usuario=@nombre_usuario;
if (@usuario_existente>0)
begin
raiserror('El nombre de usuario ya existe',16,1)
return;
end
--Verificar que el correo electr�nico no est� vac�o o nulo: 
if(@correo_electronico='' or @correo_electronico is null)
begin
raiserror('El correo electr�nico no puede estar vac�o o nulo',16,1);
return;
end
--Verificar que la contrase�a sea de un tama�o mayor a 5 caracteres: 
if LEN(@contrase�a_hash)<=5
begin
raiserror('La contrase�a es muy corta, int�ntelo nuevamente',16,1)
return;
end
--Ver que el estado solo est� entre 0 y 1: 
if @estado not in(0,1)
begin
raiserror('El estado solo puede ser 0 o 1',16,1)
return;
end
--Verificar que el correo electr�nico tenga una estructura v�lida: 
if(@correo_electronico not like '%_@__%.__%')
begin
raiserror('El correo electr�nico no tiene una estructura v�lida',16,1)
return;
end

-- Verificar que la contrase�a contenga al menos una letra y un n�mero:
if (@contrase�a_hash NOT LIKE '%[a-zA-Z]%' OR @contrase�a_hash NOT LIKE '%[0-9]%')
begin
    raiserror('La contrase�a debe contener al menos una letra y un n�mero', 16, 1);
    return;
end
-- Verificar que el rol exista en la tabla de roles:
if NOT EXISTS(select 1 from tbl_rol where id_rol = @id_rol)
begin
    raiserror('El rol especificado no existe', 16, 1);
    return;
end
-- Verificar que el correo electr�nico no exceda la longitud m�xima permitida:
if LEN(@correo_electronico) > 50
begin
    raiserror('El correo electr�nico es demasiado largo', 16, 1);
    return;
end


--Inserci�n de los valores: 
insert into tbl_usuario(
nombre_usuario,
contrase�a_hash,
correo_electronico,
estado,id_rol)
values(
@nombre_usuario,
@contrase�a_hash,
@correo_electronico,
@estado,
@id_rol)
end

exec sp_registrar_usuario
'rosario_tijeras',
'Rosario12345',
'rosario1@gmail.com',
1,
1


/*insert into tbl_usuario(nombre_usuario,contrase�a_hash,correo_electronico,estado,id_rol) values('Antuan','Roserade','antuan@gmail.com',1,1)
*/
select * from tbl_usuario;



--Trigger que hace que al insertar una venta, se cambie la cantidad en stock autom�ticamente: 
CREATE TRIGGER actualizar_stock_venta 
ON tbl_venta_productos
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET p.cantidad_stock = p.cantidad_stock - i.cantidad_producto
    FROM tbl_productos p
    INNER JOIN inserted i ON p.id_producto = i.id_producto;
END

--Fin del trigger.

--Trigger que hace que al insertar una compra, se cambie el stock autom�ticamente. 
CREATE TRIGGER actualizar_stock_compra 
ON tbl_compra_productos
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET p.cantidad_stock = p.cantidad_stock + i.cantidad_comprado
    FROM tbl_productos p
    INNER JOIN inserted i ON p.id_producto = i.id_producto;
END
--Fin del trigger.

--Trigger que actualice el balance en la tabla caja luego de hacer un insert: 
CREATE TRIGGER calcular_balance_caja
ON tbl_caja
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar el balance del d�a
    UPDATE c
    SET c.balance_del_dia = i.dinero_final - i.dinero_inicial
    FROM tbl_caja c
    INNER JOIN inserted i ON c.id_caja = i.id_caja;
END
--Fin del trigger

--SP para hacer validaciones para recuperar contrase�a de usuarios: 
create procedure sp_recuperar_password(
@nombre_usuario varchar(15),
@correo_electronico varchar(50)
)
as
begin
--Ver que el nombre de usuario no est� vac�o o nulo: 
if(@nombre_usuario='' or @nombre_usuario is null)
begin
raiserror('El nombre de usuario no puede estar vac�o',16,1);
return;
end
--Ver que el correo electr�nico no est� vac�o o nulo:
if(@correo_electronico='' or @nombre_usuario is null)
begin
raiserror('El correo electr�nico no puede estar vac�o',16,1)
return;
end
--Ver que el usuario exista en la base de datos: 
if not exists(select 1 from tbl_usuario where nombre_usuario = @nombre_usuario)
begin
raiserror('El usuario no existe', 16, 1);
return;
end
--Ver que el correo electr�nico exista en la base de datos:
if not exists(select 1 from tbl_usuario where correo_electronico=@correo_electronico)
begin
raiserror('El correo electr�nico no existe',16,1);
return;
end
--Ver que el correo electr�nico y el nombre pertenezcan a un mismo usuario: 
if not exists(select * from tbl_usuario where nombre_usuario=@nombre_usuario and correo_electronico=@correo_electronico)
begin
raiserror('El correo electr�nico  el nombre de usuario no coinciden con ning�n usuario',16,1)
return;
end
--Ver si ya hay una solicitud para este usuario
if exists (select 1 from tbl_recuperarpassword 
           where nombre_usuario = @nombre_usuario)
begin
raiserror('Ya existe una solicitud de recuperaci�n pendiente para este usuario', 16, 1);
return;
end
--Ver que el formato del correo electr�nico est� bien
if(@correo_electronico not like '%_@__%.com%')
begin
raiserror('El correo electr�nico no tiene formato v�lido',16,1)
return;
end
insert into tbl_recuperarpassword(
nombre_usuario,
correo_electronico
)
values(
@nombre_usuario,
@correo_electronico
)
end

select * from tbl_rol