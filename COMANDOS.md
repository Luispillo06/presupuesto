# 🛠️ COMANDOS ÚTILES - MARKETMOVE

## Comandos para ejecutar el proyecto

### Verificar instalación de Flutter
```powershell
flutter doctor
```

### Instalar dependencias
```powershell
cd "c:\Users\equipo\Documents\Presupuesto\presupuesto"
flutter pub get
```

### Ejecutar la aplicación

#### En Windows (recomendado para desarrollo rápido)
```powershell
flutter run -d windows
```

#### En Android (requiere emulador o dispositivo)
```powershell
flutter run -d android
```

#### En Chrome (web)
```powershell
flutter run -d chrome
```

### Ver dispositivos disponibles
```powershell
flutter devices
```

---

## Comandos de análisis

### Analizar código (buscar errores)
```powershell
flutter analyze
```

### Formatear código
```powershell
dart format .
```

### Limpiar proyecto
```powershell
flutter clean
flutter pub get
```

---

## Comandos de compilación

### Generar APK (Android)
```powershell
flutter build apk --release
```

### Generar Windows EXE
```powershell
flutter build windows --release
```

### Ver versión de Flutter
```powershell
flutter --version
```

---

## Comandos Git (opcional)

### Ver estado
```powershell
git status
```

### Hacer commit
```powershell
git add .
git commit -m "Descripción del cambio"
```

### Push a GitHub
```powershell
git push origin main
```

---

## Para la presentación

### 1. Abrir el proyecto en VS Code
```powershell
cd "c:\Users\equipo\Documents\Presupuesto\presupuesto"
code .
```

### 2. Ejecutar la app
```powershell
flutter run -d windows
```

### 3. Ver documentos
```powershell
# Ver presupuesto
start docs\PRESUPUESTO_MARKETMOVE.md

# Ver informe
start docs\INFORME_TRABAJO_SEMANAL.md

# Ver guía de entregables
start docs\GUIA_ENTREGABLES.md
```

---

## Solución de problemas

### Si hay errores de dependencias:
```powershell
flutter clean
flutter pub get
```

### Si no compila:
```powershell
flutter doctor
flutter analyze
```

### Si hay problemas con Windows:
```powershell
flutter config --enable-windows-desktop
```

---

## Estado actual del proyecto
✅ Código sin errores  
✅ Análisis estático pasado  
✅ Formato aplicado  
✅ Listo para ejecutar  
✅ Documentación completa  

---

**Última verificación:** 11 de diciembre de 2025  
**Estado:** ✅ TODO FUNCIONAL
