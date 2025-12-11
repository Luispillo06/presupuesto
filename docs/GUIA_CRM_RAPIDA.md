# GUÍA RÁPIDA DEL CRM - SoftControl

## ✅ Estado Actual

El CRM está **completo y funcional** con todas las características del enunciado.

---

## 🚀 Cómo Usar

### 1. **Ejecutar la Aplicación**
```bash
flutter run -d windows
```

### 2. **Acceder al CRM**
- Navegar a: **`/crm-login`**
- O seleccionar desde el selector de módulos

### 3. **Registrarse**
1. Click en "¿No tienes cuenta? Regístrate"
2. Completar datos:
   - Nombre completo
   - Correo
   - Contraseña
   - **Seleccionar rol**:
     - 🔑 **Admin**: Acceso total (crear/editar/eliminar todo)
     - 👤 **Staff**: Solo lectura (ver información)
3. Click "Registrarse"

### 4. **Iniciar Sesión**
1. Ingresar correo y contraseña
2. Click "Iniciar Sesión"
3. ¡Listo! Irás al Dashboard

---

## 📊 Dashboard Principal

En la pantalla principal ves:

### **Estadísticas** (4 tarjetas)
- 👥 **Clientes**: Total de clientes registrados
- 📦 **Productos**: Total de productos disponibles
- 🔑 **Licencias Activas**: Licencias vigentes
- 📋 **Total Licencias**: Todas las licencias

### **Acciones Rápidas** (Solo Admin)
- ➕ **Nuevo Cliente**
- ➕ **Nuevo Producto**
- ➕ **Nueva Licencia**

---

## 📑 Navegación (Bottom Navigation)

### 🏠 **Dashboard**
- Vista general con estadísticas
- Acciones rápidas

### 👥 **Clientes**
- Listado de todos los clientes
- **Admin**: Crear, editar, eliminar
- **Staff**: Solo ver

**Detalles del Cliente**:
- Información completa
- Licencias asociadas
- Opción de agregar licencias nuevas

### 📦 **Productos**
- Listado de productos con precios
- **Admin**: Crear, editar, eliminar
- **Staff**: Solo ver

**Información mostrada**:
- Nombre
- Descripción
- Precio de licencia única
- Precio de suscripción mensual

### 🔑 **Licencias**
- **4 Tabs** para filtrar por estado:
  1. **Todas**: Todas las licencias
  2. **Activas**: Solo las vigentes
  3. **Pendientes**: Pendientes de pago
  4. **Inactivas**: Dadas de baja

**Información de licencia**:
- Cliente
- Producto
- Tipo: Única o Suscripción
- Estado: Activa/Inactiva/Pendiente Pago
- Fechas: Inicio y fin

---

## 🔑 Flujo Completo de Uso

### **Escenario**: Vender una licencia a un cliente

#### **Paso 1: Crear un Cliente** (Admin)
1. Ir a tab **Clientes**
2. Click **"Nuevo Cliente"**
3. Completar:
   - Nombre completo ✓
   - Email ✓
   - Teléfono (opcional)
   - Empresa (opcional)
4. Click **"Crear Cliente"**

#### **Paso 2: Crear un Producto** (Admin)
1. Ir a tab **Productos**
2. Click **"Nuevo Producto"**
3. Completar:
   - Nombre ✓
   - Descripción
   - Precio de licencia única ✓
   - Precio de suscripción ✓
4. Click **"Crear Producto"**

#### **Paso 3: Asignar una Licencia** (Admin)
1. Ir a tab **Licencias**
2. Click **"Nueva Licencia"**
3. Seleccionar:
   - Cliente ✓ (el que creaste)
   - Producto ✓ (el que creaste)
   - Tipo: "Licencia Única" o "Suscripción" ✓
   - Estado: Activa/Pendiente/Inactiva ✓
4. Establecer fechas:
   - Fecha de inicio ✓
   - Fecha de fin (solo si es suscripción)
5. Click **"Crear Licencia"**

#### **Paso 4: Ver el Registro** (Todos)
- La licencia aparece en el tab correspondiente
- El Dashboard actualiza las estadísticas
- Puedes ver la licencia en los detalles del cliente

---

## 🔐 Seguridad (RLS en Supabase)

