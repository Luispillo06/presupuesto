-- =====================================================
-- SCHEMA CRM - Mini-CRM para SoftControl
-- Gestión de Clientes, Licencias y Suscripciones
-- =====================================================
-- ⚠️ ESTE SCRIPT ELIMINA TODAS LAS TABLAS EXISTENTES
-- Y CREA SOLO LAS TABLAS DEL CRM
-- Ejecutar en Supabase SQL Editor
-- =====================================================

-- Habilitar la extensión UUID si no existe
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 🗑️ ELIMINAR TODAS LAS TABLAS EXISTENTES
-- =====================================================

-- Eliminar vistas del sistema anterior
DROP VIEW IF EXISTS vista_ventas_mensuales CASCADE;
DROP VIEW IF EXISTS vista_gastos_por_categoria CASCADE;
DROP VIEW IF EXISTS vista_productos_stock_bajo CASCADE;

-- Eliminar tablas del CRM (si existen)
DROP TABLE IF EXISTS licenses CASCADE;
DROP TABLE IF EXISTS crm_products CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;

-- Eliminar tablas del marketplace anterior
DROP TABLE IF EXISTS resenas CASCADE;
DROP TABLE IF EXISTS pedidos_items CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS compras CASCADE;
DROP TABLE IF EXISTS ventas CASCADE;
DROP TABLE IF EXISTS gastos CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS tiendas CASCADE;
DROP TABLE IF EXISTS perfiles CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- Eliminar funciones anteriores
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

-- =====================================================
-- TABLA: profiles
-- Perfiles de usuarios (vinculados a auth.users)
-- =====================================================
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'staff' CHECK (role IN ('admin', 'staff')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABLA: clients
-- Clientes del CRM
-- =====================================================
CREATE TABLE clients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    company TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES profiles(id) ON DELETE SET NULL
);

-- =====================================================
-- TABLA: crm_products
-- Productos del CRM (separado de productos del marketplace)
-- =====================================================
CREATE TABLE crm_products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    price_one_payment NUMERIC(10, 2) DEFAULT 0,
    price_subscription NUMERIC(10, 2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABLA: licenses
-- Licencias asignadas a clientes
-- =====================================================
CREATE TABLE licenses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES crm_products(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('licencia_unica', 'suscripcion')),
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE, -- NULL para licencias únicas permanentes
    status TEXT NOT NULL DEFAULT 'activa' CHECK (status IN ('activa', 'inactiva', 'pendiente_pago')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- ÍNDICES para mejorar rendimiento
-- =====================================================
CREATE INDEX idx_clients_created_by ON clients(created_by);
CREATE INDEX idx_licenses_client_id ON licenses(client_id);
CREATE INDEX idx_licenses_product_id ON licenses(product_id);
CREATE INDEX idx_licenses_status ON licenses(status);

-- =====================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Habilitar RLS en todas las tablas
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE licenses ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLÍTICAS para PROFILES
-- =====================================================

-- Política: Usuarios autenticados pueden ver perfiles
CREATE POLICY "Users can view all profiles"
    ON profiles FOR SELECT
    TO authenticated
    USING (true);

-- Política: Solo admins pueden insertar perfiles
CREATE POLICY "Admins can insert profiles"
    ON profiles FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
        OR auth.uid() = id -- Permitir crear su propio perfil
    );

-- Política: Solo admins pueden actualizar perfiles
CREATE POLICY "Admins can update profiles"
    ON profiles FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
        OR id = auth.uid() -- Permitir actualizar su propio perfil
    );

-- =====================================================
-- POLÍTICAS para CLIENTS
-- =====================================================

-- Política: Usuarios autenticados pueden ver clientes
CREATE POLICY "Authenticated users can view clients"
    ON clients FOR SELECT
    TO authenticated
    USING (true);

-- Política: Solo admins pueden insertar clientes
CREATE POLICY "Admins can insert clients"
    ON clients FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Política: Solo admins pueden actualizar clientes
CREATE POLICY "Admins can update clients"
    ON clients FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Política: Solo admins pueden eliminar clientes
CREATE POLICY "Admins can delete clients"
    ON clients FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =====================================================
-- POLÍTICAS para CRM_PRODUCTS
-- =====================================================

-- Política: Usuarios autenticados pueden ver productos
CREATE POLICY "Authenticated users can view products"
    ON crm_products FOR SELECT
    TO authenticated
    USING (true);

-- Política: Solo admins pueden insertar productos
CREATE POLICY "Admins can insert products"
    ON crm_products FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Política: Solo admins pueden actualizar productos
CREATE POLICY "Admins can update products"
    ON crm_products FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Política: Solo admins pueden eliminar productos
CREATE POLICY "Admins can delete products"
    ON crm_products FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =====================================================
-- POLÍTICAS para LICENSES
-- =====================================================

-- Política: Usuarios autenticados pueden ver licencias
CREATE POLICY "Authenticated users can view licenses"
    ON licenses FOR SELECT
    TO authenticated
    USING (true);

-- Política: Solo admins pueden insertar licencias
CREATE POLICY "Admins can insert licenses"
    ON licenses FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Política: Solo admins pueden actualizar licencias
CREATE POLICY "Admins can update licenses"
    ON licenses FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Política: Solo admins pueden eliminar licencias
CREATE POLICY "Admins can delete licenses"
    ON licenses FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =====================================================
-- FUNCIÓN: Crear perfil automáticamente al registrarse
-- =====================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, role)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'Usuario'),
        COALESCE(NEW.raw_user_meta_data->>'role', 'staff')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para crear perfil automáticamente
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- DATOS DE PRUEBA (OPCIONAL)
-- =====================================================

-- Insertar productos de ejemplo
INSERT INTO crm_products (name, description, price_one_payment, price_subscription) VALUES
    ('SoftControl Basic', 'Licencia básica con funcionalidades esenciales', 299.99, 29.99),
    ('SoftControl Pro', 'Licencia profesional con todas las funcionalidades', 599.99, 59.99),
    ('SoftControl Enterprise', 'Licencia empresarial con soporte premium', 999.99, 99.99)
ON CONFLICT DO NOTHING;
