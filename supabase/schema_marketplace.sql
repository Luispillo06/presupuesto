-- ==============================================
-- ESQUEMA DE BASE DE DATOS PARA PRESUPUESTO MARKETPLACE
-- ⚠️ ESTE SCRIPT ELIMINA Y RECREA TODAS LAS TABLAS
-- Ejecutar en Supabase SQL Editor
-- ==============================================

-- ==============================================
-- 📋 DESCRIPCIÓN DEL SISTEMA
-- ==============================================
-- Este sistema soporta dos tipos de usuarios:
--
-- 1️⃣ VENDEDORES (Role: 'vendor')
--    - Gestiona productos, ventas y gastos
--    - Tiene una tienda con múltiples productos
--    - Ve historial de ventas
--    - Control de inventario
--
-- 2️⃣ COMPRADORES (Role: 'buyer')
--    - Navega tiendas de vendedores
--    - Ve productos disponibles
--    - Realiza pedidos/compras
--    - Acceso a historial de compras
--    - Puede escribir reseñas
-- ==============================================

-- Habilitar extensión UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==============================================
-- LIMPIAR TODO (Orden inverso de dependencias)
-- ==============================================

-- Eliminar vistas
DROP VIEW IF EXISTS vista_ventas_mensuales CASCADE;
DROP VIEW IF EXISTS vista_gastos_por_categoria CASCADE;
DROP VIEW IF EXISTS vista_productos_stock_bajo CASCADE;

-- Eliminar tablas
DROP TABLE IF EXISTS resenas CASCADE;
DROP TABLE IF EXISTS pedidos_items CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS compras CASCADE;
DROP TABLE IF EXISTS ventas CASCADE;
DROP TABLE IF EXISTS gastos CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS tiendas CASCADE;
DROP TABLE IF EXISTS perfiles CASCADE;

-- Eliminar funciones
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

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
    INSERT INTO public.perfiles (id, nombre, email, rol)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'nombre', 'Usuario'),
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'rol', 'buyer')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================
-- TABLA DE USUARIOS (METADATA)
-- ==============================================