**Solo Lectura**:
- ✅ Todo usuario autenticado puede VER datos
- ✅ Staff puede VER pero NO modificar

**Permisos de Escritura**:
- ✅ Solo ADMIN puede CREAR
- ✅ Solo ADMIN puede EDITAR
- ✅ Solo ADMIN puede ELIMINAR
- ✅ Staff solo puede LEER

---

## 📱 Acciones en Listados

### **En Clientes**
- Click en cliente → Ver detalles + licencias
- Menú (3 puntos) → Editar / Ver licencias / Eliminar

### **En Productos**
- Click en producto → Ver detalles
- Menú (3 puntos) → Editar / Eliminar

### **En Licencias**
- Menú (3 puntos) → Editar / Eliminar

---

## 🗄️ Base de Datos Supabase

### **Ejecutar el Script SQL**

En tu proyecto Supabase:
1. Ve a **SQL Editor**
2. Abre el archivo: `supabase/schema_crm.sql`
3. Copia todo el contenido
4. Pega en el editor
5. Click **"RUN"**

✅ **Esto crea**:
- Tabla `profiles` (usuarios)
- Tabla `clients` (clientes)
- Tabla `crm_products` (productos)
- Tabla `licenses` (licencias)
- Políticas RLS automáticas
- Trigger para perfiles automáticos

---

## ⚙️ Estructura del Código

```
lib/src/
├── features/crm/screens/
│   ├── crm_login_screen.dart           ← Login
│   ├── crm_register_screen.dart        ← Registro
│   ├── crm_dashboard_screen.dart       ← Dashboard + Tabs
│   ├── crm_client_form_screen.dart     ← Crear/Editar cliente
│   ├── crm_client_detail_screen.dart   ← Detalles cliente
│   ├── crm_product_form_screen.dart    ← Crear/Editar producto
│   ├── crm_license_form_screen.dart    ← Crear/Editar licencia
│   └── module_selector_screen.dart     ← Selector módulos
│
├── shared/
│   ├── models/
│   │   ├── profile_model.dart
│   │   ├── client_model.dart
│   │   ├── crm_product_model.dart
│   │   └── license_model.dart
│   ├── services/
│   │   └── crm_service.dart            ← Operaciones Supabase
│   └── providers/
│       └── crm_provider.dart           ← Estado de la app
```

---

## 🎯 Características Implementadas

| Feature | Admin | Staff | Descripción |
|---------|-------|-------|-------------|
| Ver Dashboard | ✅ | ✅ | Estadísticas generales |
| Ver Clientes | ✅ | ✅ | Listado de clientes |
| Crear Cliente | ✅ | ❌ | Solo admin puede crear |
| Editar Cliente | ✅ | ❌ | Solo admin puede editar |
| Eliminar Cliente | ✅ | ❌ | Solo admin puede eliminar |
| Ver Productos | ✅ | ✅ | Listado de productos |
| Crear Producto | ✅ | ❌ | Solo admin puede crear |
| Editar Producto | ✅ | ❌ | Solo admin puede editar |
| Eliminar Producto | ✅ | ❌ | Solo admin puede eliminar |
| Ver Licencias | ✅ | ✅ | Listado y filtros |
| Crear Licencia | ✅ | ❌ | Solo admin puede crear |
| Editar Licencia | ✅ | ❌ | Solo admin puede editar |
| Eliminar Licencia | ✅ | ❌ | Solo admin puede eliminar |
| Cerrar Sesión | ✅ | ✅ | Logout |

---

## 📲 Rutas Disponibles

```
/crm-login              → Login CRM
/crm-register           → Registro de usuarios
/crm-dashboard          → Dashboard principal
/crm-client-form        → Crear/Editar cliente
/crm-client-detail      → Detalles del cliente
/crm-product-form       → Crear/Editar producto
/crm-license-form       → Crear/Editar licencia
/module-selector        → Selector de módulos
```

---

## ✨ Todo está Completo y Funcional

✅ Autenticación con Supabase  
✅ Gestión de clientes (CRUD)  
✅ Gestión de productos (CRUD)  
✅ Gestión de licencias (CRUD)  
✅ Row Level Security implementado  
✅ Navegación fluida  
✅ Validación de formularios  
✅ Manejo de errores  
✅ UI/UX coherente  
✅ Documentación completa  

**¡Listo para usar!** 🎉
