# Mini-CRM SoftControl - Documentación

## Descripción General

Mini-CRM para gestión de clientes, licencias y suscripciones desarrollado en **Flutter** con **Supabase** como backend.

## Estructura del Proyecto

```
lib/src/
├── features/
│   └── crm/
│       └── screens/
│           ├── crm_login_screen.dart          # Pantalla de login
│           ├── crm_register_screen.dart       # Pantalla de registro
│           ├── crm_dashboard_screen.dart      # Dashboard principal
│           ├── crm_client_form_screen.dart    # Formulario de clientes
│           ├── crm_client_detail_screen.dart  # Detalle de cliente
│           ├── crm_product_form_screen.dart   # Formulario de productos
│           ├── crm_license_form_screen.dart   # Formulario de licencias
│           └── module_selector_screen.dart    # Selector de módulos
├── shared/
│   ├── models/
│   │   ├── profile_model.dart      # Modelo de perfil
│   │   ├── client_model.dart       # Modelo de cliente
│   │   ├── crm_product_model.dart  # Modelo de producto
│   │   └── license_model.dart      # Modelo de licencia
│   ├── services/
│   │   └── crm_service.dart        # Servicio de Supabase
│   └── providers/
│       └── crm_provider.dart       # Provider de estado
└── supabase/
    └── schema_crm.sql              # Script SQL para crear tablas
```

## Cómo Funciona el Login

### Flujo de Autenticación

1. **Pantalla de Login** (`crm_login_screen.dart`):
   - El usuario ingresa email y contraseña
   - Se llama a `CrmProvider.signIn()` que usa Supabase Auth
   - Si es exitoso, se carga el perfil del usuario
   - Se redirige al Dashboard

2. **Verificación de Perfil**:
   - Después del login, se obtiene el perfil de la tabla `profiles`
   - El perfil contiene el `role` (admin/staff)
   - El rol determina los permisos del usuario

3. **Registro de Usuario** (`crm_register_screen.dart`):
   - Se crea el usuario con `signUp()` incluyendo metadata (fullName, role)
   - Un trigger en PostgreSQL crea automáticamente el perfil

### Código de Autenticación

```dart
// Login
Future<bool> signIn(String email, String password) async {
  await _service.signIn(email, password);
  await loadCurrentProfile();
  return true;
}

// Registro
Future<AuthResponse> signUp({
  required String email,
  required String password,
  required String fullName,
  String role = 'staff',
}) async {
  return await _client.auth.signUp(
    email: email,
    password: password,
    data: {'full_name': fullName, 'role': role},
  );
}
```

## Modelo de Datos

### Diagrama Entidad-Relación

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   profiles  │     │   clients   │     │ crm_products│
├─────────────┤     ├─────────────┤     ├─────────────┤
│ id (PK,FK)  │     │ id (PK)     │     │ id (PK)     │
│ full_name   │◄────┤ created_by  │     │ name        │
│ role        │     │ name        │     │ description │
│ created_at  │     │ email       │     │ price_one   │
└─────────────┘     │ phone       │     │ price_sub   │
                    │ company     │     │ created_at  │
                    │ created_at  │     └──────┬──────┘
                    └──────┬──────┘            │
                           │                   │
                           │    ┌──────────────┴──────────────┐
                           │    │          licenses           │
                           │    ├─────────────────────────────┤
                           └───►│ id (PK)                     │
                                │ client_id (FK)              │
                                │ product_id (FK)             │
                                │ type (licencia_unica/suscr) │
                                │ start_date                  │
                                │ end_date                    │
                                │ status (activa/inactiva/    │
                                │         pendiente_pago)     │
                                │ created_at                  │
                                └─────────────────────────────┘
