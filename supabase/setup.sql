-- ============================================
-- SQL PARA MARKETMOVE APP - SUPABASE
-- ============================================
-- Ejecuta este script completo en el SQL Editor de Supabase
-- https://app.supabase.com -> SQL Editor -> New Query

-- ============================================
-- 1. CREAR TABLA: VENTAS
-- ============================================
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

-- Crear índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_ventas_usuario_id ON ventas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON ventas(fecha);

-- ============================================
-- 2. CREAR TABLA: GASTOS
-- ============================================
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

-- Crear índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_gastos_usuario_id ON gastos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_gastos_fecha ON gastos(fecha);

-- ============================================
-- 3. CREAR TABLA: PRODUCTOS
-- ============================================
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

-- Crear índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_productos_usuario_id ON productos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_productos_nombre ON productos(nombre);

-- ============================================
-- 4. HABILITAR ROW LEVEL SECURITY (RLS)
-- ============================================

-- Habilitar RLS en tabla ventas
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;

-- Políticas para ventas
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

-- Habilitar RLS en tabla gastos
ALTER TABLE gastos ENABLE ROW LEVEL SECURITY;

-- Políticas para gastos
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

-- Habilitar RLS en tabla productos
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;

-- Políticas para productos
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

-- ============================================
-- 5. CREAR FUNCIONES PARA ACTUALIZAR TIMESTAMP
-- ============================================

-- Función para actualizar updated_at en ventas
CREATE OR REPLACE FUNCTION update_ventas_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para ventas
DROP TRIGGER IF EXISTS ventas_update_trigger ON ventas;
CREATE TRIGGER ventas_update_trigger
BEFORE UPDATE ON ventas
FOR EACH ROW
EXECUTE FUNCTION update_ventas_updated_at();

-- Función para actualizar updated_at en gastos
CREATE OR REPLACE FUNCTION update_gastos_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para gastos
DROP TRIGGER IF EXISTS gastos_update_trigger ON gastos;
CREATE TRIGGER gastos_update_trigger
BEFORE UPDATE ON gastos
FOR EACH ROW
EXECUTE FUNCTION update_gastos_updated_at();

-- Función para actualizar updated_at en productos
CREATE OR REPLACE FUNCTION update_productos_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para productos
DROP TRIGGER IF EXISTS productos_update_trigger ON productos;
CREATE TRIGGER productos_update_trigger
BEFORE UPDATE ON productos
FOR EACH ROW
EXECUTE FUNCTION update_productos_updated_at();

-- ============================================
-- 6. DATOS DE PRUEBA (OPCIONAL)
-- ============================================

-- Nota: Para insertar datos de prueba, necesitas el usuario_id real
-- Descomenta y usa tu uuid cuando tengas un usuario creado

-- INSERT INTO ventas (usuario_id, monto, descripcion, categoria, fecha)
-- VALUES (
--   'TU_UUID_AQUI',
--   150.50,
--   'Venta de productos',
--   'General',
--   CURRENT_DATE
-- );

-- INSERT INTO gastos (usuario_id, monto, descripcion, categoria, fecha)
-- VALUES (
--   'TU_UUID_AQUI',
--   45.00,
--   'Compra de stock',
--   'Compras',
--   CURRENT_DATE
-- );

-- INSERT INTO productos (usuario_id, nombre, precio_venta, precio_costo, stock_actual, categoria)
-- VALUES (
--   'TU_UUID_AQUI',
--   'Producto de Prueba',
--   100.00,
--   50.00,
--   10,
--   'General'
-- );

-- ============================================
-- FIN DEL SCRIPT SQL
-- ============================================
