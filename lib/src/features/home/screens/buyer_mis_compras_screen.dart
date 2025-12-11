import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/compras_provider.dart';

/// Pantalla de mis compras para COMPRADORES
class BuyerMisComprasScreen extends StatefulWidget {
  const BuyerMisComprasScreen({super.key});

  @override
  State<BuyerMisComprasScreen> createState() => _BuyerMisComprasScreenState();
}

class _BuyerMisComprasScreenState extends State<BuyerMisComprasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComprasProvider>().loadComprasDelComprador();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📦 Mis Compras'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<ComprasProvider>(
        builder: (context, comprasProvider, _) {
          if (comprasProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final compras = comprasProvider.compras;

          if (compras.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sin compras aún',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Realiza tu primera compra en el marketplace',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ir al Marketplace'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => comprasProvider.loadComprasDelComprador(),
            child: ListView.builder(
              itemCount: compras.length,
              itemBuilder: (context, index) {
                final compra = compras[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Card(
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.shopping_bag,
                        color: Colors.blue,
                      ),
                      title: Text('Compra #${compra.id}'),
                      subtitle: Text(compra.fechaFormateada),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${compra.precioTotal}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            compra.estadoEspanol,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetalleRow(
                                'Producto ID:',
                                '${compra.productoId}',
                              ),
                              _buildDetalleRow(
                                'Cantidad:',
                                '${compra.cantidad}',
                              ),
                              _buildDetalleRow(
                                'Precio Unitario:',
                                '\$${compra.precioUnitario}',
                              ),
                              _buildDetalleRow(
                                'Total:',
                                '\$${compra.precioTotal}',
                              ),
                              _buildDetalleRow('Estado:', compra.estadoEspanol),
                              _buildDetalleRow(
                                'Fecha:',
                                compra.fechaFormateada,
                              ),
                              const SizedBox(height: 12),
                              if (compra.estado == 'pendiente')
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      _cancelarCompra(
                                        context,
                                        compra.id!,
                                        comprasProvider,
                                      );
                                    },
                                    child: const Text('Cancelar compra'),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetalleRow(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
          Text(valor, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  void _cancelarCompra(
    BuildContext context,
    int compraId,
    ComprasProvider comprasProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar compra'),
        content: const Text(
          '¿Estás seguro de que deseas cancelar esta compra?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final success = await comprasProvider.cancelarCompra(compraId);

              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Compra cancelada'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('❌ Error al cancelar'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }
}
