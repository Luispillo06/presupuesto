# 🔌 ESTADO DE SUPABASE - MARKETMOVE

## ✅ ¿TIENE SUPABASE?

**SÍ**, el proyecto tiene Supabase configurado y listo para usar.

---

## 📊 ESTADO ACTUAL

### ✅ Configurado
- ✅ Dependencia `supabase_flutter` instalada en `pubspec.yaml`
- ✅ Clase `SupabaseConfig` implementada
- ✅ Inicialización en `main.dart`
- ✅ Métodos helper disponibles

### ⏳ Pendiente de Implementación
- ⏳ Conexión real con base de datos
- ⏳ Tablas creadas en Supabase
- ⏳ Operaciones CRUD en servicios
- ⏳ Integración en pantallas

---

## 📁 ESTRUCTURA SUPABASE

### Archivo de Configuración
**Ubicación:** `lib/src/core/supabase/supabase_config.dart`

```dart
class SupabaseConfig {
  // Credenciales de Supabase (ejemplo - puedes reemplazar con las tuyas)
  static const String supabaseUrl = 
    'https://aajtcxndurbzezpobwfw.supabase.co';
  static const String supabaseAnonKey = 
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

  // Métodos disponibles
  static Future<void> initialize()        // Inicializa Supabase
  static SupabaseClient get client        // Cliente Supabase
  static User? get currentUser            // Usuario actual
  static bool get isAuthenticated         // ¿Autenticado?
  static Stream<AuthState> authStateChanges  // Stream de auth
}
```

---

## 🔧 SERVICIOS DISPONIBLES

### Servicios Creados
```
lib/src/core/services/
├── auth_service.dart        # Autenticación (estructura lista)
├── ventas_service.dart      # Operaciones de ventas
├── gastos_service.dart      # Operaciones de gastos
├── productos_service.dart   # Operaciones de productos
└── services.dart            # Exports
```

Todos los servicios tienen la estructura lista para implementar llamadas CRUD a Supabase.

---

## 🚀 CÓMO USAR SUPABASE

### 1. Crear un Proyecto en Supabase

1. Ir a https://supabase.com
2. Crear una cuenta (si no la tienes)
3. Crear un nuevo proyecto
4. Copiar el **Project URL** y **Anon Key**

### 2. Actualizar Credenciales

En `lib/src/core/supabase/supabase_config.dart`:

```dart
static const String supabaseUrl = 'TU_PROJECT_URL';
static const String supabaseAnonKey = 'TU_ANON_KEY';
```

### 3. Usar en Código

Ejemplo de autenticación:

```dart
// Registrarse
await SupabaseConfig.client.auth.signUp(
  email: email,
  password: password,
);

// Iniciar sesión
await SupabaseConfig.client.auth.signInWithPassword(
  email: email,
  password: password,
);

// Obtener usuario actual
final user = SupabaseConfig.currentUser;
```

Ejemplo de base de datos:

```dart
// Insertar
await SupabaseConfig.client
  .from('ventas')
  .insert({'monto': 100, 'usuario_id': userId});

// Obtener
final data = await SupabaseConfig.client
  .from('ventas')
  .select()
  .eq('usuario_id', userId);

// Actualizar
await SupabaseConfig.client
  .from('ventas')
  .update({'monto': 150})
  .eq('id', ventaId);

// Eliminar
await SupabaseConfig.client
  .from('ventas')
  .delete()
  .eq('id', ventaId);
```

---

## 📊 TABLAS RECOMENDADAS

### En Supabase, crear estas tablas:

#### Tabla: `users` (automanaged por Supabase)
```sql
-- Supabase crea esto automáticamente
-- Tiene: id, email, password, created_at, updated_at
```

#### Tabla: `ventas`
```sql
CREATE TABLE ventas (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id UUID NOT NULL REFERENCES auth.users(id),
  monto DECIMAL(10, 2) NOT NULL,
  descripcion TEXT,
  fecha DATE NOT NULL DEFAULT TODAY(),
  categoria VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

#### Tabla: `gastos`
```sql
CREATE TABLE gastos (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id UUID NOT NULL REFERENCES auth.users(id),
  monto DECIMAL(10, 2) NOT NULL,
  descripcion TEXT,
  categoria VARCHAR(50),
  fecha DATE NOT NULL DEFAULT TODAY(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

#### Tabla: `productos`
```sql
CREATE TABLE productos (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  usuario_id UUID NOT NULL REFERENCES auth.users(id),
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  precio_venta DECIMAL(10, 2) NOT NULL,
  precio_costo DECIMAL(10, 2),
  stock_actual INT DEFAULT 0,
  stock_minimo INT DEFAULT 5,
  categoria VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

---

## 🔒 SEGURIDAD (Row Level Security)

Habilitar RLS en Supabase para proteger datos:

```sql
-- Para tabla ventas
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
```

Repetir para tablas `gastos` y `productos`.

---

## 📝 DEPENDENCIAS EN PUBSPEC.YAML

```yaml
supabase_flutter: ^2.8.0
```

✅ Ya está instalado

---

## 🎯 SIGUIENTE FASE: INTEGRACIÓN

### Pasos para integrar completamente:

1. **Crear proyecto en Supabase** ← Hazlo aquí
2. **Crear tablas en BD** ← Script SQL arriba
3. **Habilitar RLS** ← Scripts de seguridad arriba
4. **Actualizar credenciales** en `supabase_config.dart`
5. **Implementar servicios** en `lib/src/core/services/`
6. **Conectar pantallas** con los servicios
7. **Pruebas end-to-end**

---

## 📚 RECURSOS

- **Documentación Supabase:** https://supabase.com/docs
- **Supabase Flutter:** https://supabase.com/docs/reference/dart
- **Ejemplos:** https://github.com/supabase/supabase-flutter

---

## 🔄 ESTADO EN FASES

| Fase | Actividad | Estado |
|------|-----------|--------|
| 1 | MVP UI | ✅ Completado |
| 2 | Instalación Supabase | ✅ Hecho |
| 3 | Configuración Cliente | ✅ Hecho |
| 4 | Servicios (estructura) | ✅ Hecho |
| 5 | Crear tablas BD | ⏳ Pendiente |
| 6 | Implementar CRUD | ⏳ Pendiente |
| 7 | Conectar pantallas | ⏳ Pendiente |
| 8 | Testing | ⏳ Pendiente |

---

## ✨ RESUMEN

✅ **SÍ TIENE SUPABASE**

- Está **instalado** como dependencia
- Está **configurado** en `supabase_config.dart`
- Está **inicializado** en `main.dart`
- Los **servicios** están estructurados y listos
- Las **pantallas** están preparadas para recibir datos

Solo falta:
- Crear proyecto en Supabase.com
- Actualizar credenciales
- Implementar operaciones CRUD
- Conectar con las pantallas

**Tiempo estimado de integración completa:** 20-25 horas (según Presupuesto fase 5)

---

**Últimas verificaciones:** 11 de diciembre de 2025  
**Estado:** ✅ Infraestructura lista, pendiente integración real