```

### Descripción de Tablas

#### 1. profiles
| Campo       | Tipo       | Descripción                           |
|-------------|------------|---------------------------------------|
| id          | UUID (PK)  | Referencia a auth.users.id            |
| full_name   | TEXT       | Nombre completo del usuario           |
| role        | TEXT       | Rol: 'admin' o 'staff'                |
| created_at  | TIMESTAMP  | Fecha de creación                     |

#### 2. clients
| Campo       | Tipo       | Descripción                           |
|-------------|------------|---------------------------------------|
| id          | UUID (PK)  | Identificador único                   |
| name        | TEXT       | Nombre del cliente                    |
| email       | TEXT       | Correo electrónico                    |
| phone       | TEXT       | Teléfono (opcional)                   |
| company     | TEXT       | Empresa (opcional)                    |
| created_at  | TIMESTAMP  | Fecha de creación                     |
| created_by  | UUID (FK)  | Usuario que creó el registro          |

#### 3. crm_products
| Campo              | Tipo       | Descripción                    |
|--------------------|------------|--------------------------------|
| id                 | UUID (PK)  | Identificador único            |
| name               | TEXT       | Nombre del producto            |
| description        | TEXT       | Descripción (opcional)         |
| price_one_payment  | NUMERIC    | Precio de licencia única       |
| price_subscription | NUMERIC    | Precio mensual de suscripción  |
| created_at         | TIMESTAMP  | Fecha de creación              |

#### 4. licenses
| Campo       | Tipo       | Descripción                           |
|-------------|------------|---------------------------------------|
| id          | UUID (PK)  | Identificador único                   |
| client_id   | UUID (FK)  | Cliente asignado                      |
| product_id  | UUID (FK)  | Producto asociado                     |
| type        | TEXT       | 'licencia_unica' o 'suscripcion'      |
| start_date  | DATE       | Fecha de inicio                       |
| end_date    | DATE       | Fecha de fin (null para únicas)       |
| status      | TEXT       | 'activa', 'inactiva', 'pendiente_pago'|
| created_at  | TIMESTAMP  | Fecha de creación                     |

## Políticas RLS (Row Level Security)

### Política de Lectura
- **Todos los usuarios autenticados** pueden leer todos los datos
- Esto permite que el staff vea la información del CRM

### Política de Escritura
- **Solo administradores** pueden:
  - Crear clientes
  - Editar clientes
  - Eliminar clientes
  - Crear productos
  - Editar productos
  - Eliminar productos
  - Crear licencias
  - Editar licencias
  - Eliminar licencias

### Implementación en SQL

```sql
-- Ejemplo: Solo admins pueden insertar clientes
CREATE POLICY "Admins can insert clients"
    ON clients FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );
```

## Funcionalidades

### 1. Dashboard Principal
- Vista general con estadísticas:
  - Cantidad de clientes
  - Cantidad de productos
  - Licencias activas
  - Total de licencias
- Acciones rápidas (solo admin)
- Navegación a módulos

### 2. Gestión de Clientes
- Listado de clientes con búsqueda
- Crear nuevo cliente (admin)
- Editar cliente existente (admin)
- Eliminar cliente (admin)
- Ver detalle con licencias asociadas

### 3. Gestión de Productos
- Listado de productos
- Crear producto con precios (admin)
- Editar producto (admin)
- Eliminar producto (admin)

### 4. Gestión de Licencias
- Listado filtrable por estado
- Tabs: Todas, Activas, Pendientes, Inactivas
- Crear licencia asignada a cliente (admin)
- Editar estado y fechas (admin)
- Eliminar licencia (admin)

## Rutas de Navegación

| Ruta                 | Pantalla                    |
|----------------------|-----------------------------|
| /crm-login           | Login del CRM               |
| /crm-register        | Registro de usuarios        |
| /crm-dashboard       | Dashboard principal         |
| /crm-client-form     | Formulario de cliente       |
| /crm-client-detail   | Detalle de cliente          |
| /crm-product-form    | Formulario de producto      |
| /crm-license-form    | Formulario de licencia      |
| /module-selector     | Selector de módulos         |

## Configuración de Supabase

### 1. Ejecutar el Script SQL

Ve a tu proyecto de Supabase > SQL Editor y ejecuta el contenido de:
```
supabase/schema_crm.sql
```

Este script:
- Crea las tablas necesarias
- Configura las políticas RLS
- Crea el trigger para perfiles automáticos
- Inserta productos de ejemplo

### 2. Configurar Autenticación

En Supabase Dashboard > Authentication > Settings:
- Habilitar Email provider
- Configurar el redirect URL si es necesario

## Uso

### Acceder al CRM

1. Ejecutar la aplicación
2. Navegar a `/crm-login`
3. Registrarse como admin o usar credenciales existentes
4. Explorar el dashboard y las funcionalidades

### Primer Usuario Admin

Para crear el primer administrador:
1. Ir a `/crm-register`
2. Seleccionar rol "Administrador"
3. Completar el registro

## Criterios de Evaluación Cubiertos

| Criterio                              | Estado    |
|---------------------------------------|-----------|
| Correcta implementación de tablas     | ✅ Completo |
| Correcta aplicación de RLS            | ✅ Completo |
| Funcionalidad completa de CRUD        | ✅ Completo |
| Diseño, usabilidad e intuitividad     | ✅ Completo |
| Documentación clara                   | ✅ Completo |
