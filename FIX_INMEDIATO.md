# 🔥 SOLUCIÓN INMEDIATA PARA CREAR PRODUCTOS/VENTAS/GASTOS

## ❌ EL PROBLEMA

La app muestra "Producto creado ✅" pero **NO guarda nada** porque:

**LA SCHEMA.SQL NUNCA FUE EJECUTADA EN SUPABASE**

Sin ejecutar el SQL, no existen las tablas en la base de datos.

---

## ✅ LA SOLUCIÓN (3 pasos - 2 minutos)

### PASO 1: Copiar el SQL
1. Abre este archivo: `supabase/schema.sql`
2. Selecciona TODO el contenido (Ctrl+A)
3. Copia (Ctrl+C)

### PASO 2: Ejecutar en Supabase
1. Ve a: https://supabase.com/dashboard
2. Selecciona tu proyecto "presupuesto"
3. En el menú izquierdo, busca **"SQL Editor"**
4. Haz clic en **"New query"**
5. Pega el SQL (Ctrl+V)
6. Haz clic en el botón **"Run"** (abajo a la derecha)
7. Espera a que termine (debe decir "Success" o similar)

### PASO 3: Crear un usuario de prueba
1. Vuelve a la app Flutter
2. Haz clic en "Registrarse"
3. Llena:
   - Nombre: `TestUser`
   - Email: `test@example.com`
   - Contraseña: `Password123!`
   - Confirmar: `Password123!`
4. Haz clic en "Registrarse"
5. La app te pedirá que verifiques el email

### PASO 4: Verificar el email en Supabase
1. Ve a: https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Va a **"Authentication"** → **"Users"**
4. Busca `test@example.com`
5. Haz clic en el usuario
6. En "Email verified at", haz clic el checkmark ✅
7. Cierra y vuelve a la app

### PASO 5: Iniciar sesión
1. En la app, haz clic "Ya tengo cuenta"
2. Email: `test@example.com`
3. Contraseña: `Password123!`
4. Haz clic "Iniciar sesión"

### PASO 6: Crear un producto
1. Deberías ver la pantalla de inicio
2. Va a "Productos"
3. Haz clic en "+ Nuevo Producto"
4. Llena:
   - Nombre: `Arroz`
   - Precio: `15.50`
   - Stock: `100`
5. Haz clic "Crear"
6. Deberías ver "✅ Producto creado exitosamente"
7. **Vuelve a la lista de productos → ¿APARECE?** ✅

---

## 🐛 SI ALGO FALLA

### Si no puedes crear
- Abre la consola de Flutter (donde ejecutas `flutter run`)
- Busca mensajes como:
  - `"Usuario actual: null"` = Problema de autenticación
  - `"Error al crear el producto"` = Problema de base de datos
  - Otros errores = cópiame el error exacto

### Si el SQL da error al ejecutarse
- Copia TODO el contenido de nuevo
- Asegúrate de que está COMPLETO (sin truncar nada)
- Intenta ejecutar en una "New query" limpia

### Si después de crear NO aparece en la lista
1. Abre el navegador web
2. Ve a Supabase dashboard
3. Va a **"Tabla Editor"** o **"Table Editor"**
4. Selecciona la tabla `productos`
5. ¿Ves el dato que creaste? → Sí ✅ / No ❌

---

## ⚙️ RESUMEN TÉCNICO

Después de ejecutar schema.sql, tendrás:

- `auth.users` - Tabla de Supabase (usuario + contraseña)
- `perfiles` - Tu tabla con nombre y email
- `productos` - Tabla para guardar productos
- `ventas` - Tabla para guardar ventas  
- `gastos` - Tabla para guardar gastos

Cada tabla tiene:
- **RLS (Row Level Security)**: Solo el usuario propietario puede ver sus datos
- **Triggers**: Para actualizar automáticamente `updated_at`
- **Foreign Keys**: Para conectar a `auth.users`

---

## ¿PREGUNTAS?

**Si ves mensajes de error específicos, comparte aquí exactamente qué dice**
