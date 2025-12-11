# � PRESUPUESTO - Aplicación de Gestión Financiera

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen.svg)

Una **aplicación multiplataforma moderna** para gestionar presupuestos, ventas y gastos de forma profesional. Desarrollada con **Flutter** y **Supabase**, disponible en iOS, Android, Web y Escritorio.

---

## 🎯 Características Principales

✅ **Autenticación Segura**
- Registro e inicio de sesión con email
- Validación de contraseña
- Protección de datos con Supabase Auth

✅ **Gestión de Productos**
- Crear productos con nombre, descripción, precio, stock
- Categorización de productos
- Stock mínimo para alertas
- Código de barras opcional

✅ **Control de Ventas**
- Registrar ventas con cliente y monto
- Detalles de productos vendidos
- Notas y observaciones
- Historial completo de transacciones

✅ **Seguimiento de Gastos**
- Categorización automática
- Detalles de concepto y monto
- Notas descriptivas
- Reportes por categoría

✅ **Resumen Financiero**
- Dashboard visual
- Totales por categoría
- Gráficos de desempeño
- Estadísticas en tiempo real

✅ **Diseño Profesional**
- Interfaz intuitiva y limpia
- Colores código: Azul (Productos), Verde (Ventas), Rojo (Gastos)
- Responsive en todas las pantallas
- Animaciones fluidas

✅ **Sincronización en la Nube**
- Datos almacenados en Supabase
- Sincronización automática
- Acceso desde cualquier dispositivo
- Backup seguro

---

## 📋 Requisitos Técnicos

### Software Requerido

- **Flutter SDK**: 3.9.2 o superior
- **Dart**: 3.0 o superior
- **Git**: Para control de versiones
- **Visual Studio Code** o **Android Studio** (recomendado)

### Plataformas Soportadas

| Plataforma | Estado | Requisitos |
|------------|--------|-----------|
| **Android** | ✅ Completo | API 21+ |
| **iOS** | ✅ Completo | iOS 11+ |
| **Web** | ✅ Completo | Chrome, Firefox, Safari |
| **Windows** | ✅ Completo | Windows 10+ |
| **macOS** | ✅ Completo | macOS 10.11+ |
| **Linux** | ✅ Completo | Ubuntu 18.04+ |

### Dependencias Principales

```yaml
dependencies:
  flutter: sdk: flutter
  provider: ^6.1.2          # Gestión de estado
  supabase_flutter: ^2.8.0  # Backend y BD
  http: ^1.1.0              # Peticiones HTTP
  dotenv: ^4.2.0            # Variables de entorno
```

---

## 🚀 Cómo Ejecutar el Proyecto

### 1️⃣ Requisitos Previos

```bash
# Verificar que Flutter esté instalado
flutter doctor

# Debe mostrar "No issues found!" para que todo esté listo
```

### 2️⃣ Clonar el Repositorio

```bash
git clone https://github.com/tuusuario/presupuesto.git
cd presupuesto
```

### 3️⃣ Configurar Supabase

