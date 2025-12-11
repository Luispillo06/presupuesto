# 🔐 Crear Usuario de Prueba en Supabase

## Opción 1: Desde el Dashboard de Supabase (RECOMENDADO)

1. Ve a tu proyecto en Supabase: https://supabase.com/dashboard
2. En el menú lateral, haz clic en **Authentication** → **Users**
3. Haz clic en **Add user** (botón verde)
4. Completa:
   - **Email**: `test@marketmove.com`
   - **Password**: `Test123456`
5. Desmarca **Auto Confirm User** (para que se confirme automáticamente)
6. Haz clic en **Create user**

## Opción 2: Desde SQL Editor

1. Ve a **SQL Editor** en el dashboard de Supabase
2. Ejecuta este script:

```sql
-- Crear usuario de prueba
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data,
  is_super_admin,
  confirmation_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'test@marketmove.com',
  crypt('Test123456', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{}',
  FALSE,
  ''
);
```

## ✅ Verificación

Después de crear el usuario, reinicia la app de Flutter y deberías poder:
1. ✅ Ver el splash screen
2. ✅ Ir directo al Home (sin login)
3. ✅ Crear productos, ventas y gastos

## 🔄 Hot Restart

Ejecuta en la terminal:
```bash
cd "C:\Users\equipo\Documents\Presupuesto\presupuesto"
flutter run -d windows
```

Cuando la app esté corriendo, presiona **R** para hot restart.
