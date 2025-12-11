# 🏪 PRESUPUESTO MARKETPLACE - GUÍA COMPLETA

## 📋 DESCRIPCIÓN DEL SISTEMA

La aplicación PRESUPUESTO ahora es un **marketplace completo** con dos tipos de usuarios:

### 1️⃣ **VENDEDORES** 🛍️
- Crean una tienda con su nombre y descripción
- Gestionen productos con precios y stock
- Registran ventas (CRUD completo)
- Controlan gastos del negocio
- Ven análisis de su tienda
- Reciben pedidos de compradores
- Pueden ver sus ganancias

**Pantallas del Vendedor:**
- Dashboard/Resumen de tienda
- Gestión de Productos (Crear, editar, eliminar, ver stock)
- Historial de Ventas
- Control de Gastos
- Pedidos recibidos
- Calificaciones y reseñas

### 2️⃣ **COMPRADORES** 👤
- Navegan las tiendas disponibles
- Ven productos de diferentes vendedores
- Agregran productos al carrito
- Realizan compras/pedidos
- Ven historial de compras
- Pueden dejar reseñas y calificar vendedores
- Reciben notificaciones

**Pantallas del Comprador:**
- Explorar tiendas
- Buscar productos
- Ver detalles de productos y vendedores
- Carrito de compras
- Historial de compras
- Mis reseñas

---

## 🗄️ ESTRUCTURA DE BASE DE DATOS

### Cambios Principales

#### **Tabla `perfiles` - ACTUALIZADA**
```sql
id              UUID (PK)           -- ID del usuario
nombre          VARCHAR(255)        -- Nombre del usuario
email           VARCHAR(255)        -- Email único
rol             VARCHAR(50)         -- 'vendor' o 'buyer' ⭐
nombre_tienda   VARCHAR(255)        -- Solo para vendedores
descripcion_tienda  TEXT            -- Descripción de tienda (vendor)
imagen_tienda_url   TEXT            -- Logo de tienda (vendor)
ciudad          VARCHAR(100)        -- Ubicación
pais            VARCHAR(100)        -- País
telefono        VARCHAR(20)         -- Teléfono de contacto
avatar_url      TEXT                -- Foto de perfil
calificacion    DECIMAL(3,2)        -- Promedio de calificaciones
total_transacciones INTEGER         -- Número de transacciones
```

#### **Tabla `tiendas` - NUEVA**
```sql
id              UUID (PK)
vendor_id       UUID (FK → auth.users)
nombre          VARCHAR(255)        -- Nombre tienda
descripcion     TEXT                -- Descripción
logo_url        TEXT                -- Logo
banner_url      TEXT                -- Banner
ciudad          VARCHAR(100)
pais            VARCHAR(100)
calificacion    DECIMAL(3,2)        -- Rating de la tienda
total_productos INTEGER             -- Cuántos productos tiene
total_ventas    INTEGER             -- Cuántas ventas ha hecho
```

#### **Tabla `productos` - MODIFICADA**
```sql
-- Ahora tienen vendor_id en lugar de user_id
vendor_id UUID  -- Quién vende el producto
activo BOOLEAN  -- Si está disponible para compra
```

#### **Tabla `pedidos` - NUEVA**
```sql
id UUID (PK)
buyer_id UUID   -- Quién compra
vendor_id UUID  -- A quién le compra
estado VARCHAR  -- 'pendiente', 'confirmado', 'enviado', 'entregado'
monto_total DECIMAL
direccion_entrega TEXT
notas TEXT
```

#### **Tabla `compras` - NUEVA**
```sql
-- Historial de compras del comprador
buyer_id UUID
vendor_id UUID
producto_id UUID
cantidad INTEGER
monto DECIMAL
```

#### **Tabla `reseñas` - NUEVA**
```sql
comprador_id UUID
vendedor_id UUID
producto_id UUID (opcional)
calificacion INTEGER (1-5)  -- Estrellas
comentario TEXT
```

---

## 🔐 ROW LEVEL SECURITY (RLS)

### Para Vendedores
- ✅ Ver solo SUS productos
- ✅ Ver solo SUS ventas
- ✅ Ver solo SUS gastos
- ✅ Ver solo SUS pedidos (de compradores)
- ✅ Ver la LISTA DE PRODUCTOS activos (de todos) para análisis

### Para Compradores
- ✅ Ver TODOS los productos activos
- ✅ Ver TODAS las tiendas
- ✅ Ver solo SUS compras
- ✅ Ver solo SUS pedidos
- ✅ Hacer comentarios/reseñas

---

## 📱 FLUJO DE USUARIO

### 🏪 REGISTRO Y ONBOARDING

```
┌─────────────────────────────────┐
│    Pantalla de Inicio           │
├─────────────────────────────────┤
│                                 │
│  ¿Eres vendedor o comprador?    │
│                                 │
│   [Soy Vendedor] [Soy Comprador]│
│                                 │
└────────┬────────────────────────┘
         │
    ┌────┴─────────────────────────┐
    │                              │
    ▼                              ▼
REGISTRO VENDEDOR            REGISTRO COMPRADOR
├─ Email                     ├─ Email
├─ Contraseña                ├─ Contraseña
├─ Nombre completo           ├─ Nombre completo
├─ Nombre de tienda ⭐        ├─ Teléfono
├─ Descripción tienda         └─ Crear cuenta
├─ Ciudad/País
└─ Crear tienda
```

