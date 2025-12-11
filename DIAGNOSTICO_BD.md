# 🔍 Diagnóstico de Base de Datos

## Problema Identificado
Hay inconsistencia entre el schema.sql y la base de datos real.

### Schema.sql dice:
```sql
CREATE TABLE productos (
    user_id UUID NOT NULL ...
```

### Tu screenshot muestra:
- Columna: `usuario_id` (con "io")

## ✅ SOLUCIÓN: Verificar en Supabase

1. Ve a: https://supabase.com/dashboard/project/enrfzuuolscflkcsengw
2. Haz clic en **Table Editor**
3. Selecciona tabla **productos**
4. Verifica el nombre EXACTO de la columna UUID

### Si la columna se llama `user_id`:
El código ya está correcto con `usuario_id` en data_service.dart

### Si la columna se llama `usuario_id`:
Perfecto, el código actual debería funcionar.

## 🔧 Opción Alternativa: Actualizar la BD

Ejecuta esto en **SQL Editor** de Supabase para unificar nombres:

```sql
-- Renombrar columnas si es necesario
ALTER TABLE productos RENAME COLUMN usuario_id TO user_id;
ALTER TABLE ventas RENAME COLUMN usuario_id TO user_id;
ALTER TABLE gastos RENAME COLUMN usuario_id TO user_id;

-- O al revés si prefieres usuario_id:
ALTER TABLE productos RENAME COLUMN user_id TO usuario_id;
ALTER TABLE ventas RENAME COLUMN user_id TO usuario_id;
ALTER TABLE gastos RENAME COLUMN user_id TO usuario_id;
```

## 📝 Estado Actual del Código

El código usa: **`usuario_id`** en los 3 métodos create (productos, ventas, gastos)
