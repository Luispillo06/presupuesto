-- ==============================================
-- ESQUEMA DE BASE DE DATOS PARA MARKETMOVE
-- Ejecutar en Supabase SQL Editor
-- ==============================================

-- Habilitar la extensión UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==============================================
-- TABLA: VENTAS
-- ==============================================
CREATE TABLE IF NOT EXISTS ventas (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    cliente VARCHAR(255) NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    productos TEXT[] NOT NULL DEFAULT '{}',
    notas TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para ventas
CREATE INDEX IF NOT EXISTS idx_ventas_user_id ON ventas(user_id);
CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON ventas(fecha);

-- RLS (Row Level Security) para ventas
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuarios pueden ver sus propias ventas"
    ON ventas FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden insertar sus propias ventas"
    ON ventas FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden actualizar sus propias ventas"
    ON ventas FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden eliminar sus propias ventas"
    ON ventas FOR DELETE
    USING (auth.uid() = user_id);

-- ==============================================
-- TABLA: GASTOS
-- ==============================================
CREATE TABLE IF NOT EXISTS gastos (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    concepto VARCHAR(255) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    notas TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para gastos
CREATE INDEX IF NOT EXISTS idx_gastos_user_id ON gastos(user_id);
CREATE INDEX IF NOT EXISTS idx_gastos_fecha ON gastos(fecha);
CREATE INDEX IF NOT EXISTS idx_gastos_categoria ON gastos(categoria);

-- RLS para gastos
ALTER TABLE gastos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuarios pueden ver sus propios gastos"
    ON gastos FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden insertar sus propios gastos"
    ON gastos FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden actualizar sus propios gastos"
    ON gastos FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden eliminar sus propios gastos"
    ON gastos FOR DELETE
    USING (auth.uid() = user_id);

-- ==============================================
-- TABLA: PRODUCTOS
-- ==============================================
CREATE TABLE IF NOT EXISTS productos (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    stock_minimo INTEGER NOT NULL DEFAULT 5,
    categoria VARCHAR(100) NOT NULL,
    codigo_barras VARCHAR(50),
    imagen_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para productos
CREATE INDEX IF NOT EXISTS idx_productos_user_id ON productos(user_id);
CREATE INDEX IF NOT EXISTS idx_productos_nombre ON productos(nombre);
CREATE INDEX IF NOT EXISTS idx_productos_categoria ON productos(categoria);
CREATE INDEX IF NOT EXISTS idx_productos_codigo_barras ON productos(codigo_barras);

-- RLS para productos
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuarios pueden ver sus propios productos"
    ON productos FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden insertar sus propios productos"
    ON productos FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden actualizar sus propios productos"
    ON productos FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden eliminar sus propios productos"
    ON productos FOR DELETE
    USING (auth.uid() = user_id);

-- ==============================================
-- FUNCIONES ÚTILES
-- ==============================================

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para actualizar updated_at
CREATE TRIGGER update_ventas_updated_at
    BEFORE UPDATE ON ventas
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_gastos_updated_at
    BEFORE UPDATE ON gastos
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_productos_updated_at
    BEFORE UPDATE ON productos
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ==============================================
-- VISTAS ÚTILES (OPCIONAL)
-- ==============================================

-- Vista de resumen de ventas por mes
CREATE OR REPLACE VIEW vista_ventas_mensuales AS
SELECT 
    user_id,
    DATE_TRUNC('month', fecha) AS mes,
    COUNT(*) AS total_ventas,
    SUM(monto) AS monto_total
FROM ventas
GROUP BY user_id, DATE_TRUNC('month', fecha)
ORDER BY mes DESC;

-- Vista de resumen de gastos por categoría
CREATE OR REPLACE VIEW vista_gastos_por_categoria AS
SELECT 
    user_id,
    categoria,
    COUNT(*) AS total_gastos,
    SUM(monto) AS monto_total
FROM gastos
GROUP BY user_id, categoria
ORDER BY monto_total DESC;

-- Vista de productos con stock bajo
CREATE OR REPLACE VIEW vista_productos_stock_bajo AS
SELECT *
FROM productos
WHERE stock <= stock_minimo;
