# ViveMatchaDB – Proyecto Final SQL

Este proyecto consiste en el diseño de una base de datos relacional en **MySQL** para **Vive Matcha**, una tienda de bebidas y productos saludables. El objetivo es digitalizar y organizar los procesos clave del negocio: ventas, productos, clientes, empleados, reseñas y control de stock.

---

## 📂 Contenido

- Introducción  
- Objetivos  
- Problemática  
- Modelo de negocio  
- Tablas incluidas  
- Diagrama entidad-relación (E-R)

---

## 🧾 Introducción

La base de datos propuesta facilitará la gestión operativa y comercial de Vive Matcha, mejorando el registro y control de productos, ventas y atención al cliente. También permitirá analizar la información para tomar mejores decisiones.

---

## 🎯 Objetivos

Crear una base de datos funcional que permita:

- Registrar productos y clasificarlos por categoría.
- Controlar el stock disponible.
- Administrar información de clientes y empleados.
- Registrar ventas y sus detalles.
- Analizar los productos más vendidos.
- Almacenar reseñas de clientes para evaluación de productos.

---

## ❗ Problemática

Actualmente, la tienda gestiona sus registros de forma manual, lo que genera inconvenientes como:

- Falta de trazabilidad de ventas y stock.
- Dificultad para saber cuáles productos tienen mejor rendimiento.
- Ausencia de registros sobre satisfacción del cliente.
- Riesgo de pérdida o dispersión de información importante.

Con una base de datos relacional, estos procesos pueden centralizarse y optimizarse.

---

## 🛍️ Modelo de negocio

**Vive Matcha** ofrece bebidas, snacks y postres saludables directamente al consumidor. El sistema abarca las siguientes áreas:

- Gestión de productos y categorías
- Registro de ventas
- Inventario
- Gestión de clientes y empleados
- Evaluación de productos por parte de los clientes

---

## 🗃️ Tablas de la base de datos

### 1. Clientes
| Campo           | Descripción              | Tipo de dato     | Clave |
|------------------|--------------------------|------------------|-------|
| id_cliente       | ID del cliente           | INT              | PK    |
| nombre           | Nombre completo          | VARCHAR(100)     |       |
| telefono         | Teléfono                 | VARCHAR(20)      |       |
| email            | Correo electrónico       | VARCHAR(100)     |       |
| fecha_registro   | Fecha de registro        | DATE             |       |

---

### 2. Productos
| Campo           | Descripción              | Tipo de dato     | Clave |
|------------------|--------------------------|------------------|-------|
| id_producto      | ID del producto          | INT              | PK    |
| nombre           | Nombre del producto      | VARCHAR(100)     |       |
| descripcion      | Descripción              | TEXT             |       |
| precio           | Precio de venta          | DECIMAL(10,2)    |       |
| stock            | Cantidad disponible      | INT              |       |
| categoria_id     | Categoría del producto   | INT              | FK    |

---

### 3. Categorías
| Campo           | Descripción              | Tipo de dato     | Clave |
|------------------|--------------------------|------------------|-------|
| id_categoria     | ID de la categoría       | INT              | PK    |
| nombre           | Nombre de la categoría   | VARCHAR(100)     |       |
| descripcion      | Descripción              | TEXT             |       |

---

### 4. Empleados
| Campo           | Descripción              | Tipo de dato     | Clave |
|------------------|--------------------------|------------------|-------|
| id_empleado      | ID del empleado          | INT              | PK    |
| nombre           | Nombre                   | VARCHAR(100)     |       |
| cargo            | Cargo o rol              | VARCHAR(50)      |       |
| fecha_ingreso    | Fecha de ingreso         | DATE             |       |
| telefono         | Teléfono                 | VARCHAR(20)      |       |

---

### 5. Ventas
| Campo           | Descripción              | Tipo de dato     | Clave |
|------------------|--------------------------|------------------|-------|
| id_venta         | ID de la venta           | INT              | PK    |
| fecha_venta      | Fecha y hora             | DATETIME         |       |
| id_cliente       | Cliente que realizó la compra | INT         | FK    |
| id_empleado      | Empleado que atendió     | INT              | FK    |
| monto_total      | Total de la venta        | DECIMAL(10,2)    |       |

---

### 6. Detalle de ventas
| Campo           | Descripción              | Tipo de dato     | Clave |
|------------------|--------------------------|------------------|-------|
| id_detalle       | ID del detalle           | INT              | PK    |
| id_venta         | ID de la venta           | INT              | FK    |
| id_producto      | Producto vendido         | INT              | FK    |
| cantidad         | Cantidad vendida         | INT              |       |
| precio_unitario  | Precio por unidad        | DECIMAL(10,2)    |       |

---

