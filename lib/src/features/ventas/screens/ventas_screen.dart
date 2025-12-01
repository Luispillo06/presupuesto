import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Pantalla para gestionar las ventas
class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  // Datos de ejemplo para el MVP
  final List<Map<String, dynamic>> _ventas = [
    {
      'id': 1,
      'cliente': 'Cliente General',
      'monto': 85.00,
      'fecha': '01/12/2025',
      'productos': ['Producto A x2', 'Producto B x1'],
    },
    {
      'id': 2,
      'cliente': 'María García',
      'monto': 120.50,
      'fecha': '01/12/2025',
      'productos': ['Producto C x3'],
    },
    {
      'id': 3,
      'cliente': 'Juan Pérez',
      'monto': 45.00,
      'fecha': '30/11/2025',
      'productos': ['Producto A x1'],
    },
    {
      'id': 4,
      'cliente': 'Cliente General',
      'monto': 200.00,
      'fecha': '30/11/2025',
      'productos': ['Producto D x2', 'Producto E x4'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ventas.isEmpty ? _buildEmptyState() : _buildVentasList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVentaDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Venta'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.point_of_sale, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No hay ventas registradas',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pulsa el botón + para añadir tu primera venta',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildVentasList() {
    // Calcular total
    double totalVentas = _ventas.fold(0, (sum, venta) => sum + venta['monto']);

    return Column(
      children: [
        // Resumen de ventas
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.successColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Ventas',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Este mes',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                '€ ${totalVentas.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppTheme.successColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Lista de ventas
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _ventas.length,
            itemBuilder: (context, index) {
              final venta = _ventas[index];
              return _buildVentaCard(venta);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVentaCard(Map<String, dynamic> venta) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.successColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.shopping_cart, color: AppTheme.successColor),
        ),
        title: Text(
          venta['cliente'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              (venta['productos'] as List).join(', '),
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              venta['fecha'],
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        trailing: Text(
          '€ ${venta['monto'].toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppTheme.successColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => _showVentaDetails(venta),
      ),
    );
  }

  void _showVentaDetails(Map<String, dynamic> venta) {
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
                  'Venta #${venta['id']}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            _buildDetailRow('Cliente', venta['cliente']),
            _buildDetailRow('Fecha', venta['fecha']),
            _buildDetailRow(
              'Productos',
              (venta['productos'] as List).join(', '),
            ),
            const Divider(),
            _buildDetailRow(
              'Total',
              '€ ${venta['monto'].toStringAsFixed(2)}',
              isBold: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implementar edición
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
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
                      _deleteVenta(venta['id']);
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

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVentaDialog(BuildContext context) {
    final clienteController = TextEditingController();
    final montoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Venta'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: clienteController,
                decoration: const InputDecoration(
                  labelText: 'Cliente',
                  hintText: 'Nombre del cliente',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto (€)',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.euro),
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
              if (montoController.text.isNotEmpty) {
                setState(() {
                  _ventas.insert(0, {
                    'id': _ventas.length + 1,
                    'cliente': clienteController.text.isEmpty
                        ? 'Cliente General'
                        : clienteController.text,
                    'monto': double.tryParse(montoController.text) ?? 0.0,
                    'fecha': '01/12/2025',
                    'productos': ['Producto genérico'],
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Venta añadida correctamente'),
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

  void _deleteVenta(int id) {
    setState(() {
      _ventas.removeWhere((v) => v['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Venta eliminada'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }
}
