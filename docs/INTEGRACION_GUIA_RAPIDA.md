# Guía de Integración Rápida del Sistema Funcional

## Paso 1: Importar el Provider en la Pantalla

```dart
import 'package:provider/provider.dart';
import '../../../shared/providers/data_providers.dart';
```

## Paso 2: Envolver la Pantalla con MultiProvider

En `home_screen.dart`, envolveremos el PageView:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ProductosProvider()),
    ChangeNotifierProvider(create: (_) => VentasProvider()),
    ChangeNotifierProvider(create: (_) => GastosProvider()),
    ChangeNotifierProvider(create: (_) => ResumenProvider()),
  ],
  child: _buildPageView(),
)
```

## Paso 3: Usar en Pantallas

### ProductosScreen - Cargar Lista
```dart
@override
Widget build(BuildContext context) {
  final productosProvider = Provider.of<ProductosProvider>(context);
  
  if (productosProvider.isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  
  if (productosProvider.error != null) {
    return Center(child: Text('Error: ${productosProvider.error}'));
  }
  
  final productos = productosProvider.productos;
  
  return ListView.builder(
    itemCount: productos.length,
    itemBuilder: (ctx, i) => _buildProductCard(productos[i]),
  );
}
```

### Agregar Nuevo Producto
```dart
Future<void> _showAddProductDialog(BuildContext context) async {
  // ... obtener datos del formulario ...
  
  final nuevoProducto = Producto(
    nombre: nombreController.text,
    precio: double.parse(precioController.text),
    stock: int.parse(stockController.text),
    categoria: categoriaSeleccionada,
  );
  
  context.read<ProductosProvider>().addProducto(nuevoProducto);
}
```

### Actualizar Producto
```dart
Future<void> _updateProducto(Producto producto) async {
  final actualizado = producto.copyWith(
    nombre: nuevoNombre,
    precio: nuevoPrecio,
  );
  
  context.read<ProductosProvider>().updateProducto(actualizado);
}
```

### Eliminar Producto
```dart
Future<void> _deleteProducto(int id) async {
  context.read<ProductosProvider>().deleteProducto(id);
}
```

## Paso 4: Resumen en Tiempo Real

```dart
@override
Widget build(BuildContext context) {
  final resumenProvider = Provider.of<ResumenProvider>(context);
  
  return Column(
    children: [
      _BalanceCard(
        balance: resumenProvider.balance,
        ventas: resumenProvider.totalVentas,
        gastos: resumenProvider.totalGastos,
      ),
      _StatsRow(
        ventasHoy: resumenProvider.totalVentas,
        gastosHoy: resumenProvider.totalGastos,
        totalProductos: resumenProvider.totalProductos,
        stockBajo: resumenProvider.productosStockBajo,
      ),
    ],
  );
}
```

## Paso 5: Recargar Datos (Pull-to-Refresh)

```dart
Future<void> _refreshData(BuildContext context) async {
  await context.read<ProductosProvider>().loadProductos();
  await context.read<VentasProvider>().loadVentas();
  await context.read<GastosProvider>().loadGastos();
  await context.read<ResumenProvider>().loadResumen();
}

// En el Scaffold:
RefreshIndicator(
  onRefresh: () => _refreshData(context),
  child: _buildList(),
)
```

## Paso 6: Validación de Formularios

```dart
String? _validateProducto(String nombre, double precio, int stock) {
  if (nombre.isEmpty) return 'Nombre requerido';
  if (precio <= 0) return 'Precio debe ser mayor a 0';
  if (stock < 0) return 'Stock no puede ser negativo';
  return null;
}
```

## Troubleshooting

### Error: "Supabase not configured"
**Solución**: Asegúrate que `main.dart` inicia Supabase:
```dart
await Supabase.initialize(
  url: SUPABASE_URL,
  anonKey: SUPABASE_ANON_KEY,
);
```

### Error: "No data returned"
**Solución**: Verifica que:
1. Las tablas existen en Supabase
2. El usuario tiene permiso (RLS correcto)
3. Hay registros en la base de datos

### Error: "Context.read<> outside build"
**Solución**: Usa `WidgetsBinding.instance.addPostFrameCallback()`:
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<ProductosProvider>().loadProductos();
});
```

## Checklist de Integración

- [ ] Importar providers en pantalla
- [ ] Envolver con MultiProvider en HomeScreen
- [ ] Reemplazar datos hardcodeados con `productosProvider.productos`
- [ ] Conectar botones agregar/actualizar/eliminar
- [ ] Agregar RefreshIndicator
- [ ] Manejar estados de carga y error
- [ ] Probar crear, leer, actualizar, eliminar
- [ ] Probar sincronización entre pantallas
- [ ] Validar datos antes de enviar

## Ejemplo Completo de Pantalla

Ver `ProductosScreenIntegrada.dart.example` en esta carpeta.