### 7. Reseñas
| Campo           | Descripción              | Tipo de dato     | Clave |
|------------------|--------------------------|------------------|-------|
| id_reseña        | ID de la reseña          | INT              | PK    |
| id_cliente       | Cliente que comentó      | INT              | FK    |
| id_producto      | Producto reseñado        | INT              | FK    |
| calificacion     | Puntuación (1 a 5)       | INT              |       |
| comentario       | Opinión escrita          | TEXT             |       |
| fecha_reseña     | Fecha del comentario     | DATETIME         |       |

---

## 💾 Script SQL

Consulta el archivo `Entrega SQL (Vive Matcha).sql` en este repositorio para ver la creación completa de todas las tablas en MySQL.

---

# 📘 Documentación del Proyecto SQL – Vive Matcha

## 🔹 Vistas creadas

| **Nombre de la Vista**   | **Descripción** | **Objetivo** | **Tablas que la componen** |
|---------------------------|-----------------|--------------|----------------------------|
| `vw_DetalleVentas`        | Muestra el detalle completo de las ventas realizadas. | Consultar productos vendidos, cantidades, clientes y empleados. | `Ventas`, `Detalle_Ventas`, `Productos`, `Clientes`, `Empleados` |
| `vw_VentasPorCliente`     | Resumen de todas las ventas agrupadas por cliente. | Analizar comportamiento de compra de cada cliente. | `Ventas`, `Clientes` |
| `vw_VentasPorProducto`    | Total de unidades vendidas y monto generado por producto. | Evaluar los productos más vendidos y su impacto en ingresos. | `Detalle_Ventas`, `Productos` |
| `vw_VentasPorEmpleado`    | Resumen de las ventas registradas por cada empleado. | Medir rendimiento individual de empleados. | `Ventas`, `Empleados` |
| `vw_ReseñasClientes`      | Lista de reseñas de clientes con su información. | Analizar retroalimentación y satisfacción de clientes. | `Clientes`, `Reseñas` |

---

## 🔹 Funciones personalizadas

| **Nombre de la Función** | **Descripción** | **Objetivo** | **Tablas relacionadas** |
|---------------------------|-----------------|--------------|--------------------------|
| `fn_TotalGastadoCliente(idCliente)` | Calcula el monto total gastado por un cliente en todas sus compras. | Medir el valor económico de cada cliente. | `Ventas` |
| `fn_PromedioVentasEmpleado(idEmpleado)` | Devuelve el promedio de ventas registradas por un empleado. | Evaluar desempeño promedio de empleados. | `Ventas` |

---

## 🔹 Stored Procedures

| **Nombre del SP**         | **Descripción** | **Objetivo** | **Tablas afectadas** |
|----------------------------|-----------------|--------------|-----------------------|
| `sp_RegistrarVentaSimple` | Inserta una nueva venta con un solo producto, actualiza stock y total. | Automatizar creación de ventas y su detalle. | `Ventas`, `Detalle_Ventas`, `Productos` |
| `sp_ObtenerHistorialCliente` | Lista todas las compras realizadas por un cliente. | Consultar rápidamente el historial de ventas de un cliente. | `Ventas`, `Clientes` |

---

## 🔹 Triggers

| **Nombre del Trigger**    | **Descripción** | **Funcionalidad** | **Objetivo** | **Tablas/situaciones** |
|----------------------------|-----------------|-------------------|--------------|-------------------------|
| `trg_ActualizarStockVenta` | Disminuye el stock de un producto al insertar un detalle de venta. | Resta cantidad vendida al stock disponible. | Mantener inventario actualizado. | `INSERT` en `Detalle_Ventas` |
| `trg_ActualizarMontoVenta` | Actualiza el campo `monto_total` en la tabla de ventas. | Suma subtotales de productos al total de la venta. | Registrar correctamente el total de cada venta. | `INSERT` en `Detalle_Ventas` |

## conclusiones

Ventas por Método de Pago: Los datos te permiten ver qué métodos de pago son más populares entre los clientes: efectivo, punto de venta, pago móvil y Zelle. Este análisis es útil para la gestión de tesorería y para optimizar los procesos de pago.

Rendimiento de Productos: Con los datos de ventas y la vista vw_Productos_Ventas, puedes identificar los productos más vendidos y los que generan más ingresos. Por ejemplo, si el 'Kit de matcha' es el producto más vendido, puedes enfocar tu inventario y marketing en él.

Análisis de Clientes: La vista vw_Clientes_Compras te permite ver a los clientes que más contribuyen a tus ingresos totales. Este análisis es clave para crear programas de lealtad o campañas de marketing dirigidas.

## 👤 Autor

**Ruben Ferrer**  
Proyecto de SQL – Coderhouse  
**Vive Matcha** | Julio 2025
