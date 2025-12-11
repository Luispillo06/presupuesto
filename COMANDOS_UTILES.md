# 🚀 Comandos Útiles - MarketMove

## Desarrollo

```bash
# Ejecutar en emulador/dispositivo
flutter run

# Ejecutar en modo release
flutter run --release

# Ejecutar con debug logs
flutter run -v

# Compilar APK para Android
flutter build apk

# Compilar AAB para Play Store
flutter build appbundle

# Limpiar y reconstruir
flutter clean
flutter pub get
flutter run
```

## Análisis y Testing

```bash
# Analizar código
flutter analyze

# Buscar problemas
flutter analyze --watch

# Ejecutar tests
flutter test

# Cobertura de tests
flutter test --coverage
```

## Base de Datos

```bash
# Ver logs de Supabase en tiempo real
supabase start

# Conectar a Supabase
supabase login

# Aplicar migraciones SQL
supabase db push
```

## Dependencias

```bash
# Obtener todas las dependencias
flutter pub get

# Actualizar dependencias
flutter pub upgrade

# Ver dependencias obsoletas
flutter pub outdated

# Limpiar caché
flutter clean

# Reconstruir Generated files
flutter pub get
```

## Debugging

```bash
# Ver logs detallados
flutter logs

# Conectar a devtools
flutter pub global activate devtools
devtools

# Ver estructura de widgets
flutter run -d emulator-5554 --show-widget-inspector
```

## Build y Deploy

```bash
# Android
flutter build apk --release
# Archivo: build/app/outputs/apk/release/app-release.apk

# iOS
flutter build ios --release

# Web
flutter build web

# Windows
flutter build windows
```

## Documentación en Código

```bash
# Generar documentación
dart doc
```

## Información del Proyecto

```bash
# Ver información del SDK
flutter --version

# Ver dispositivos conectados
flutter devices

# Ver config de Flutter
flutter config

# Ver ubicación de Flutter SDK
which flutter
```

## Formateo y Limpieza

```bash
# Formatear código
dart format lib/

# Analizar y formatear todo
dart fix --apply
flutter analyze

# Remover archivos no usados
dart fix --apply --allow-dirty
```

## Workflow Recomendado

### Desarrollo Diario
```bash
# 1. Empezar
flutter clean
flutter pub get

# 2. Desarrollar
flutter run

# 3. Verificar Calidad
flutter analyze
dart format lib/

# 4. Commit
git add .
git commit -m "feat: nueva funcionalidad"
```

### Antes de Deploy
```bash
# 1. Limpiar
flutter clean

# 2. Obtener dependencias
flutter pub get

# 3. Analizar
flutter analyze

# 4. Ejecutar tests
flutter test

# 5. Build Release
flutter build apk --release

# 6. Verificar APK
ls -lh build/app/outputs/apk/release/
```

## Atajos de Teclado (En Debug)

- `r` - Hot reload (actualizar app manteniendo estado)
- `R` - Hot restart (reiniciar app)
- `h` - Lista de ayuda
- `d` - Desconectar debugger
- `q` - Salir

## Troubleshooting Rápido

```bash
# Problema: Dependencias conflictivas
Solución: flutter pub get

# Problema: Cache corrupto
Solución: flutter clean && flutter pub get

# Problema: Emulador lento
Solución: flutter run --release

# Problema: App no compila
Solución: flutter analyze (ver qué está mal)

# Problema: Cambios no se ven
Solución: Presionar 'R' en consola (hot restart)
```

## Git Workflow

```bash
# Ver cambios
git status

# Agregar cambios
git add lib/

# Commit
git commit -m "feat: descripción del cambio"

# Ver historial
git log --oneline

# Push a repositorio
git push origin main

# Pull cambios
git pull origin main
```

## Documentación de Código

Para los comentarios en el código:

```dart
/// Descripción breve de la clase
/// 
/// Descripción más detallada si es necesaria.
/// Puede incluir ejemplos de uso.
class MiClase {
  /// Descripción del método
  /// 
  /// Devuelve: [tipo de retorno]
  /// Throws: [excepciones posibles]
  void miMetodo() {}
}
```

## Performance

```bash
# Ejecutar en modo profile (mejor que debug)
flutter run --profile

# Ver frame rendering
flutter run --profile
# Luego presionar 'P' para toggle rendering info

# Analizar Memory
flutter run --profile
# DevTools → Memory tab
```

---

**Tip**: Mantén estos comandos a mano para desarrollo rápido.

Más info: `flutter help`
