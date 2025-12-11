# 📚 GUÍA PARA CREAR EL REPOSITORIO EN GITHUB

Esta guía te ayudará a crear un repositorio profesional en GitHub con toda la documentación necesaria.

---

## 1️⃣ CREAR REPOSITORIO EN GITHUB

### Paso 1: Acceder a GitHub

1. Ve a [https://github.com](https://github.com)
2. Inicia sesión con tu cuenta (o crea una nueva)
3. Haz clic en el ➕ arriba a la derecha
4. Selecciona "New repository"

### Paso 2: Configurar el Repositorio

Completa los siguientes campos:

```
Repository name: presupuesto
Description: Aplicación de Gestión de Presupuestos en Flutter + Supabase
Visibility: Public (para que sea visible para todos)
Initialize this repository with:
  ✅ Add a README file
  ✅ Add .gitignore (Select: Dart)
  ✅ Choose a license (MIT License)
```

### Paso 3: Crear el Repositorio

Haz clic en **"Create repository"**

---

## 2️⃣ CLONAR Y CONFIGURAR LOCALMENTE

```bash
# Clonar el repositorio (cambiar URL según tu caso)
git clone https://github.com/tuusuario/presupuesto.git
cd presupuesto

# Configurar git (primera vez)
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

---

## 3️⃣ COPIAR ARCHIVOS DEL PROYECTO

```bash
# Desde el directorio del proyecto (donde está pubspec.yaml)
# Copiar todos los archivos al repositorio clonado

# Copiar contenido
cp -r presupuesto/* presupuesto/
cp presupuesto/.gitignore presupuesto/.gitignore

# O simplemente: copiar la carpeta "presupuesto" dentro de "presupuesto"
```

---

## 4️⃣ CONFIRMAR CAMBIOS (COMMIT)

```bash
# Ver estado
git status

# Agregar todos los archivos
git add .

# Crear commit
git commit -m "Initial commit: Proyecto presupuesto completo"

# Enviar a GitHub
git push origin main
```

---

## 5️⃣ AGREGAR DOCUMENTACIÓN PROFESIONAL

### .gitignore

Ya debería estar creado, pero verifica que incluya:

```
# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
build/

# Android
android/.gradle/
android/local.properties
android/.classpath
android/.project
android/.settings/
android/app/debug/
android/app/profile/
android/app/release/

# iOS
ios/Flutter/Flutter.podspec
ios/Flutter/Flutter.xcframework

# Web
web/assets

# Supabase
.env
.env.local

# General
.DS_Store
*.swp
*.swo
*~
.vscode/
.idea/
*.iml

# Test
coverage/
.coverage
```

### .gitattributes (Opcional)

```
# Dart
*.dart diff=dart
```

---

## 6️⃣ CREAR DOCUMENTO DE INICIO RÁPIDO

Crear archivo `QUICKSTART.md`:

```markdown
# 🚀 Inicio Rápido

## Requisitos
- Flutter 3.9.2+
- Dart 3.0+

## Instalación

1. Clonar el repositorio
\`\`\`bash
git clone https://github.com/tuusuario/presupuesto.git
cd presupuesto
\`\`\`

2. Instalar dependencias
\`\`\`bash
flutter pub get
\`\`\`

3. Ejecutar
\`\`\`bash
flutter run
\`\`\`

## Documentación
- [README.md](README.md) - Documentación completa
- [PRESUPUESTO.md](PRESUPUESTO.md) - Documento de presupuesto profesional
- [supabase/schema.sql](supabase/schema.sql) - Schema de base de datos
```

---

## 7️⃣ CREAR GITHUB PAGES (Opcional)

Para tener una página web del proyecto:

1. En GitHub, ve a Settings
2. Busca "GitHub Pages"
3. Selecciona source: main branch, /root
4. Espera a que se publique (aparecerá un link)

---

## 8️⃣ CREAR RELEASES

Para marcar versiones importantes:

1. Ve a "Releases" en GitHub
2. Haz clic en "Create a new release"
3. Tag version: `v1.0.0`
4. Release title: `Version 1.0.0 - Initial Release`
5. Description:
```
## ✨ Características
- ✅ Autenticación con Supabase
- ✅ Gestión de Productos
- ✅ Control de Ventas
- ✅ Seguimiento de Gastos
- ✅ Dashboard

## 🔧 Requisitos
- Flutter 3.9.2+
- Dart 3.0+

## 📋 Instalación
Ver [README.md](README.md)
```
6. Click "Publish release"

---

## 9️⃣ CONFIGURAR TOPICS (Etiquetas)

En la página principal del repo:

1. Haz clic en ⚙️ (Settings) a la derecha
2. En "About", agrega Topics:
   - flutter
   - dart
   - supabase
   - budget-app
   - financial-management

---

## 🔟 CREAR RAMAS PARA DESARROLLO

```bash
# Ver ramas
git branch -a

# Crear rama develop
git checkout -b develop
git push origin develop

# Crear rama para feature
git checkout -b feature/nueva-funcionalidad
# Hacer cambios...
git add .
git commit -m "Agregar nueva funcionalidad"
git push origin feature/nueva-funcionalidad

# Crear Pull Request desde GitHub UI
```

---

## 📋 TEMPLATE DE PULL REQUEST

Crear archivo `.github/pull_request_template.md`:

```markdown
## Descripción
Describe los cambios realizados

## Tipo de cambio
- [ ] Bug fix
- [ ] Nueva característica
- [ ] Mejora de documentación

## Checklist
- [ ] He leído la documentación
- [ ] El código está formateado (flutter format)
- [ ] No hay errores (flutter analyze)
- [ ] Pasé tests locales

## Screenshots (si aplica)
[Agregar imágenes si es UI]
```

---

## 🐛 TEMPLATE DE ISSUE

Crear archivo `.github/ISSUE_TEMPLATE/bug_report.md`:

```markdown
---
name: Reporte de Bug
about: Reportar un problema
---

## Descripción del Bug
Describe claramente qué está mal

## Pasos para reproducir
1. Haz esto
2. Luego esto
3. Ocurre el error

## Comportamiento esperado
Qué debería pasar

## Screenshots
Si aplica

## Información del Sistema
- Flutter version: (flutter --version)
- Dart version: (dart --version)
- Dispositivo: iOS/Android/Web/Windows
```

---

## 📊 AÑADIR BADGES

En el README.md (al inicio):

```markdown
![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![GitHub](https://img.shields.io/badge/GitHub-presupuesto-black.svg)
![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen.svg)
```

---

## ✅ VERIFICACIÓN FINAL

Antes de considerar completado:

- [ ] README.md profesional y completo
- [ ] PRESUPUESTO.md con documentación comercial
- [ ] schema.sql en carpeta supabase/
- [ ] .gitignore configurado
- [ ] Licencia MIT agregada
- [ ] Topics relevantes añadidos
- [ ] Descripción y URL del proyecto (si aplica)
- [ ] Código sin errores (flutter analyze)
- [ ] Documentación clara en archivos

---

## 📞 ESTRUCTURA FINAL ESPERADA

```
presupuesto/
├── .github/
│   ├── pull_request_template.md
│   └── ISSUE_TEMPLATE/
│       └── bug_report.md
├── lib/
│   ├── main.dart
│   ├── src/
│   │   ├── app.dart
│   │   ├── core/
│   │   ├── features/
│   │   └── shared/
│   └── assets/
├── supabase/
│   └── schema.sql
├── docs/
│   ├── ARQUITECTURA.md
│   ├── API.md
│   └── PRESUPUESTO_MARKETMOVE.md
├── test/
│   └── widget_test.dart
├── .env.example         # IMPORTANTE: No subir .env real!
├── .gitignore
├── analysis_options.yaml
├── pubspec.yaml
├── README.md            # Documentación completa
├── PRESUPUESTO.md       # Documento comercial
├── QUICKSTART.md        # Inicio rápido
└── LICENSE              # MIT License
```

---

## 🚀 COMANDOS ÚTILES FINALES

```bash
# Formatear código
flutter format .

# Analizar código
flutter analyze

# Ver cambios
git diff

# Historial de commits
git log --oneline

# Ver contribuciones
git shortlog -s -n

# Sincronizar con remoto
git pull origin main
git push origin main
```

---

## 📝 NOTAS IMPORTANTES

1. **NUNCA subir .env** con credenciales reales
2. Usar `.env.example` como plantilla
3. Agregar en .gitignore: `.env` y `.env.local`
4. Documentar bien cada cambio
5. Usar commits claros y descriptivos
6. Hacer Code Review antes de merge

---

## 🎉 ¡LISTO!

Tu repositorio profesional está configurado y listo para presentar.

**Próximos pasos:**
1. Compartir link del repositorio
2. Invitar colaboradores si necesario
3. Documentar en issues los próximos cambios
4. Hacer releases periódicas

---

*Actualizado: 11 de diciembre de 2025*
