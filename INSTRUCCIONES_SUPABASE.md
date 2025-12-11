# 🚀 INSTRUCCIONES PARA CONFIGURAR LA BASE DE DATOS

## Paso 1: Abrir Supabase

1. Ve a https://supabase.com/
2. Inicia sesión en tu proyecto
3. En el menú lateral, haz clic en **"SQL Editor"**

## Paso 2: Ejecutar el Schema

1. Haz clic en el botón **"New query"**
2. Copia TODO el contenido del archivo `supabase/schema.sql`
3. Pégalo en el editor SQL
4. Haz clic en el botón **"Run"** (o presiona Ctrl+Enter)

## Paso 3: Verificar

Después de ejecutar, deberías ver:
- ✅ Tabla `perfiles` creada
- ✅ Tabla `productos` actualizada
- ✅ Tabla `ventas` actualizada
- ✅ Tabla `gastos` actualizada
- ✅ Políticas RLS (Row Level Security) aplicadas

## ¿Qué hace este schema?

### Sistema de Autenticación
- **Supabase Auth**: Maneja email y contraseña de forma segura
- **Tabla `perfiles`**: Guarda información adicional del usuario (nombre)

### Sistema de Seguridad (RLS)
- Cada usuario SOLO puede ver y editar SUS PROPIOS datos
- Nadie puede ver los productos/ventas/gastos de otros usuarios

### Tablas Principales
- **productos**: id, nombre, descripcion, precio, stock, categoria, user_id
- **ventas**: id, producto_id, cantidad, total, fecha, user_id
- **gastos**: id, concepto, monto, categoria, fecha, user_id

## Paso 4: Probar la App

Después de ejecutar el SQL:

1. Ejecuta `flutter run -d windows` en la terminal
2. **REGÍSTRATE** con un nuevo usuario (email + contraseña + nombre)
3. **INICIA SESIÓN** con ese usuario
4. **CREA** productos, ventas y gastos
5. Todo debería funcionar correctamente ✅

## ⚠️ IMPORTANTE

Si ya tenías tablas creadas anteriormente, este script las eliminará y creará nuevas con la estructura correcta.

## 🆘 Si tienes problemas

1. Asegúrate de copiar TODO el contenido de `schema.sql`
2. Si aparece un error, léelo y pégalo para ayudarte
3. Verifica que estás en el proyecto correcto de Supabase
