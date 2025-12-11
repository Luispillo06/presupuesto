import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/data_providers.dart';
import 'crear_producto_screen.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ProductosProvider>().loadProductos();
      }
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductosProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredProductos = provider.productos.where((p) {
          return p.nombre.toLowerCase().contains(_searchQuery) ||
              p.categoria.toLowerCase().contains(_searchQuery);
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar producto',
                  hintText: 'Nombre o categoría',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
            ),
            Expanded(
              child: filteredProductos.isEmpty
                  ? const Center(child: Text('No se encontraron productos'))
                  : ListView.builder(
                      itemCount: filteredProductos.length,
                      itemBuilder: (context, index) {
                        final producto = filteredProductos[index];
                        final isLowStock = producto.stock <= (producto.stockMinimo ?? 5);

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isLowStock ? Colors.red.shade100 : Colors.blue.shade100,
                              child: Icon(
                                Icons.inventory_2,
                                color: isLowStock ? Colors.red : Colors.blue,
                              ),
                            ),
                            title: Text(
                              producto.nombre,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Categoría: ${producto.categoria}'),
                                Row(
                                  children: [
                                    Text(
                                      '\$${producto.precio.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Stock: ${producto.stock}',
                                      style: TextStyle(
                                        color: isLowStock ? Colors.red : Colors.black87,
                                        fontWeight: isLowStock ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    if (isLowStock) ...[
                                      const SizedBox(width: 4),
                                      const Icon(Icons.warning_amber, size: 16, color: Colors.red),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CrearProductoScreen(producto: producto),
                                ),
                              ).then((_) {
                                if (mounted) {
                                  context.read<ProductosProvider>().loadProductos();
                                }
                              });
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CrearProductoScreen(producto: producto),
                                      ),
                                    ).then((_) {
                                      if (mounted) {
                                        context.read<ProductosProvider>().loadProductos();
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Eliminar Producto'),
                                        content: Text('¿Estás seguro de eliminar "${producto.nombre}"?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await provider.deleteProducto(producto.id!);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
