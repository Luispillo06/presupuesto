# 🗄️ Configuración de Supabase para MarketMove

## 📋 Pasos de Configuración

### 1. Crear proyecto en Supabase

1. Ve a [supabase.com](https://supabase.com) y crea una cuenta
2. Crea un nuevo proyecto
3. Anota la **URL del proyecto** y la **anon key** (en Settings > API)

### 2. Configurar credenciales en Flutter

Edita el archivo `lib/src/core/supabase/supabase_config.dart`:

```dart
static const String supabaseUrl = 'https://TU_PROYECTO.supabase.co';
static const String supabaseAnonKey = 'TU_ANON_KEY';
```

### 3. Crear las tablas en Supabase

1. Ve al **SQL Editor** en tu proyecto de Supabase
2. Copia y pega el contenido del archivo `supabase/schema.sql`
3. Ejecuta el script

### 4. Configurar autenticación

En Supabase Dashboard:

1. Ve a **Authentication > Settings**
2. Habilita **Email** como proveedor
3. (Opcional) Configura **URL de redirección** para la app

### 5. Ejecutar la app

```bash
flutter pub get
flutter run
```

## 📊 Estructura de la Base de Datos

### Tabla `ventas`
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | BIGSERIAL | ID único |
| user_id | UUID | Usuario propietario |
| cliente | VARCHAR | Nombre del cliente |
| monto | DECIMAL | Importe de la venta |
| fecha | TIMESTAMP | Fecha de la venta |
| productos | TEXT[] | Lista de productos |
| notas | TEXT | Notas adicionales |

### Tabla `gastos`
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | BIGSERIAL | ID único |
| user_id | UUID | Usuario propietario |
| concepto | VARCHAR | Descripción del gasto |
| categoria | VARCHAR | Categoría del gasto |
| monto | DECIMAL | Importe del gasto |
| fecha | TIMESTAMP | Fecha del gasto |
| notas | TEXT | Notas adicionales |

### Tabla `productos`
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | BIGSERIAL | ID único |
| user_id | UUID | Usuario propietario |
| nombre | VARCHAR | Nombre del producto |
| descripcion | TEXT | Descripción |
| precio | DECIMAL | Precio unitario |
| stock | INTEGER | Cantidad en stock |
| stock_minimo | INTEGER | Alerta de stock bajo |
| categoria | VARCHAR | Categoría |
| codigo_barras | VARCHAR | Código de barras |
| imagen_url | TEXT | URL de la imagen |

## 🔒 Seguridad (RLS)

Todas las tablas tienen **Row Level Security** habilitado:
- Los usuarios solo pueden ver/editar sus propios datos
- Cada registro está vinculado a un `user_id`
- Las políticas aseguran el aislamiento de datos

## 🔄 Realtime

Las tablas están configuradas para funcionar con Supabase Realtime.
Los servicios en Flutter usan streams para actualizaciones en tiempo real.
