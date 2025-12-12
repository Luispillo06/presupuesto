-- ==============================================
-- ELIMINACIÓN COMPLETA DE ESQUEMA ANTERIOR
-- ⚠️ BORRA TODO - EJECUTAR PRIMERO
-- ==============================================

-- Desactivar RLS temporalmente para poder eliminar todo
ALTER TABLE IF EXISTS perfiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS productos DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS ventas DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS gastos DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS compras DISABLE ROW LEVEL SECURITY;

-- Eliminar VISTAS primero (porque dependen de las tablas)
DROP VIEW IF EXISTS vista_resumen_usuario CASCADE;
DROP VIEW IF EXISTS vista_balance_vendedor CASCADE;
DROP VIEW IF EXISTS vista_productos_stock_bajo CASCADE;
DROP VIEW IF EXISTS vista_gastos_por_categoria CASCADE;
DROP VIEW IF EXISTS vista_ventas_mensuales CASCADE;

-- Eliminar TRIGGERS
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP TRIGGER IF EXISTS trigger_gastos_updated_at ON gastos;
DROP TRIGGER IF EXISTS trigger_ventas_updated_at ON ventas;
DROP TRIGGER IF EXISTS trigger_productos_updated_at ON productos;
DROP TRIGGER IF EXISTS trigger_perfiles_updated_at ON perfiles;
DROP TRIGGER IF EXISTS trigger_compras_updated_at ON compras;

-- Eliminar FUNCIONES (con CASCADE para eliminar dependencias)
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- Eliminar TABLAS
DROP TABLE IF EXISTS compras CASCADE;
DROP TABLE IF EXISTS gastos CASCADE;
DROP TABLE IF EXISTS ventas CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS perfiles CASCADE;

-- ==============================================
-- AHORA CREAR TODO LIMPIO
-- ==============================================

-- Habilitar extensión UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==============================================
-- CREAR TABLAS
-- ==============================================

