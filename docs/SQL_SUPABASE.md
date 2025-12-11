# 🔧 GUÍA RÁPIDA: EJECUTAR SQL EN SUPABASE

## ✅ PASOS A SEGUIR

### 1. Abre Supabase
- Ve a: https://app.supabase.com
- Inicia sesión con tu cuenta
- Selecciona tu proyecto

### 2. Ve a SQL Editor
```
Panel izquierdo → SQL Editor → New Query
```

### 3. Copia TODO el SQL
El SQL está en el archivo: `supabase/setup.sql`

**O copia el SQL de abajo (más corto, versión mínima):**

---

## 📋 SQL MÍNIMO (Copia y pega esto)

```sql
-- Crear tabla VENTAS
CREATE TABLE IF NOT EXISTS ventas (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  monto DECIMAL(10, 2) NOT NULL,
  descripcion TEXT,
  categoria VARCHAR(50),
  fecha DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear tabla GASTOS
CREATE TABLE IF NOT EXISTS gastos (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  monto DECIMAL(10, 2) NOT NULL,
  descripcion TEXT,
  categoria VARCHAR(50),
  fecha DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear tabla PRODUCTOS
CREATE TABLE IF NOT EXISTS productos (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  precio_venta DECIMAL(10, 2) NOT NULL,
  precio_costo DECIMAL(10, 2),
  stock_actual INT DEFAULT 0,
  stock_minimo INT DEFAULT 5,
  categoria VARCHAR(50),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS en VENTAS
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own ventas"
  ON ventas FOR SELECT
  USING (auth.uid() = usuario_id);

CREATE POLICY "Users can insert own ventas"
  ON ventas FOR INSERT
  WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Users can update own ventas"
  ON ventas FOR UPDATE
  USING (auth.uid() = usuario_id);

CREATE POLICY "Users can delete own ventas"
  ON ventas FOR DELETE
  USING (auth.uid() = usuario_id);

-- Habilitar RLS en GASTOS
ALTER TABLE gastos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own gastos"
  ON gastos FOR SELECT
  USING (auth.uid() = usuario_id);

CREATE POLICY "Users can insert own gastos"
  ON gastos FOR INSERT
  WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Users can update own gastos"
  ON gastos FOR UPDATE
  USING (auth.uid() = usuario_id);

CREATE POLICY "Users can delete own gastos"
  ON gastos FOR DELETE
  USING (auth.uid() = usuario_id);

-- Habilitar RLS en PRODUCTOS
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own productos"
  ON productos FOR SELECT
  USING (auth.uid() = usuario_id);

CREATE POLICY "Users can insert own productos"
  ON productos FOR INSERT
  WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Users can update own productos"
  ON productos FOR UPDATE
  USING (auth.uid() = usuario_id);

CREATE POLICY "Users can delete own productos"
  ON productos FOR DELETE
  USING (auth.uid() = usuario_id);
```

---

## 🚀 4. Ejecuta el SQL

1. **Pega el SQL** en el editor de Supabase
2. Haz clic en: **RUN** (botón azul arriba a la derecha)
3. ¡Espera a que termine!

---

## ✅ ¿Funcionó?

### Verifica que se crearon las tablas:
1. Panel izquierdo → **Table Editor**
2. Deberías ver:
   - ✅ `ventas`
   - ✅ `gastos`
   - ✅ `productos`

### Si ves las 3 tablas = ¡ÉXITO! ✨

---

## 🎯 QUÉ HACE EL SQL

| Parte | Función |
|-------|---------|
| `CREATE TABLE` | Crea las 3 tablas necesarias |
| `REFERENCES auth.users` | Vincula cada registro al usuario |
| `ON DELETE CASCADE` | Si se elimina el usuario, se eliminan sus datos |
| `ALTER TABLE ... ENABLE RLS` | Activa seguridad a nivel de filas |
| `CREATE POLICY` | Cada usuario solo ve/modifica sus datos |

---

## 📊 ESTRUCTURA DE DATOS

### Tabla: VENTAS
```
id (autoincremental)
usuario_id (relación con usuario)
monto (cantidad vendida)
descripcion (detalle)
categoria (tipo)
fecha (cuándo)
created_at (fecha creación)
updated_at (última modificación)
```

### Tabla: GASTOS
```
id (autoincremental)
usuario_id (relación con usuario)
monto (cantidad gastada)
descripcion (detalle)
categoria (tipo)
fecha (cuándo)
created_at (fecha creación)
updated_at (última modificación)
```

### Tabla: PRODUCTOS
```
id (autoincremental)
usuario_id (relación con usuario)
nombre (nombre del producto)
descripcion (detalle)
precio_venta (precio de venta)
precio_costo (precio de compra)
stock_actual (unidades disponibles)
stock_minimo (alertas si baja de esto)
categoria (tipo)
created_at (fecha creación)
updated_at (última modificación)
```

---

## 🔒 SEGURIDAD

Las políticas RLS (Row Level Security) garantizan que:

✅ Cada usuario **solo ve sus propios datos**  
✅ Cada usuario **solo puede modificar sus datos**  
✅ No hay posibilidad de acceder datos de otros usuarios  
✅ Los datos están **completamente aislados**  

---

## 🐛 ERRORES COMUNES

### Error: "relation already exists"
**Solución:** Las tablas ya existen. Puedes borrarlas primero o usar `CREATE TABLE IF NOT EXISTS`

### Error: "permission denied"
**Solución:** Asegúrate de estar en el rol correcto (admin) en Supabase

### Error en RLS
**Solución:** Las tablas deben existir primero. Ejecuta el `CREATE TABLE` antes

---

## ✨ PRÓXIMO PASO

Una vez ejecutado el SQL:

1. ✅ Crea un usuario en la app (register)
2. ✅ El usuario_id se guardará automáticamente
3. ✅ Podrás insertar ventas, gastos, productos
4. ✅ Solo verás tus propios datos

---

## 📞 AYUDA

Si algo falla:
1. Copia el SQL exacto de `supabase/setup.sql`
2. Ejecutalo en Supabase SQL Editor
3. Verifica en Table Editor que existan las 3 tablas

**¡Listo!** Ya puedes empezar a trabajar con la base de datos.

---

**Última actualización:** 11 de diciembre de 2025  
**Estado:** ✅ Listo para usar
