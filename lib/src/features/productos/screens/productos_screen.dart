import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Pantalla para gestionar productos y stock
class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  // Datos de ejemplo para el MVP
  final List<Map<String, dynamic>> _productos = [
    {
      'id': 1,
      'nombre': 'Producto A',
      'precio': 25.00,
      'stock': 15,
      'stockMinimo': 5,
      'categoria': 'General',
    },
    {
      'id': 2,
      'nombre': 'Producto B',
      'precio': 45.50,
      'stock': 3,
      'stockMinimo': 5,
      'categoria': 'Electrónica',
    },
    {
      'id': 3,
      'nombre': 'Producto C',
      'precio': 12.00,
      'stock': 50,
      'stockMinimo': 10,
      'categoria': 'General',
    },
    {
      'id': 4,
      'nombre': 'Producto D',
      'precio': 89.99,
      'stock': 2,
      'stockMinimo': 3,
      'categoria': 'Premium',
    },
    {
      'id': 5,
      'nombre': 'Producto E',
      'precio': 8.50,
      'stock': 100,
      'stockMinimo': 20,
      'categoria': 'Básico',
    },
    {
      'id': 6,
      'nombre': 'Producto F',
      'precio': 35.00,
      'stock': 1,
      'stockMinimo': 5,
      'categoria': 'General',
    },
  ];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> get _productosFiltrados {
    if (_searchQuery.isEmpty) return _productos;
    return _productos
        .where(
          (p) => p['nombre'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  int get _productosStockBajo {
    return _productos.where((p) => p['stock'] <= p['stockMinimo']).length;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra de búsqueda
          _buildSearchBar(),

          // Alerta de stock bajo
          if (_productosStockBajo > 0) _buildStockAlert(),

          // Lista de productos
          Expanded(
            child: _productosFiltrados.isEmpty
                ? _buildEmptyState()
                : _buildProductosList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductoDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildStockAlert() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.warningColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: AppTheme.warningColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$_productosStockBajo producto(s) con stock bajo',
              style: const TextStyle(color: AppTheme.warningColor),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Filtrar solo productos con stock bajo
            },
            child: const Text('Ver'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'No hay productos registrados'
                : 'No se encontraron productos',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildProductosList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _productosFiltrados.length,
      itemBuilder: (context, index) {
        final producto = _productosFiltrados[index];
        return _buildProductoCard(producto);
      },
    );
  }

  Widget _buildProductoCard(Map<String, dynamic> producto) {
    final bool stockBajo = producto['stock'] <= producto['stockMinimo'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Imagen placeholder del producto
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory,
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                // Información del producto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        producto['nombre'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          producto['categoria'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Precio
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '€ ${producto['precio'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Stock y acciones
            Row(
              children: [
                // Indicador de stock
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: stockBajo
                          ? AppTheme.errorColor.withOpacity(0.1)
                          : AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          stockBajo ? Icons.warning : Icons.check_circle,
                          size: 16,
                          color: stockBajo
                              ? AppTheme.errorColor
                              : AppTheme.successColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Stock: ${producto['stock']} uds',
                          style: TextStyle(
                            color: stockBajo
                                ? AppTheme.errorColor
                                : AppTheme.successColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Botones de acción rápida
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  color: AppTheme.errorColor,
                  onPressed: () => _updateStock(producto['id'], -1),
                  tooltip: 'Reducir stock',
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppTheme.successColor,
                  onPressed: () => _updateStock(producto['id'], 1),
                  tooltip: 'Aumentar stock',
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showProductoOptions(producto),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateStock(int id, int change) {
    setState(() {
      final index = _productos.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        final newStock = _productos[index]['stock'] + change;
        if (newStock >= 0) {
          _productos[index]['stock'] = newStock;
        }
      }
    });
  }

  void _showProductoOptions(Map<String, dynamic> producto) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  producto['nombre'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            _buildDetailRow(
              'Precio',
              '€ ${producto['precio'].toStringAsFixed(2)}',
            ),
            _buildDetailRow('Stock actual', '${producto['stock']} unidades'),
            _buildDetailRow(
              'Stock mínimo',
              '${producto['stockMinimo']} unidades',
            ),
            _buildDetailRow('Categoría', producto['categoria']),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditStockDialog(producto);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar Stock'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteProducto(producto['id']);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          Text(value),
        ],
      ),
    );
  }

  void _showEditStockDialog(Map<String, dynamic> producto) {
    final stockController = TextEditingController(
      text: producto['stock'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Stock - ${producto['nombre']}'),
        content: TextField(
          controller: stockController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Nuevo stock',
            prefixIcon: Icon(Icons.inventory),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(stockController.text);
              if (newStock != null && newStock >= 0) {
                setState(() {
                  final index = _productos.indexWhere(
                    (p) => p['id'] == producto['id'],
                  );
                  if (index != -1) {
                    _productos[index]['stock'] = newStock;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Stock actualizado'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showAddProductoDialog(BuildContext context) {
    final nombreController = TextEditingController();
    final precioController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  prefixIcon: Icon(Icons.inventory),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: precioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Precio (€)',
                  prefixIcon: Icon(Icons.euro),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock inicial',
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreController.text.isNotEmpty) {
                setState(() {
                  _productos.add({
                    'id': _productos.length + 1,
                    'nombre': nombreController.text,
                    'precio': double.tryParse(precioController.text) ?? 0.0,
                    'stock': int.tryParse(stockController.text) ?? 0,
                    'stockMinimo': 5,
                    'categoria': 'General',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Producto añadido correctamente'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteProducto(int id) {
    setState(() {
      _productos.removeWhere((p) => p['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Producto eliminado'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }
}