1. Ir a [https://supabase.com](https://supabase.com)
2. Crear un nuevo proyecto
3. Obtener las credenciales:
   - **Supabase URL**
   - **Supabase Anon Key**

4. Crear archivo `.env` en la raíz del proyecto:

```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key-aqui
```

5. Ejecutar el SQL en el editor de Supabase (archivo `supabase/schema.sql`):
   - Ir a SQL Editor en el dashboard de Supabase
   - Ejecutar todo el contenido del archivo `schema.sql`
   - Verificar que las tablas se crearon correctamente

### 4️⃣ Instalar Dependencias

```bash
flutter pub get
```

### 5️⃣ Ejecutar la Aplicación

#### 📱 En Emulador Android
```bash
flutter emulators --launch android_emulator
flutter run
```

#### 🍎 En Emulador iOS (solo macOS)
```bash
open -a Simulator
flutter run
```

#### 🌐 En Navegador Web
```bash
flutter run -d chrome
```

#### 💻 En Windows
```bash
flutter run -d windows
```

#### 🖥️ En macOS
```bash
flutter run -d macos
```

#### 🐧 En Linux
```bash
flutter run -d linux
```

### 6️⃣ Build para Producción

#### Android
```bash
flutter build apk --release
# O para AAB (Google Play):
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

---

## 📁 Estructura del Proyecto

```
presupuesto/
├── lib/
│   ├── main.dart                          # Punto de entrada
│   ├── src/
│   │   ├── app.dart                       # Configuración de la app
│   │   │
│   │   ├── core/
│   │   │   ├── supabase/
│   │   │   │   └── supabase_config.dart   # Configuración de Supabase
│   │   │   └── services/
│   │   │       ├── productos_service.dart
│   │   │       ├── ventas_service.dart
│   │   │       └── gastos_service.dart
│   │   │
│   │   ├── features/
│   │   │   ├── splash/
│   │   │   │   └── screens/splash_screen.dart
│   │   │   │
│   │   │   ├── auth/
│   │   │   │   ├── login/
│   │   │   │   └── register/
│   │   │   │
│   │   │   ├── home/
│   │   │   │   └── screens/home_screen.dart
│   │   │   │
│   │   │   ├── productos/
│   │   │   │   └── screens/
│   │   │   │       ├── productos_screen.dart
│   │   │   │       └── crear_producto_screen.dart
│   │   │   │
│   │   │   ├── ventas/
│   │   │   │   └── screens/
│   │   │   │       ├── ventas_screen.dart
│   │   │   │       └── crear_venta_screen.dart
│   │   │   │
│   │   │   ├── gastos/
│   │   │   │   └── screens/
│   │   │   │       ├── gastos_screen.dart
│   │   │   │       └── crear_gasto_screen.dart
│   │   │   │
│   │   │   └── resumen/
│   │   │       └── screens/resumen_screen.dart
│   │   │
│   │   ├── shared/
│   │   │   ├── models/
│   │   │   │   ├── producto_model.dart
│   │   │   │   ├── venta_model.dart
│   │   │   │   └── gasto_model.dart
│   │   │   │
│   │   │   ├── providers/
│   │   │   │   ├── auth_provider.dart
│   │   │   │   └── data_providers.dart
│   │   │   │
│   │   │   └── theme/
│   │   │       └── app_theme.dart
│   │   │
│   │   └── config/
│   │       └── routes.dart
│   │
│   └── assets/                            # Recursos (imágenes, iconos)
│       ├── images/
│       └── icons/
│
├── supabase/
│   └── schema.sql                         # Script de base de datos
│
├── test/
│   └── widget_test.dart                   # Tests
│
├── pubspec.yaml                           # Dependencias
├── analysis_options.yaml                  # Análisis de código
├── PRESUPUESTO.md                         # Documento de presupuesto
└── README.md                              # Este archivo
```

---

## 🏗️ Arquitectura

### Patrón de Diseño: Clean Architecture + Provider

```
┌─────────────────────────────────────┐
│      Presentation Layer (UI)        │
│  Screens, Widgets, Animaciones      │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│    Business Logic Layer (State)      │
│  Providers, Services, Validaciones   │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│    Data Layer (Supabase)            │
│  API, Base de Datos, Sincronización │
└─────────────────────────────────────┘
```

### Gestión de Estado: Provider

La aplicación usa **Provider** para gestionar el estado:

- **ProductosProvider**: Gestiona productos
- **VentasProvider**: Gestiona ventas
- **GastosProvider**: Gestiona gastos
- **AuthProvider**: Gestiona autenticación

```dart
// Ejemplo de uso
Consumer<ProductosProvider>(
  builder: (context, provider, _) {
    return ListView(
      children: provider.productos.map((p) => 
        ProductCard(producto: p)
      ).toList(),
    );
  },
)
```

---

## 🗄️ Base de Datos

### Schema (Supabase PostgreSQL)

La base de datos contiene las siguientes tablas:

**auth.users** (Gestionada por Supabase)
- Autenticación con email y contraseña
- Tokens JWT automáticos

**perfiles**
- Perfil de usuario
- Creado automáticamente con trigger

**productos**
```sql
- id (UUID)
- user_id (FK a auth.users)
- nombre (TEXT)
- descripcion (TEXT)
- precio (NUMERIC)
- stock (INTEGER)
- stock_minimo (INTEGER)
- categoria (TEXT)
- codigo_barras (TEXT)
- imagen_url (TEXT)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

**ventas**
```sql
- id (UUID)
- user_id (FK a auth.users)
- cliente (TEXT)
- monto (NUMERIC)
- productos (ARRAY)
- notas (TEXT)
- fecha (TIMESTAMP)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

**gastos**
```sql
- id (UUID)
- user_id (FK a auth.users)
- concepto (TEXT)
- categoria (TEXT)
- monto (NUMERIC)
- notas (TEXT)
- fecha (TIMESTAMP)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

### Row Level Security (RLS)

Todas las tablas tienen RLS habilitado:
- Los usuarios solo pueden ver SUS propios datos
- No pueden acceder a datos de otros usuarios
- Seguridad garantizada en la BD

---

## 🔐 Seguridad

✅ **Autenticación**
- Email y contraseña validados
- Contraseñas hasheadas por Supabase
- Tokens JWT automáticos

✅ **Autorización**
- Row Level Security en todas las tablas
- Aislamiento de datos por usuario
- Permisos granulares

✅ **Encriptación**
- HTTPS obligatorio
- Conexión segura a Supabase
- Variables de entorno para credenciales

---

## 🧪 Testing

### Pruebas Unitarias

```bash
flutter test
```

### Pruebas de Widget

```bash
flutter test test/widget_test.dart
```

### Pruebas de Integración (Supabase)

Verificar conexión manual:
1. Ir a Supabase Dashboard
2. Ver datos en "Table Editor"
3. Crear un registro desde la app
4. Verificar que aparece en la BD

---

## 📱 Flujo de Usuario

```
┌─────────────┐
│  Splash     │ → Carga inicial (2 segundos)
└──────┬──────┘
       │
       ▼
┌──────────────┐
│    Login     │ → Ingresar email y contraseña
└──────┬───────┘
       │ ┌─ Nuevo usuario
       │ ▼
       │ ┌──────────────┐
       │ │   Register   │ → Crear cuenta
       │ └──────┬───────┘
       │        │
       └────┬───┘
            │
            ▼
┌──────────────────┐
│   Home Screen    │ → Dashboard principal
├──────────────────┤
│ - Resumen        │ → Vista general
│ - Ventas ✒️       │ → CRUD de ventas
│ - Gastos ✒️       │ → CRUD de gastos
│ - Productos ✒️    │ → CRUD de productos
└──────────────────┘
```

---

## 🎨 Paleta de Colores

| Elemento | Color | Código |
|----------|-------|--------|
| **Productos** | 🔵 Azul | `Colors.blue` |
| **Ventas** | 🟢 Verde | `Colors.green` |
| **Gastos** | 🔴 Rojo | `Colors.red` |
| **Resumen** | ⚫ Gris | `Colors.grey` |
| **Primary** | 🔵 Azul | `#2196F3` |
| **Success** | 🟢 Verde | `#4CAF50` |
| **Error** | 🔴 Rojo | `#F44336` |

---

## 🐛 Troubleshooting

### "No se conecta a Supabase"
- ✅ Verificar que el `.env` está configurado
- ✅ Verificar que las credenciales son correctas
- ✅ Verificar conexión a internet
- ✅ Revisar logs en Android Studio/VS Code

### "No puedo registrarme"
- ✅ Usar un email válido (contiene @)
- ✅ Contraseña mínimo 6 caracteres
- ✅ Esperar confirmación de email (si es requerido en Supabase)

### "Los datos no se guardan"
- ✅ Verificar que ejecutaste el `schema.sql` en Supabase
- ✅ Verificar que estás autenticado
- ✅ Revisar en Supabase Dashboard → Table Editor

### "La app se ve distinto en iOS vs Android"
- ✅ Normal, Flutter usa Material en Android e iOS se adapta
- ✅ Todos los datos funcionan igual
- ✅ La experiencia es equivalente

---

## 🚀 Despliegue

### Publicación en Play Store (Android)
```bash
flutter build appbundle --release
# Subir a Google Play Console
```

### Publicación en App Store (iOS)
```bash
flutter build ios --release
# Subir a Apple App Store Connect
```

### Deploy en Web
```bash
flutter build web --release
# Subir la carpeta 'build/web' a tu hosting
```

---

## 👥 Integrantes del Equipo

| Rol | Nombre | Responsabilidad |
|-----|--------|-----------------|
| **Líder** | [Nombre] | Coordinación general |
| **Frontend** | [Nombre] | Desarrollo de UI |
| **Backend** | [Nombre] | Integración Supabase |
| **Testing** | [Nombre] | QA y pruebas |
| **DevOps** | [Nombre] | Deploy y publicación |

---

## 📄 Licencia

Este proyecto está bajo la licencia **MIT**. Ver archivo [LICENSE](LICENSE) para más detalles.

---

## 📚 Documentación Adicional

- [PRESUPUESTO.md](PRESUPUESTO.md) - Documento comercial y presupuesto
- [docs/ARQUITECTURA.md](docs/ARQUITECTURA.md) - Detalles técnicos de arquitectura
- [docs/API.md](docs/API.md) - Documentación de servicios
- [supabase/schema.sql](supabase/schema.sql) - Script de base de datos

---

## 🌟 Versión Actual

**v1.0.0** - Release inicial  
**Fecha:** 11 de diciembre de 2025  
**Estado:** ✅ Production Ready

---

**Made with ❤️ by Equipo Presupuesto**
