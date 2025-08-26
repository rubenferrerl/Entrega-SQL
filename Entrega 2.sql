-- VIEWS

-- view para ver venta completa 

CREATE VIEW vw_Ventas_Detalle AS
SELECT 
    v.id_venta,
    v.fecha_venta,
    c.nombre AS cliente,
    e.nombre AS empleado,
    mp.tipo AS metodo_pago,
    dv.id_producto,
    p.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    (dv.cantidad * dv.precio_unitario) AS subtotal
FROM Ventas v
JOIN Clientes c ON v.id_cliente = c.id_cliente
JOIN Empleados e ON v.id_empleado = e.id_empleado
JOIN Metodos_pago mp ON v.id_metodo = mp.id_metodo
JOIN Detalle_ventas dv ON v.id_venta = dv.id_venta
JOIN Productos p ON dv.id_producto = p.id_producto;

-- view para ver ventas totales de clientes

CREATE VIEW vw_Clientes_Compras AS
SELECT 
    c.id_cliente,
    c.nombre,
    c.email,
    COUNT(v.id_venta) AS total_ventas,
    IFNULL(SUM(dv.cantidad * dv.precio_unitario),0) AS monto_total
FROM Clientes c
LEFT JOIN Ventas v ON c.id_cliente = v.id_cliente
LEFT JOIN Detalle_ventas dv ON v.id_venta = dv.id_venta
GROUP BY c.id_cliente, c.nombre, c.email;

-- Vista de Productos con stock y ventas

CREATE VIEW vw_Productos_Ventas AS
SELECT 
    p.id_producto,
    p.nombre AS producto,
    c.nombre AS categoria,
    p.stock,
    IFNULL(SUM(dv.cantidad),0) AS cantidad_vendida,
    IFNULL(SUM(dv.cantidad * dv.precio_unitario),0) AS total_vendido
FROM Productos p
JOIN Categorias c ON p.categoria_id = c.id_categoria
LEFT JOIN Detalle_ventas dv ON p.id_producto = dv.id_producto
GROUP BY p.id_producto, p.nombre, c.nombre, p.stock;

-- vista reseñas de producto

CREATE VIEW vw_Resenas_Productos AS
SELECT 
    p.id_producto,
    p.nombre AS producto,
    c.nombre AS cliente,
    r.comentario AS reseña,
    r.fecha_reseña
FROM Productos p
JOIN Reseñas r ON p.id_producto = r.id_producto
JOIN Clientes c ON r.id_cliente = c.id_cliente
ORDER BY p.id_producto, r.fecha_reseña;

-- Vista de Ventas por empleado y método de pago

CREATE VIEW vw_Ventas_Empleado_Pago AS
SELECT 
    e.id_empleado,
    e.nombre AS empleado,
    mp.tipo AS metodo_pago,
    COUNT(v.id_venta) AS total_ventas,
    IFNULL(SUM(dv.cantidad * dv.precio_unitario),0) AS monto_total
FROM Empleados e
JOIN Ventas v ON e.id_empleado = v.id_empleado
JOIN Metodos_pago mp ON v.id_metodo = mp.id_metodo
LEFT JOIN Detalle_ventas dv ON v.id_venta = dv.id_venta
GROUP BY e.id_empleado, e.nombre, mp.tipo;

-- FUNCIONES 

-- Función: Calcular subtotal de un producto en una venta

DELIMITER $$

CREATE FUNCTION fn_Subtotal(idVenta INT, idProducto INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE subtotal DECIMAL(10,2);
    
    SELECT cantidad * precio_unitario INTO subtotal
    FROM Detalle_ventas
    WHERE id_venta = idVenta AND id_producto = idProducto;
    
    RETURN subtotal;
END$$

DELIMITER ;

-- Función: Obtener total gastado por un cliente

DELIMITER $$

CREATE FUNCTION fn_TotalCliente(idCliente INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT IFNULL(SUM(dv.cantidad * dv.precio_unitario),0) INTO total
    FROM Ventas v
    JOIN Detalle_ventas dv ON v.id_venta = dv.id_venta
    WHERE v.id_cliente = idCliente;
    
    RETURN total;
END$$

DELIMITER ;

-- Stored Procedures

-- SP: Registrar una venta completa con detalles

DELIMITER $$

CREATE PROCEDURE sp_RegistrarVenta(
    IN p_id_cliente INT,
    IN p_id_empleado INT,
    IN p_id_metodo INT,
    IN p_fecha DATETIME,
    IN p_productos TEXT -- formato: 'idProducto:cantidad:precio,idProducto:cantidad:precio,...'
)
BEGIN
    DECLARE v_id_venta INT;
    DECLARE i INT DEFAULT 1;
    DECLARE n INT;
    DECLARE prod VARCHAR(50);
    DECLARE arr_productos TEXT;
    
    -- Insertar la venta
    INSERT INTO Ventas(fecha_venta, id_cliente, id_empleado, id_metodo, monto_total)
    VALUES (p_fecha, p_id_cliente, p_id_empleado, p_id_metodo, 0);
    
    SET v_id_venta = LAST_INSERT_ID();
    
    -- Aquí puedes agregar un loop para insertar los productos desde el texto p_productos
    -- (simplificado, se puede parsear en la aplicación)
END$$

DELIMITER ;

-- SP: Actualizar stock de un producto

DELIMITER $$

CREATE PROCEDURE sp_ActualizarStock(
    IN p_id_producto INT,
    IN p_nueva_cantidad INT
)
BEGIN
    UPDATE Productos
    SET stock = p_nueva_cantidad
    WHERE id_producto = p_id_producto;
END$$

DELIMITER ;

-- TRIGGERS

-- Trigger: Actualizar stock al insertar un detalle de venta

DELIMITER $$

CREATE TRIGGER trg_AjustarStock
AFTER INSERT ON Detalle_ventas
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET stock = stock - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END$$

DELIMITER ;

-- Trigger: Actualizar monto_total en Ventas después de insertar detalle

DELIMITER $$

CREATE TRIGGER trg_ActualizarMonto
AFTER INSERT ON Detalle_ventas
FOR EACH ROW
BEGIN
    UPDATE Ventas
    SET monto_total = IFNULL(monto_total,0) + (NEW.cantidad * NEW.precio_unitario)
    WHERE id_venta = NEW.id_venta;
END$$

DELIMITER ;
