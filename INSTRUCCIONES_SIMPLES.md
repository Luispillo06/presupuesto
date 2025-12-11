# 🚀 INSTRUCCIONES RÁPIDAS - Sistema Simple

## ✅ Lo que he hecho:

1. **Creado tabla `usuarios`** con:
   - id (número automático)
   - nombre
   - email (único)
   - contraseña

2. **Cambiado TODAS las tablas** para usar `usuario_id` (número) en lugar de UUID

3. **Sistema SIN Supabase Auth**, todo manual y simple

## 📋 PASO 1: Ejecutar SQL en Supabase

1. Ve a: https://supabase.com/dashboard/project/enrfzuuolscflkcsengw/editor
2. Haz clic en **"SQL Editor"** (menú izquierdo)
3. Haz clic en **"+ New query"**
4. **COPIA TODO** el archivo `supabase/schema.sql` y pégalo ahí
5. Haz clic en **"Run" ▶️**

## 📋 PASO 2: Ejecutar la App

```bash
cd "C:\Users\equipo\Documents\Presupuesto\presupuesto"
flutter run -d windows
```

## 🎯 PASO 3: Usar la App

1. Espera 3 segundos (splash)
2. Haz clic en **"Crear cuenta"**
3. Llena:
   - Nombre: "Test"
   - Email: "test@test.com"
   - Contraseña: "123456"
   - Confirmar: "123456"
4. Acepta términos
5. Clic en **"Crear Cuenta"**
6. ✅ Te lleva al Home automáticamente
7. Ahora puedes crear productos, ventas y gastos

## 🔍 Cómo Funciona:

### Registro:
```
1. Usuario llena formulario
2. Se inserta en tabla "usuarios":
   INSERT INTO usuarios (nombre, email, contraseña)
3. Se guarda el ID en el teléfono (SharedPreferences)
4. Va al Home
```

### Login:
```
1. Usuario pone email y contraseña
2. Se busca en tabla "usuarios":
   SELECT * FROM usuarios WHERE email = ? AND contraseña = ?
3. Si existe, guarda el ID en el teléfono
4. Va al Home
```

### Crear Producto/Venta/Gasto:
```
1. App lee el ID del usuario del teléfono
2. Al crear, agrega automáticamente:
   INSERT INTO productos (nombre, precio, usuario_id)
   VALUES ('Laptop', 1000, 123)
3. El producto queda vinculado al usuario
```

## ✅ Verificar en Supabase:

Después de registrarte, ve a **Table Editor** y verás:

**Tabla usuarios:**
```
id | nombre | email         | contraseña | created_at
1  | Test   | test@test.com | 123456     | 2025-12-11
```

**Tabla productos (después de crear uno):**
```
id | usuario_id | nombre  | precio | stock
1  | 1          | Laptop  | 1000   | 50
```

## 🎉 ¡LISTO!

Ya no hay líos con Supabase Auth. Todo es simple:
- ✅ Tabla usuarios con nombre, email, contraseña
- ✅ Registro directo a la tabla
- ✅ Login simple con SELECT
- ✅ Todo vinculado por usuario_id (número)

**¡Ejecuta el schema.sql y prueba la app!** 🚀