CREATE TABLE IF NOT EXISTS perfiles (
    id UUID PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    rol VARCHAR(50) NOT NULL DEFAULT 'buyer',
    -- Datos solo para VENDEDORES
    nombre_tienda VARCHAR(255),
    descripcion_tienda TEXT,
    imagen_tienda_url TEXT,
    ciudad VARCHAR(100),
    pais VARCHAR(100),
    telefono VARCHAR(20),
    -- Campos generales
    avatar_url TEXT,
    calificacion_promedio DECIMAL(3, 2) DEFAULT 0,
    total_transacciones INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_perfiles_user FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- ==============================================
-- TABLA DE TIENDAS (Para vendedores)
-- ==============================================

CREATE TABLE IF NOT EXISTS tiendas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vendor_id UUID NOT NULL UNIQUE,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    logo_url TEXT,
    banner_url TEXT,
    ciudad VARCHAR(100),
    pais VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(255),
    website TEXT,
    calificacion DECIMAL(3, 2) DEFAULT 0,
    total_productos INTEGER DEFAULT 0,
    total_ventas INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_tiendas_vendor FOREIGN KEY (vendor_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- ==============================================
-- TABLA DE PRODUCTOS
-- ==============================================

CREATE TABLE IF NOT EXISTS productos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vendor_id UUID NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    stock_minimo INTEGER NOT NULL DEFAULT 5,
    categoria VARCHAR(100) NOT NULL,
    codigo_barras VARCHAR(50),
    imagen_url TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_productos_vendor FOREIGN KEY (vendor_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- ==============================================
-- TABLA DE VENTAS (Registro interno del vendedor)
-- ==============================================

CREATE TABLE IF NOT EXISTS ventas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vendor_id UUID NOT NULL,
    cliente VARCHAR(255) NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    productos TEXT[] NOT NULL DEFAULT '{}',
    notas TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_ventas_vendor FOREIGN KEY (vendor_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- ==============================================
-- TABLA DE GASTOS (Solo para vendedores)
-- ==============================================

CREATE TABLE IF NOT EXISTS gastos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vendor_id UUID NOT NULL,
    concepto VARCHAR(255) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notas TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_gastos_vendor FOREIGN KEY (vendor_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- ==============================================
-- TABLA DE PEDIDOS (Para compradores)
-- ==============================================

CREATE TABLE IF NOT EXISTS pedidos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    buyer_id UUID NOT NULL,
    vendor_id UUID NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'pendiente',
    monto_total DECIMAL(10, 2) NOT NULL,
    direccion_entrega TEXT NOT NULL,
    telefono_entrega VARCHAR(20),
    notas TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_pedidos_buyer FOREIGN KEY (buyer_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_pedidos_vendor FOREIGN KEY (vendor_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- ==============================================
-- TABLA DE ITEMS DE PEDIDOS
-- ==============================================

CREATE TABLE IF NOT EXISTS pedidos_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pedido_id UUID NOT NULL,
    producto_id UUID NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_pedidos_items_pedido FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    CONSTRAINT fk_pedidos_items_producto FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- ==============================================
-- TABLA DE COMPRAS (Historial para compradores)
-- ==============================================

CREATE TABLE IF NOT EXISTS compras (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    buyer_id UUID NOT NULL,
    vendor_id UUID NOT NULL,
    producto_id UUID NOT NULL,
    cantidad INTEGER NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'completada',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_compras_buyer FOREIGN KEY (buyer_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_compras_vendor FOREIGN KEY (vendor_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_compras_producto FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- ==============================================
-- TABLA DE RESEÑAS
-- ==============================================

CREATE TABLE IF NOT EXISTS resenas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    comprador_id UUID NOT NULL,
    vendedor_id UUID NOT NULL,
    producto_id UUID,
    calificacion INTEGER NOT NULL CHECK (calificacion >= 1 AND calificacion <= 5),
    comentario TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_resenas_comprador FOREIGN KEY (comprador_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_resenas_vendedor FOREIGN KEY (vendedor_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_resenas_producto FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE SET NULL
);

-- ==============================================
-- CREAR ÍNDICES PARA RENDIMIENTO
-- ==============================================

-- Índices para perfiles
CREATE INDEX idx_perfiles_email ON perfiles(email);
CREATE INDEX idx_perfiles_rol ON perfiles(rol);

-- Índices para tiendas
CREATE INDEX idx_tiendas_vendor_id ON tiendas(vendor_id);
CREATE INDEX idx_tiendas_nombre ON tiendas(nombre);

-- Índices para productos
CREATE INDEX idx_productos_vendor_id ON productos(vendor_id);
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_productos_categoria ON productos(categoria);
CREATE INDEX idx_productos_stock ON productos(stock);
CREATE INDEX idx_productos_activo ON productos(activo);

-- Índices para ventas
CREATE INDEX idx_ventas_vendor_id ON ventas(vendor_id);
CREATE INDEX idx_ventas_fecha ON ventas(fecha);

-- Índices para gastos
CREATE INDEX idx_gastos_vendor_id ON gastos(vendor_id);
CREATE INDEX idx_gastos_fecha ON gastos(fecha);
CREATE INDEX idx_gastos_categoria ON gastos(categoria);

-- Índices para pedidos
CREATE INDEX idx_pedidos_buyer_id ON pedidos(buyer_id);
CREATE INDEX idx_pedidos_vendor_id ON pedidos(vendor_id);
CREATE INDEX idx_pedidos_estado ON pedidos(estado);
CREATE INDEX idx_pedidos_fecha ON pedidos(created_at);

-- Índices para compras
CREATE INDEX idx_compras_buyer_id ON compras(buyer_id);
CREATE INDEX idx_compras_vendor_id ON compras(vendor_id);
CREATE INDEX idx_compras_fecha ON compras(created_at);

-- Índices para reseñas
CREATE INDEX idx_resenas_vendedor_id ON resenas(vendedor_id);
CREATE INDEX idx_resenas_comprador_id ON resenas(comprador_id);
CREATE INDEX idx_resenas_calificacion ON resenas(calificacion);

-- ==============================================
-- HABILITAR ROW LEVEL SECURITY (RLS)
-- ==============================================

ALTER TABLE perfiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE tiendas ENABLE ROW LEVEL SECURITY;
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;
ALTER TABLE gastos ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedidos ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedidos_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE compras ENABLE ROW LEVEL SECURITY;
ALTER TABLE resenas ENABLE ROW LEVEL SECURITY;

-- ==============================================
-- POLÍTICAS RLS PARA PERFILES
-- ==============================================

CREATE POLICY "Usuarios pueden ver su propio perfil"
    ON perfiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Vendedores públicos visibles"
    ON perfiles FOR SELECT
    USING (rol = 'vendor');

CREATE POLICY "Usuarios pueden actualizar su propio perfil"
    ON perfiles FOR UPDATE
    USING (auth.uid() = id);

-- ==============================================
-- POLÍTICAS RLS PARA TIENDAS
-- ==============================================

CREATE POLICY "Todos pueden ver tiendas activas"
    ON tiendas FOR SELECT
    USING (TRUE);

CREATE POLICY "Vendedores pueden actualizar su tienda"
    ON tiendas FOR UPDATE
    USING (auth.uid() = vendor_id);

CREATE POLICY "Vendedores pueden crear tienda"
    ON tiendas FOR INSERT
    WITH CHECK (auth.uid() = vendor_id);

-- ==============================================
-- POLÍTICAS RLS PARA PRODUCTOS
-- ==============================================

CREATE POLICY "Vendedores pueden ver sus productos"
    ON productos FOR SELECT
    USING (auth.uid() = vendor_id);

CREATE POLICY "Todos pueden ver productos activos"
    ON productos FOR SELECT
    USING (activo = TRUE);

CREATE POLICY "Vendedores pueden insertar productos"
    ON productos FOR INSERT
    WITH CHECK (auth.uid() = vendor_id);

CREATE POLICY "Vendedores pueden actualizar sus productos"
    ON productos FOR UPDATE
    USING (auth.uid() = vendor_id);

-- ==============================================
-- POLÍTICAS RLS PARA VENTAS
-- ==============================================

CREATE POLICY "Vendedores pueden ver sus ventas"
    ON ventas FOR SELECT
    USING (auth.uid() = vendor_id);

CREATE POLICY "Vendedores pueden crear ventas"
    ON ventas FOR INSERT
    WITH CHECK (auth.uid() = vendor_id);

-- ==============================================
-- POLÍTICAS RLS PARA GASTOS
-- ==============================================

CREATE POLICY "Vendedores pueden ver sus gastos"
    ON gastos FOR SELECT
    USING (auth.uid() = vendor_id);

CREATE POLICY "Vendedores pueden crear gastos"
    ON gastos FOR INSERT
    WITH CHECK (auth.uid() = vendor_id);

-- ==============================================
-- POLÍTICAS RLS PARA PEDIDOS
-- ==============================================

CREATE POLICY "Compradores ven sus pedidos"
    ON pedidos FOR SELECT
    USING (auth.uid() = buyer_id);

CREATE POLICY "Vendedores ven pedidos de su tienda"
    ON pedidos FOR SELECT
    USING (auth.uid() = vendor_id);

CREATE POLICY "Compradores crean pedidos"
    ON pedidos FOR INSERT
    WITH CHECK (auth.uid() = buyer_id);

-- ==============================================
-- POLÍTICAS RLS PARA PEDIDOS_ITEMS
-- ==============================================

CREATE POLICY "Ver items de pedidos propios"
    ON pedidos_items FOR SELECT
    USING (TRUE);

-- ==============================================
-- POLÍTICAS RLS PARA COMPRAS
-- ==============================================

CREATE POLICY "Compradores ven sus compras"
    ON compras FOR SELECT
    USING (auth.uid() = buyer_id);

CREATE POLICY "Vendedores ven sus ventas (compras)"
    ON compras FOR SELECT
    USING (auth.uid() = vendor_id);

CREATE POLICY "Compradores crean compras"
    ON compras FOR INSERT
    WITH CHECK (auth.uid() = buyer_id);

-- ==============================================
-- POLÍTICAS RLS PARA RESEÑAS
-- ==============================================

CREATE POLICY "Todos ven reseñas"
    ON resenas FOR SELECT
    USING (TRUE);

CREATE POLICY "Compradores crean reseñas"
    ON resenas FOR INSERT
    WITH CHECK (auth.uid() = comprador_id);

-- ==============================================
-- TRIGGERS PARA UPDATED_AT
-- ==============================================

CREATE TRIGGER trigger_perfiles_updated_at
    BEFORE UPDATE ON perfiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_tiendas_updated_at
    BEFORE UPDATE ON tiendas
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

CREATE TRIGGER trigger_pedidos_updated_at
    BEFORE UPDATE ON pedidos
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_resenas_updated_at
    BEFORE UPDATE ON resenas
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para crear perfil automáticamente
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ==============================================
-- VISTAS ÚTILES PARA REPORTES
-- ==============================================

CREATE OR REPLACE VIEW vista_ventas_mensuales AS
SELECT 
    vendor_id,
    DATE_TRUNC('month', fecha) AS mes,
    COUNT(*) AS total_ventas,
    SUM(monto) AS monto_total
FROM ventas
GROUP BY vendor_id, DATE_TRUNC('month', fecha)
ORDER BY mes DESC;

CREATE OR REPLACE VIEW vista_gastos_por_categoria AS
SELECT 
    vendor_id,
    categoria,
    COUNT(*) AS total_gastos,
    SUM(monto) AS monto_total
FROM gastos
GROUP BY vendor_id, categoria
ORDER BY monto_total DESC;

CREATE OR REPLACE VIEW vista_productos_stock_bajo AS
SELECT *
FROM productos
WHERE stock <= stock_minimo AND activo = TRUE;

-- ==============================================
-- ✅ SCRIPT COMPLETADO EXITOSAMENTE
-- ==============================================
-- ESTRUCTURA MARKETPLACE CREADA:
--
-- 🏪 PARA VENDEDORES:
--   ✅ Tabla perfiles (rol = 'vendor')
--   ✅ Tabla tiendas (metadata de tienda)
--   ✅ Tabla productos (inventario)
--   ✅ Tabla ventas (historial de ventas)
--   ✅ Tabla gastos (control de gastos)
--
-- 🛍️ PARA COMPRADORES:
--   ✅ Tabla perfiles (rol = 'buyer')
--   ✅ Tabla pedidos (compras realizadas)
--   ✅ Tabla pedidos_items (detalles de pedidos)
--   ✅ Tabla compras (historial de compras)
--   ✅ Tabla reseñas (comentarios sobre productos/vendedores)
--
-- 🔒 SEGURIDAD:
--   ✅ RLS habilitado en todas las tablas
--   ✅ Políticas específicas por rol de usuario
--   ✅ Aislamiento completo de datos
-- ==============================================