### 🛍️ FLUJO DEL COMPRADOR

```
┌──────────────────┐
│  Home/Dashboard  │
├──────────────────┤
│ - Recomendadas   │
│ - Tiendas        │
│ - Mis compras    │
└────────┬─────────┘
         │
         ├─→ Explorar Tiendas (ver lista de vendedores)
         │    └─→ Ver detalles de tienda
         │         └─→ Ver productos del vendedor
         │
         ├─→ Buscar Productos (búsqueda global)
         │    └─→ Ver detalles producto
         │         ├─→ Agregar al carrito
         │         └─→ Ver reseñas
         │
         ├─→ Mi Carrito
         │    └─→ Ir a pagar
         │         └─→ Confirmar pedido
         │
         └─→ Mis Compras (historial)
              └─→ Dejar reseña del vendedor
```

### 🏪 FLUJO DEL VENDEDOR

```
┌──────────────────────┐
│  Dashboard Tienda    │
├──────────────────────┤
│ - Resumen de ventas  │
│ - Productos activos  │
│ - Pedidos pendientes │
│ - Últimas reseñas    │
└────────┬─────────────┘
         │
         ├─→ Gestionar Productos
         │    ├─→ Crear producto
         │    ├─→ Ver mis productos
         │    ├─→ Editar producto
         │    └─→ Eliminar producto
         │
         ├─→ Pedidos (compras entrantes)
         │    ├─→ Ver pedidos pendientes
         │    ├─→ Confirmar pedido
         │    ├─→ Marcar como enviado
         │    └─→ Marcar como entregado
         │
         ├─→ Historial de Ventas
         │    └─→ Ver todas mis ventas
         │
         ├─→ Gastos
         │    ├─→ Crear gasto
         │    └─→ Ver gastos por categoría
         │
         ├─→ Mis Reseñas
         │    └─→ Ver calificaciones de clientes
         │
         └─→ Configuración de Tienda
              ├─→ Editar nombre/descripción
              ├─→ Editar logo/banner
              ├─→ Cambiar ubicación
              └─→ Ver estadísticas
```

---

## 🔄 FLUJO COMPLETO DE COMPRA

### Paso 1: Comprador busca
```
Comprador abre app 
  → Ve lista de tiendas 
    → Entra a tienda que le interesa
      → Ve productos con descripciones y fotos
        → Lee reseñas del vendedor
```

### Paso 2: Comprador agrega al carrito
```
Comprador selecciona producto
  → Elige cantidad
    → Agrega al carrito
      → Puede seguir comprando o ir al carrito
```

### Paso 3: Comprador paga
```
Comprador va al carrito
  → Ve total
    → Ingresa dirección de entrega
      → Ingresa teléfono
        → Escribe notas (opcional)
          → Confirma pedido
            → PEDIDO CREADO ✅
```

### Paso 4: Vendedor recibe pedido
```
Vendedor ve notificación de nuevo pedido
  → Ve detalles del pedido (productos, monto, dirección)
    → Prepara envío
      → Marca como "enviado"
        → Comprador recibe notificación
```

### Paso 5: Comprador recibe y deja reseña
```
Comprador recibe pedido
  → Marca como recibido
    → Escribe reseña del vendedor
      → Califica (1-5 estrellas)
        → Envía comentario
          → Reseña aparece en tienda del vendedor
```

---

## 🎨 CAMBIOS EN LA UI

### Colores por ROL

**VENDEDOR:**
- Header: Morado/Indigo (para diferenciarse)
- Botones: Morado
- Destacados: Morado

**COMPRADOR:**
- Header: Azul claro
- Botones: Azul
- Destacados: Azul

### Elementos Nuevos

**Para Vendedores:**
- ⭐ Calificación de tienda (promedio)
- 📦 Pedidos recibidos
- 💬 Reseñas de clientes
- 📊 Estadísticas de tienda

**Para Compradores:**
- 🏪 Lista/Grid de tiendas
- 🔍 Búsqueda de productos
- ⭐ Calificaciones del vendedor
- 🛒 Carrito de compras
- 💬 Dejar reseñas

---

## 📊 MODELOS DE DATOS NUEVOS

```dart
// Usuario Base
class Perfil {
  String id;           // UUID
  String nombre;
  String email;
  String rol;          // 'vendor' o 'buyer'
  String? nombreTienda;
  String? descripcionTienda;
  double calificacionPromedio;
  int totalTransacciones;
}

// Para Vendedores
class Tienda {
  String id;
  String vendorId;
  String nombre;
  String? descripcion;
  String? logoUrl;
  double calificacion;
  int totalProductos;
  int totalVentas;
}

// Para Compradores
class Carrito {
  String id;
  String buyerId;
  List<CartItem> items;
  double total;
}

class CartItem {
  String productoId;
  String vendorId;
  int cantidad;
  double precio;
}

class Pedido {
  String id;
  String buyerId;
  String vendorId;
  String estado; // pendiente, confirmado, enviado, entregado
  double montoTotal;
  String direccionEntrega;
  DateTime created_at;
}

class Resena {
  String id;
  String compradorId;
  String vendedorId;
  String? productoId;
  int calificacion; // 1-5
  String? comentario;
}
```

