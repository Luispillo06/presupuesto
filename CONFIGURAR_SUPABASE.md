# 🔧 Configuración de Base de Datos - PASO A PASO

## ⚠️ IMPORTANTE: Debes ejecutar el schema.sql en Supabase

### 📋 Paso 1: Abrir Supabase SQL Editor

1. Ve a: **https://supabase.com/dashboard/project/enrfzuuolscflkcsengw**
2. En el menú lateral izquierdo, haz clic en **"SQL Editor"**
3. Haz clic en **"+ New query"**

### 📋 Paso 2: Copiar y Ejecutar el Schema

1. Abre el archivo: `presupuesto/supabase/schema.sql`
2. **Copia TODO el contenido** del archivo
3. Pégalo en el SQL Editor de Supabase
4. Haz clic en el botón **"Run"** (▶️) abajo a la derecha
5. Espera a que diga **"Success. No rows returned"**

### ✅ Paso 3: Verificar que las tablas se crearon

1. En el menú lateral, haz clic en **"Table Editor"**
2. Deberías ver 3 tablas:
   - ✅ `productos`
   - ✅ `ventas`
   - ✅ `gastos`

### 📋 Paso 4: Verificar autenticación

1. En el menú lateral, haz clic en **"Authentication"** → **"Users"**
2. Esta tabla `auth.users` YA EXISTE (es automática de Supabase)
3. Aquí aparecerán los usuarios cuando se registren desde la app

### 🔐 Paso 5: Configurar políticas de Email (OPCIONAL)

Si quieres que los usuarios confirmen su email:

1. Ve a **Authentication** → **"Settings"**
2. En "Auth Providers" → "Email"
3. Puedes configurar:
   - ✅ **Enable Email Confirmations** (confirmar email)
   - ✅ **Enable Sign ups** (permitir registros)

**RECOMENDACIÓN**: Desactiva "Enable Email Confirmations" para pruebas rápidas.

## 🎯 Resumen

```
┌─────────────────────────────────────────┐
│  SUPABASE (EN LA NUBE)                  │
├─────────────────────────────────────────┤
│                                         │
│  auth.users (AUTOMÁTICA)                │
│  ├─ id (UUID)                           │
│  ├─ email                               │
│  └─ encrypted_password                  │
│                                         │
│  productos (CREAR CON SCHEMA.SQL)       │
│  ├─ id                                  │
│  ├─ user_id → auth.users(id)            │
│  ├─ nombre, precio, stock, etc.         │
│                                         │
│  ventas (CREAR CON SCHEMA.SQL)          │
│  ├─ id                                  │
│  ├─ user_id → auth.users(id)            │
│  ├─ cliente, monto, fecha, etc.         │
│                                         │
│  gastos (CREAR CON SCHEMA.SQL)          │
│  ├─ id                                  │
│  ├─ user_id → auth.users(id)            │
│  └─ concepto, monto, fecha, etc.        │
│                                         │
└─────────────────────────────────────────┘
```

## 🔄 Flujo de Registro

Cuando un usuario se registra en tu app:

1. **App Flutter** llama a `SupabaseConfig.client.auth.signUp()`
2. **Supabase** crea automáticamente un registro en `auth.users`
3. **Usuario recibe** un UUID único como `id`
4. Cuando el usuario crea un producto:
   - La app lee el `user_id` del usuario autenticado
   - Lo agrega automáticamente en `data['user_id']`
   - Supabase verifica con RLS que `auth.uid() = user_id`
   - ✅ Se crea el producto vinculado al usuario

## ⚠️ Si ya ejecutaste el schema.sql antes

Si ya ejecutaste el script y quieres empezar de cero:

```sql
-- BORRAR TABLAS (CUIDADO: BORRA TODOS LOS DATOS)
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS ventas CASCADE;
DROP TABLE IF EXISTS gastos CASCADE;

-- Luego vuelve a ejecutar el schema.sql completo
```

## 🐛 Troubleshooting

### Error: "relation already exists"
- Ya ejecutaste el schema antes
- Puedes ignorar estos errores si las tablas ya existen
- O borra las tablas y vuelve a ejecutar

### Error: "permission denied for schema auth"
- Normal, `auth.users` ya existe
- Solo necesitas crear tus 3 tablas personalizadas

### Error: "user_id column doesn't exist"
- No ejecutaste el schema.sql
- Ve al SQL Editor y ejecútalo completo

## ✅ Verificación Final

Después de ejecutar el schema.sql, verifica en SQL Editor:

```sql
-- Verificar que las tablas existen
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Deberías ver:
-- productos
-- ventas
-- gastos
```

## 🎯 Siguiente Paso

Una vez ejecutado el schema.sql:

1. ✅ Cierra la app si está corriendo
2. ✅ Ejecuta: `flutter run -d windows`
3. ✅ Haz clic en "Crear cuenta"
4. ✅ Registra un usuario
5. ✅ Crea un producto de prueba
6. ✅ ¡Debería funcionar!

---

**¿Necesitas ayuda?** Dime qué error te aparece en Supabase o en la app.
