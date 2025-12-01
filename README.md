# 🛒 MarketMove App

<p align="center">
  <img src="assets/images/logo_placeholder.png" alt="MarketMove Logo" width="200"/>
</p>

<p align="center">
  <strong>Aplicación de gestión para pequeños comercios</strong>
</p>

<p align="center">
  <a href="#descripción">Descripción</a> •
  <a href="#características">Características</a> •
  <a href="#tecnologías">Tecnologías</a> •
  <a href="#instalación">Instalación</a> •
  <a href="#estructura">Estructura</a> •
  <a href="#equipo">Equipo</a>
</p>

---

## 📋 Descripción

**MarketMove** es una aplicación móvil desarrollada para **MarketMove S.L.** que permite a los dueños de pequeños comercios gestionar de forma sencilla:

- 💰 **Ventas diarias** - Registro rápido de todas las ventas
- 📉 **Gastos** - Control de gastos del negocio
- 📦 **Inventario** - Gestión de productos y stock
- 📊 **Balance** - Visualización de ganancias y pérdidas

La aplicación está diseñada para ser **intuitiva y fácil de usar**, permitiendo que cualquier comerciante pueda llevar el control de su negocio desde el móvil.

---

## ✨ Características

### MVP (Versión Inicial)
- [x] Registro e inicio de sesión de usuarios
- [x] Pantalla de añadir/gestionar ventas
- [x] Pantalla de añadir/gestionar gastos
- [x] Pantalla de productos y control de stock
- [x] Panel de resumen con balance (ganancias - gastos)
- [x] Navegación intuitiva entre módulos

### Funcionalidades Futuras
- [ ] Notificaciones push
- [ ] Exportación de informes en PDF
- [ ] Modo offline
- [ ] Gráficos avanzados
- [ ] Multi-idioma

---

## 🛠️ Tecnologías

| Tecnología | Uso |
|------------|-----|
| ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) | Framework de desarrollo móvil |
| ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) | Lenguaje de programación |
| ![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white) | Backend y base de datos |
| ![Provider](https://img.shields.io/badge/Provider-FF6F00?style=flat&logo=flutter&logoColor=white) | Gestión de estado |

---

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
└── src/
    ├── app.dart              # Widget raíz de la aplicación
    ├── features/             # Módulos de funcionalidades
    │   ├── auth/             # Autenticación (login/registro)
    │   │   ├── screens/
    │   │   ├── widgets/
    │   │   └── providers/
    │   ├── ventas/           # Gestión de ventas
    │   │   ├── screens/
    │   │   ├── widgets/
    │   │   └── providers/
    │   ├── gastos/           # Gestión de gastos
    │   │   ├── screens/
    │   │   ├── widgets/
    │   │   └── providers/
    │   ├── productos/        # Gestión de productos/stock
    │   │   ├── screens/
    │   │   ├── widgets/
    │   │   └── providers/
    │   └── resumen/          # Dashboard y balance
    │       ├── screens/
    │       ├── widgets/
    │       └── providers/
    └── shared/               # Recursos compartidos
        ├── widgets/          # Widgets reutilizables
        ├── models/           # Modelos de datos
        ├── services/         # Servicios (API, DB)
        ├── providers/        # Providers globales
        ├── constants/        # Constantes y configuración
        ├── theme/            # Tema y estilos
        └── utils/            # Utilidades
assets/
├── images/                   # Imágenes de la app
└── icons/                    # Iconos personalizados
```

---

## 📅 Fases del Proyecto

| Fase | Descripción | Estado |
|------|-------------|--------|
| 1️⃣ | Análisis y Toma de Requisitos | ✅ Completado |
| 2️⃣ | Diseño UX/UI Básico | 🔄 En progreso |
| 3️⃣ | Arquitectura del Proyecto | ✅ Completado |
| 4️⃣ | Desarrollo Frontend Flutter | 🔄 En progreso |
| 5️⃣ | Integración con Supabase | ⏳ Pendiente |
| 6️⃣ | Pruebas Funcionales | ⏳ Pendiente |
| 7️⃣ | Documentación Final | ⏳ Pendiente |
| 8️⃣ | Entrega y Publicación | ⏳ Pendiente |

---

## 💻 Requisitos Técnicos

### Requisitos del Sistema de Desarrollo
- **Flutter SDK:** >= 3.9.2
- **Dart SDK:** >= 3.9.2
- **Android Studio** o **VS Code** con extensiones de Flutter
- **Git** para control de versiones

### Requisitos Mínimos de Dispositivos
- **Android:** API 21+ (Android 5.0 Lollipop)
- **iOS:** iOS 12.0+

### Dependencias Principales
```yaml
dependencies:
  flutter: sdk
  provider: ^6.0.0          # Gestión de estado
  supabase_flutter: ^2.0.0  # Backend
  go_router: ^13.0.0        # Navegación
  intl: ^0.18.0             # Internacionalización
```

---

## 🚀 Instalación y Ejecución

### Prerrequisitos
1. Tener instalado [Flutter](https://flutter.dev/docs/get-started/install)
2. Tener un editor de código (recomendado: VS Code o Android Studio)
3. Tener un emulador o dispositivo físico conectado

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/tu-usuario/marketmove_app.git
cd marketmove_app
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar variables de entorno** (si aplica)
```bash
cp .env.example .env
# Editar .env con tus credenciales de Supabase
```

4. **Ejecutar la aplicación**
```bash
# En modo debug
flutter run

# Para Android específicamente
flutter run -d android

# Para iOS específicamente
flutter run -d ios

# Para web
flutter run -d chrome
```

### Comandos Útiles
```bash
# Verificar estado del proyecto
flutter doctor

# Limpiar y reconstruir
flutter clean && flutter pub get

# Generar APK de release
flutter build apk --release

# Generar IPA de release (requiere macOS)
flutter build ios --release

# Ejecutar tests
flutter test
```

---

## 👥 Equipo de Desarrollo

| Nombre | Rol | Contacto |
|--------|-----|----------|
| [Nombre Alumno 1] | Desarrollador Principal | [email] |
| [Nombre Alumno 2] | Desarrollador Frontend | [email] |
| [Nombre Alumno 3] | Diseñador UX/UI | [email] |

---

## 📄 Documentación Adicional

- 📋 [Presupuesto del Proyecto](docs/PRESUPUESTO_MARKETMOVE.md)
- 📖 [Manual de Usuario](docs/MANUAL_USUARIO.md) *(próximamente)*
- 🔧 [Documentación Técnica](docs/DOCUMENTACION_TECNICA.md) *(próximamente)*

---

## 📝 Licencia

Este proyecto es privado y pertenece a **MarketMove S.L.**  
Todos los derechos reservados © 2025

---

## 📞 Contacto

**MarketMove S.L.**  
📧 Email: contacto@marketmove.es  
🌐 Web: www.marketmove.es

---

<p align="center">
  Desarrollado con ❤️ usando Flutter
</p>