---

## 🚀 IMPLEMENTACIÓN EN FLUTTER

### Nuevos Providers

```dart
// Para autenticación y rol
class AuthProvider extends ChangeNotifier {
  String? userRole; // 'vendor' o 'buyer'
  bool isVendor => userRole == 'vendor';
  bool isBuyer => userRole == 'buyer';
}

// Para vendedores
class VendorProvider extends ChangeNotifier {
  Tienda? miTienda;
  List<Pedido> pedidosRecibidos = [];
  List<Resena> misResenas = [];
  
  Future<void> createTienda(Tienda tienda) async { }
  Future<void> loadPedidos() async { }
  Future<void> updateEstadoPedido(String pedidoId, String estado) async { }
}

// Para compradores
class BuyerProvider extends ChangeNotifier {
  Carrito carrito = Carrito();
  List<Pedido> misPedidos = [];
  List<Resena> misResenas = [];
  
  void agregarAlCarrito(CartItem item) { }
  void removerDelCarrito(String itemId) { }
  Future<void> confirmarPedido() async { }
  Future<void> dejarResena(Resena resena) async { }
}

// Para productos
class ProductosProvider extends ChangeNotifier {
  List<Producto> productosActivos = []; // Todos pueden ver
  List<Producto> misProductos = [];      // Solo vendedor ve los suyos
  
  Future<void> loadProductosActivos() async { } // Pública
  Future<void> loadMisProductos() async { }     // Solo vendor
}

// Para tiendas
class TiendasProvider extends ChangeNotifier {
  List<Tienda> tiendas = [];
  
  Future<void> loadTiendas() async { }
  Future<void> loadTiendaDetalles(String tiendaId) async { }
}
```

### Nuevas Pantallas

**VENDEDOR:**
- `PedidosScreen` - Ver y gestionar pedidos
- `EstadisticasTiendaScreen` - Analytics de tienda
- `ReseniasVendedorScreen` - Ver reseñas

**COMPRADOR:**
- `TiendasScreen` - Explorar tiendas
- `TiendaDetallesScreen` - Detalles de una tienda
- `CarritoScreen` - Ver carrito y confirmar compra
- `MisComprasScreen` - Historial de compras
- `DejarResenaScreen` - Hacer reseña

---

## 📝 CAMBIOS EN AUTENTICACIÓN

### Durante el Registro

```dart
// Antes: Solo email y contraseña
// Ahora: También pide ROL

if (rolSeleccionado == 'vendor') {
  // Pedir datos adicionales
  - Nombre de tienda
  - Descripción
  - Ciudad/País
  
  // Crear Tienda automáticamente
  await tiendaService.createTienda(tienda);
}

// Guardar en metadata de Supabase
await auth.signUp(
  email: email,
  password: password,
  userMetadata: {
    'nombre': nombre,
    'rol': rolSeleccionado,
    'nombreTienda': nombreTienda, // Si es vendor
  }
);
```

---

## 🔒 SEGURIDAD

### Validaciones Importantes

✅ **Vendedor solo ve sus datos**
- Productos propios
- Ventas propias
- Gastos propios
- Pedidos dirigidos a su tienda

✅ **Comprador solo puede**
- Ver productos activos
- Ver tiendas públicas
- Crear pedidos (asignándose como buyer_id)
- Ver sus compras

✅ **Reseñas**
- Solo quien compró puede dejar reseña
- No se pueden editar reseñas ajenas

---

## ✅ CHECKLIST IMPLEMENTACIÓN

### Backend (SQL)
- [x] Tablas creadas
- [x] RLS configurado
- [x] Índices añadidos
- [x] Triggers para updated_at

### Frontend (Flutter)
- [ ] Pantalla de selección Vendedor/Comprador
- [ ] Registro diferenciado por rol
- [ ] Screens vendedor (Tienda, Pedidos, Reseñas)
- [ ] Screens comprador (Tiendas, Carrito, Compras)
- [ ] Providers para cada rol
- [ ] Gestión de carrito
- [ ] Flujo de compra completo
- [ ] Sistema de reseñas
- [ ] Notificaciones

---

## 📚 PRÓXIMOS PASOS

1. **Ejecutar schema_marketplace.sql** en Supabase
2. **Crear pantalla de selección de rol** en registro
3. **Implementar providers** por rol
4. **Crear pantallas específicas** de vendor y buyer
5. **Testing completo**
6. **Documentar nuevas APIs**

---

*Sistema de Marketplace listo para implementación*  
*Fecha: 11 de diciembre de 2025*
