# 📋 GUÍA COMPLETA PARA PROBAR EL SISTEMA

## 🔑 PASO 1: REGISTRARSE (IMPORTANTE - SIN ESTO NO FUNCIONA NADA)

1. **Abre la app** → Verás el **Splash Screen** (3 segundos)
2. **Click en "Inicia sesión"** → Se abre la pantalla de login
3. **Click en "¿No tienes cuenta? Regístrate"**
4. **Completa los datos:**
   - **Nombre**: Tu nombre (ej: Juan Pérez)
   - **Email**: Un email de prueba (ej: juan@test.com)
   - **Contraseña**: Una contraseña (ej: 123456)
   - **Confirmar contraseña**: La misma
   - ☑️ Acepta términos

5. **Click "Crear cuenta"**
6. **Verás popup**: "📧 Verifica tu correo"
   - **Importante**: En desarrollo, esto no envía email real
   - **Solución**: Ve a Supabase → Authentication → Users
   - **Busca** el usuario que creaste
   - **Haz click** en el usuario
   - **Marca** "Confirm email manually"
   - **Guarda** cambios

7. **Vuelve a la app**
8. **Entra con tus credenciales** (email + contraseña)

## ✅ PASO 2: UNA VEZ AUTENTICADO

Ahora que estás logueado:

### 📦 CREAR PRODUCTO:
1. Va a **Home** → Tab **Productos** (primer icono abajo)
2. Presiona botón **+ flotante verde** abajo a la derecha
3. Se abre **pantalla "Crear Producto"**
4. Completa:
   - Nombre: "iPhone 15"
   - Descripción: "El mejor teléfono"
   - Precio: "999.99"
   - Stock: "50"
   - Categoría: "Electrónica"
5. Presiona **"Crear Producto"**
6. **Debe decir** ✅ "Producto creado exitosamente"
7. **Vuelve automáticamente** a la lista
8. **El producto debe aparecer** en la lista

### 💰 CREAR VENTA:
1. Tab **Ventas** (segundo icono abajo)
2. Presiona **+ flotante verde**
3. Se abre **pantalla "Registrar Venta"**
4. Completa:
   - Cliente: "Juan García"
   - Monto: "599.99"
   - Notas: "Venta por teléfono"
5. Presiona **"Registrar Venta"**
6. **Debe decir** ✅ "Venta registrada exitosamente"
7. **La venta debe aparecer** en la lista

### 💸 CREAR GASTO:
1. Tab **Gastos** (tercer icono abajo)
2. Presiona **+ flotante rojo**
3. Se abre **pantalla "Registrar Gasto"**
4. Completa:
   - Concepto: "Alquiler oficina"
   - Categoría: "Alquiler"
   - Monto: "500.00"
   - Notas: "Pago mensual"
5. Presiona **"Registrar Gasto"**
6. **Debe decir** ✅ "Gasto registrado exitosamente"
7. **El gasto debe aparecer** en la lista

## 🐛 SI NO FUNCIONA

### Error: "❌ Debes estar autenticado"
**Solución**: No completaste el login. Ve al Paso 1.

### Error: "❌ Error al crear"
**Mira la consola de Flutter** (en VS Code):
- Si ves `Error createProducto: Usuario no autenticado`
  → Necesitas completar Paso 1

### Los datos no aparecen en la lista
1. **Presiona R** en la terminal (Hot Restart)
2. **Vuelve a loguear**
3. **Recarga la lista** (swipe down si hay swipe refresh)

### Error en Supabase
1. Ve a https://supabase.com/dashboard
2. Abre SQL Editor
3. **Copia y pega el schema.sql** nuevamente
4. Click "Run"

## 📊 VERIFICAR QUE FUNCIONA

Después de crear datos, deberías ver:

### ✅ En Productos:
- Lista de productos que creaste
- Cada producto muestra: nombre, precio, stock
- Botón (⋮) para eliminar

### ✅ En Ventas:
- "Total Ventas" mostrando la suma de dinero
- Lista de ventas con cliente y monto
- Botón (⋮) para eliminar

### ✅ En Gastos:
- Lista de gastos con concepto y monto
- Botón (⋮) para eliminar

### ✅ En Perfil (menú superior):
- Tu nombre completo
- Tu email

## 🔒 SEGURIDAD

Cada usuario SOLO VE sus datos:
- Si creas usuario **A** y agregas producto X
- Si creas usuario **B** NO verá producto X
- Esto está controlado por RLS en Supabase

## ⚙️ TROUBLESHOOTING AVANZADO

### Ver errores en detalle:
En VS Code, abre **Debug Console** (Ctrl+Shift+Y)
Los errores aparecerán con prefijo `❌ Error`

### Verificar base de datos:
1. Ve a Supabase Dashboard
2. Abre **Table Editor**
3. Selecciona tabla `productos`, `ventas` o `gastos`
4. Deberías ver tus datos ahí

---

**Resumen**: Regístrate → Loguéate → Crea datos → Verifica en lista ✅
