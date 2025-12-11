import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/data_providers.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<VentasProvider>().loadVentas();
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
    return Consumer<VentasProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredVentas = provider.ventas.where((v) {
          return v.cliente.toLowerCase().contains(_searchQuery);
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar venta',
                  hintText: 'Nombre del cliente',
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
              child: filteredVentas.isEmpty
                  ? const Center(child: Text('No hay ventas registradas'))
                  : ListView.builder(
                      itemCount: filteredVentas.length,
                      itemBuilder: (context, index) {
                        final venta = filteredVentas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: const Icon(Icons.attach_money, color: Colors.green),
                            ),
                            title: Text(
                              venta.cliente,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${venta.fecha.day}/${venta.fecha.month}/${venta.fecha.year} - \$${venta.monto.toStringAsFixed(2)}',
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Productos:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    ...venta.productos.map((p) => Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.grey),
                                              const SizedBox(width: 8),
                                              Text(p),
                                            ],
                                          ),
                                        )),
                                    if (venta.notas != null && venta.notas!.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Notas:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(venta.notas!),
                                    ],
                                    const SizedBox(height: 16),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        label: const Text('Eliminar Venta', style: TextStyle(color: Colors.red)),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Eliminar Venta'),
                                              content: const Text('¿Estás seguro? Esto no devolverá el stock automáticamente.'),
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
                                            await provider.deleteVenta(venta.id!);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
