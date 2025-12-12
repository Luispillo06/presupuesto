-- ==============================================
-- ESQUEMA DE BASE DE DATOS PARA PRESUPUESTO MARKETPLACE
-- ⚠️ SOLO CREA - SIN ELIMINAR NADA
-- Para Base de Datos NUEVA de Supabase
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

-- TABLA 5: COMPRAS (Buyer - Vendor)
CREATE TABLE IF NOT EXISTS compras (
    id BIGSERIAL PRIMARY KEY,
    buyer_id UUID NOT NULL,
    vendor_id UUID NOT NULL,
    producto_id BIGINT NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    precio_total DECIMAL(10, 2) NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'pendiente',
    fecha_compra TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_compras_buyer FOREIGN KEY (buyer_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_compras_vendor FOREIGN KEY (vendor_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_compras_producto FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
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
CREATE INDEX IF NOT EXISTS idx_compras_buyer_id ON compras(buyer_id);
CREATE INDEX IF NOT EXISTS idx_compras_vendor_id ON compras(vendor_id);
CREATE INDEX IF NOT EXISTS idx_compras_fecha ON compras(fecha_compra);
CREATE INDEX IF NOT EXISTS idx_compras_estado ON compras(estado);

-- ==============================================
-- HABILITAR ROW LEVEL SECURITY (RLS)
-- ==============================================

ALTER TABLE perfiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;
ALTER TABLE gastos ENABLE ROW LEVEL SECURITY;
ALTER TABLE compras ENABLE ROW LEVEL SECURITY;

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
    USING (auth.uid() = user_id OR stock > 0);

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
    USING (auth.uid() = user_id);

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
    USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden eliminar sus propios gastos"
    ON gastos FOR DELETE
    USING (auth.uid() = user_id);

-- ==============================================
-- POLÍTICAS RLS PARA COMPRAS
-- ==============================================

CREATE POLICY "Compradores ven sus propias compras"
    ON compras FOR SELECT
    USING (auth.uid() = buyer_id);

CREATE POLICY "Vendedores ven sus propias compras recibidas"
    ON compras FOR SELECT
    USING (auth.uid() = vendor_id);

CREATE POLICY "Compradores pueden hacer compras"
    ON compras FOR INSERT
    WITH CHECK (auth.uid() = buyer_id);

CREATE POLICY "Compradores actualizan sus compras"
    ON compras FOR UPDATE
    USING (auth.uid() = buyer_id);

CREATE POLICY "Compradores eliminan sus compras"
    ON compras FOR DELETE
    USING (auth.uid() = buyer_id);

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
-- FUNCIÓN PARA ACTUALIZAR STOCK AL CREAR COMPRA
-- ==============================================

CREATE OR REPLACE FUNCTION public.actualizar_stock_compra()
RETURNS TRIGGER AS $$
BEGIN
    -- Restar stock del producto cuando se crea una compra
    UPDATE productos 
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==============================================
-- FUNCIÓN PARA RESTAURAR STOCK AL CANCELAR COMPRA
-- ==============================================

CREATE OR REPLACE FUNCTION public.restaurar_stock_cancelacion()
RETURNS TRIGGER AS $$
BEGIN
    -- Si la compra se cancela, restaurar el stock
    IF NEW.estado = 'cancelado' AND OLD.estado != 'cancelado' THEN
        UPDATE productos 
        SET stock = stock + OLD.cantidad
        WHERE id = OLD.producto_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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

CREATE TRIGGER trigger_compras_updated_at
    BEFORE UPDATE ON compras
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_actualizar_stock_compra
    AFTER INSERT ON compras
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_stock_compra();

CREATE TRIGGER trigger_restaurar_stock_cancelacion
    BEFORE UPDATE ON compras
    FOR EACH ROW
    EXECUTE FUNCTION restaurar_stock_cancelacion();

-- Trigger para crear perfil automáticamente cuando se registra un usuario
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ==============================================
-- VISTAS ÚTILES PARA REPORTES
-- ==============================================

CREATE OR REPLACE VIEW vista_ventas_mensuales AS
SELECT 
    user_id,
    DATE_TRUNC('month', fecha) AS mes,
    COUNT(*) AS total_ventas,
    SUM(monto) AS monto_total
FROM ventas
GROUP BY user_id, DATE_TRUNC('month', fecha)
ORDER BY mes DESC;

CREATE OR REPLACE VIEW vista_gastos_por_categoria AS
SELECT 
    user_id,
    categoria,
    COUNT(*) AS total_gastos,
    SUM(monto) AS monto_total
FROM gastos
GROUP BY user_id, categoria
ORDER BY monto_total DESC;

CREATE OR REPLACE VIEW vista_productos_stock_bajo AS
SELECT *
FROM productos
WHERE stock <= stock_minimo;

-- ==============================================
-- ✅ SCRIPT COMPLETADO
-- ==============================================
-- Creado:
-- 1. ✅ 5 tablas (perfiles, productos, ventas, gastos, compras)
-- 2. ✅ RLS activado con políticas
-- 3. ✅ Índices para rendimiento
-- 4. ✅ Triggers automáticos
-- 5. ✅ 3 vistas para reportes
-- 6. ✅ Sistema Marketplace (buyer/vendor)
-- ==============================================
