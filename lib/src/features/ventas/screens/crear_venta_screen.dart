import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/supabase/supabase_config.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/data_providers.dart';

class CrearVentaScreen extends StatefulWidget {
  const CrearVentaScreen({super.key});

  @override
  State<CrearVentaScreen> createState() => _CrearVentaScreenState();
}

class _CrearVentaScreenState extends State<CrearVentaScreen> {
  final _clienteController = TextEditingController();
  final _notasController = TextEditingController();
  
  // Lista de productos seleccionados para la venta
  // Map<Producto, Cantidad>
  final Map<Producto, int> _productosSeleccionados = {};
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Cargar productos disponibles al iniciar
    Future.microtask(() {
      if (mounted) {
        context.read<ProductosProvider>().loadProductosDisponibles();
      }
    });
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  double get _montoTotal {
    double total = 0;
    _productosSeleccionados.forEach((producto, cantidad) {
      total += producto.precio * cantidad;
    });
    return total;
  }

  void _create() async {
    if (SupabaseConfig.currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Debes estar autenticado')));
      return;
    }

    if (_clienteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el nombre del cliente')),
      );
      return;
    }

    if (_productosSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un producto')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Crear lista de strings para guardar en BD (Nombre xCantidad)
      List<String> productosString = [];
      _productosSeleccionados.forEach((producto, cantidad) {
        productosString.add('${producto.nombre} x$cantidad');
      });

      final venta = Venta(
        id: 0, // Se genera en BD
        cliente: _clienteController.text,
        monto: _montoTotal,
        fecha: DateTime.now(),
        productos: productosString,
        notas: _notasController.text.isNotEmpty ? _notasController.text : null,
      );

      // Usamos el provider para crear la venta
      // NOTA: El provider internamente llamará al servicio que actualizaremos
      // para descontar stock.
      final result = await context.read<VentasProvider>().addVenta(venta);

      if (mounted) {
        setState(() => _isLoading = false);
        if (result) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('✅ Venta creada exitosamente')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('❌ Error al crear venta')));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _mostrarSelectorProductos() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<ProductosProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.productos.isEmpty) {
                  return const Center(child: Text('No hay productos disponibles'));
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Seleccionar Productos',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: provider.productos.length,
                        itemBuilder: (context, index) {
                          final producto = provider.productos[index];
                          final yaSeleccionado = _productosSeleccionados.containsKey(producto);
                          
                          return ListTile(
                            title: Text(producto.nombre),
                            subtitle: Text('\$${producto.precio.toStringAsFixed(2)} - Stock: ${producto.stock}'),
                            trailing: yaSeleccionado 
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : const Icon(Icons.add_circle_outline),
                            onTap: () {
                              setState(() {
                                if (yaSeleccionado) {
                                  _productosSeleccionados.remove(producto);
                                } else {
                                  _productosSeleccionados[producto] = 1;
                                }
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Venta (POS)'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Datos del Cliente
                  TextField(
                    controller: _clienteController,
                    decoration: const InputDecoration(
                      labelText: 'Cliente *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Lista de Productos Seleccionados
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Productos',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton.icon(
                        onPressed: _mostrarSelectorProductos,
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  if (_productosSeleccionados.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text(
                            'No hay productos seleccionados',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _productosSeleccionados.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final producto = _productosSeleccionados.keys.elementAt(index);
                        final cantidad = _productosSeleccionados[producto]!;
                        
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(producto.nombre),
                          subtitle: Text('\$${producto.precio.toStringAsFixed(2)} x $cantidad'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${(producto.precio * cantidad).toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    if (cantidad > 1) {
                                      _productosSeleccionados[producto] = cantidad - 1;
                                    } else {
                                      _productosSeleccionados.remove(producto);
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  if (cantidad < producto.stock) {
                                    setState(() {
                                      _productosSeleccionados[producto] = cantidad + 1;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('No hay más stock disponible')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 16),
                  const Divider(thickness: 2),
                  const SizedBox(height: 16),
                  
                  // Notas
                  TextField(
                    controller: _notasController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notas',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Barra inferior con Total y Botón
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${_montoTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _create,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'CONFIRMAR VENTA',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