-- TABLA 1: PERFILES
CREATE TABLE IF NOT EXISTS perfiles (
    id UUID PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_perfiles_user FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- TABLA 2: PRODUCTOS
CREATE TABLE IF NOT EXISTS productos (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    stock_minimo INTEGER NOT NULL DEFAULT 5,
    categoria VARCHAR(100) NOT NULL,
    codigo_barras VARCHAR(50),
    imagen_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_productos_user FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- TABLA 3: VENTAS
CREATE TABLE IF NOT EXISTS ventas (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    cliente VARCHAR(255) NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    productos TEXT[] NOT NULL DEFAULT '{}',
    notas TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_ventas_user FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- TABLA 4: GASTOS
CREATE TABLE IF NOT EXISTS gastos (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    concepto VARCHAR(255) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notas TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_gastos_user FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- ==============================================
-- CREAR ÍNDICES PARA RENDIMIENTO
-- ==============================================

CREATE INDEX IF NOT EXISTS idx_perfiles_email ON perfiles(email);
CREATE INDEX IF NOT EXISTS idx_productos_user_id ON productos(user_id);
CREATE INDEX IF NOT EXISTS idx_productos_nombre ON productos(nombre);
CREATE INDEX IF NOT EXISTS idx_productos_categoria ON productos(categoria);
CREATE INDEX IF NOT EXISTS idx_productos_stock ON productos(stock);
CREATE INDEX IF NOT EXISTS idx_ventas_user_id ON ventas(user_id);
CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON ventas(fecha);
CREATE INDEX IF NOT EXISTS idx_gastos_user_id ON gastos(user_id);
CREATE INDEX IF NOT EXISTS idx_gastos_fecha ON gastos(fecha);
CREATE INDEX IF NOT EXISTS idx_gastos_categoria ON gastos(categoria);

-- ==============================================
-- HABILITAR ROW LEVEL SECURITY (RLS)
-- ==============================================

ALTER TABLE perfiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;
ALTER TABLE gastos ENABLE ROW LEVEL SECURITY;

-- ==============================================
-- POLÍTICAS RLS PARA PERFILES
-- ==============================================

CREATE POLICY "Usuarios pueden ver su propio perfil"
    ON perfiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Usuarios pueden insertar su propio perfil"
    ON perfiles FOR INSERT
    WITH CHECK (auth.uid() = id);

CREATE POLICY "Usuarios pueden actualizar su propio perfil"
    ON perfiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Usuarios pueden eliminar su propio perfil"
    ON perfiles FOR DELETE
    USING (auth.uid() = id);

-- ==============================================
-- POLÍTICAS RLS PARA PRODUCTOS
-- ==============================================

CREATE POLICY "Usuarios pueden ver sus propios productos"
    ON productos FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden insertar sus propios productos"
    ON productos FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden actualizar sus propios productos"
    ON productos FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden eliminar sus propios productos"
    ON productos FOR DELETE
    USING (auth.uid() = user_id);

-- ==============================================
-- POLÍTICAS RLS PARA VENTAS
-- ==============================================

CREATE POLICY "Usuarios pueden ver sus propias ventas"
    ON ventas FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden insertar sus propias ventas"
    ON ventas FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden actualizar sus propias ventas"
    ON ventas FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden eliminar sus propias ventas"
    ON ventas FOR DELETE
    USING (auth.uid() = user_id);

-- ==============================================
-- POLÍTICAS RLS PARA GASTOS
-- ==============================================

CREATE POLICY "Usuarios pueden ver sus propios gastos"
    ON gastos FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden insertar sus propios gastos"
    ON gastos FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden actualizar sus propios gastos"
    ON gastos FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden eliminar sus propios gastos"
    ON gastos FOR DELETE
    USING (auth.uid() = user_id);

-- ==============================================
-- FUNCIÓN PARA UPDATED_AT AUTOMÁTICO
-- ==============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==============================================
-- FUNCIÓN PARA CREAR PERFIL AUTOMÁTICAMENTE
-- ==============================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.perfiles (id, nombre, email)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'nombre', 'Usuario'),
        NEW.email
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================
-- TRIGGERS PARA UPDATED_AT
-- ==============================================

CREATE TRIGGER trigger_perfiles_updated_at
    BEFORE UPDATE ON perfiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_productos_updated_at
    BEFORE UPDATE ON productos
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_ventas_updated_at
    BEFORE UPDATE ON ventas
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_gastos_updated_at
    BEFORE UPDATE ON gastos
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para crear perfil automáticamente cuando se registra un usuario
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ==============================================
-- VISTAS PARA REPORTES Y ANÁLISIS
-- ==============================================

-- Vista: Ventas mensuales
CREATE OR REPLACE VIEW vista_ventas_mensuales AS
SELECT 
    user_id,
    DATE_TRUNC('month', fecha) AS mes,
    COUNT(*) AS total_ventas,
    SUM(monto) AS monto_total
FROM ventas
GROUP BY user_id, DATE_TRUNC('month', fecha)
ORDER BY mes DESC;

-- Vista: Gastos por categoría
CREATE OR REPLACE VIEW vista_gastos_por_categoria AS
SELECT 
    user_id,
    categoria,
    COUNT(*) AS total_gastos,
    SUM(monto) AS monto_total
FROM gastos
GROUP BY user_id, categoria
ORDER BY monto_total DESC;

-- Vista: Productos con stock bajo
CREATE OR REPLACE VIEW vista_productos_stock_bajo AS
SELECT *
FROM productos
WHERE stock <= stock_minimo;

-- Vista: Balance de ganancia - gasto
CREATE OR REPLACE VIEW vista_balance_vendedor AS
SELECT 
    COALESCE(v.user_id, g.user_id) AS user_id,
    COALESCE(DATE_TRUNC('day', v.fecha), DATE_TRUNC('day', g.fecha))::DATE AS fecha,
    COALESCE(SUM(v.monto), 0) AS total_ventas,
    COALESCE(SUM(g.monto), 0) AS total_gastos,
    COALESCE(SUM(v.monto), 0) - COALESCE(SUM(g.monto), 0) AS balance
FROM ventas v
FULL OUTER JOIN gastos g ON v.user_id = g.user_id 
    AND DATE_TRUNC('day', v.fecha) = DATE_TRUNC('day', g.fecha)
GROUP BY COALESCE(v.user_id, g.user_id), DATE_TRUNC('day', v.fecha), DATE_TRUNC('day', g.fecha)
ORDER BY fecha DESC;

-- Vista: Resumen total por usuario
CREATE OR REPLACE VIEW vista_resumen_usuario AS
SELECT 
    COALESCE(v.user_id, g.user_id) AS user_id,
    COALESCE(SUM(v.monto), 0) AS total_ganancias,
    COALESCE(SUM(g.monto), 0) AS total_gastos,
    COALESCE(SUM(v.monto), 0) - COALESCE(SUM(g.monto), 0) AS balance_neto,
    COUNT(DISTINCT v.id) AS total_ventas,
    COUNT(DISTINCT g.id) AS total_gastos_registrados
FROM ventas v
FULL OUTER JOIN gastos g ON v.user_id = g.user_id
GROUP BY COALESCE(v.user_id, g.user_id);

-- ==============================================
-- ✅ BASE DE DATOS COMPLETAMENTE LIMPIA Y LISTA
-- ==============================================
-- TODO LO ANTERIOR HA SIDO ELIMINADO
-- Tablas nuevas creadas:
-- 1. ✅ perfiles
-- 2. ✅ productos
-- 3. ✅ ventas
-- 4. ✅ gastos
-- ==============================================
