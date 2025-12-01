import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

/// Pantalla para gestionar los gastos
class GastosScreen extends StatefulWidget {
  const GastosScreen({super.key});

  @override
  State<GastosScreen> createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  // Categorías de gastos
  final List<String> _categorias = [
    'Todos',
    'Proveedores',
    'Servicios',
    'Personal',
    'Otros',
  ];
  String _categoriaSeleccionada = 'Todos';

  // Datos de ejemplo para el MVP
  final List<Map<String, dynamic>> _gastos = [
    {
      'id': 1,
      'concepto': 'Compra a Proveedor ABC',
      'categoria': 'Proveedores',
      'monto': 250.00,
      'fecha': '01/12/2025',
    },
    {
      'id': 2,
      'concepto': 'Factura de Luz',
      'categoria': 'Servicios',
      'monto': 75.50,
      'fecha': '30/11/2025',
    },
    {
      'id': 3,
      'concepto': 'Salario empleado',
      'categoria': 'Personal',
      'monto': 1200.00,
      'fecha': '28/11/2025',
    },
    {
      'id': 4,
      'concepto': 'Material de oficina',
      'categoria': 'Otros',
      'monto': 45.00,
      'fecha': '25/11/2025',
    },
    {
      'id': 5,
      'concepto': 'Internet y teléfono',
      'categoria': 'Servicios',
      'monto': 60.00,
      'fecha': '20/11/2025',
    },
  ];

  List<Map<String, dynamic>> get _gastosFiltrados {
    if (_categoriaSeleccionada == 'Todos') {
      return _gastos;
    }
    return _gastos
        .where((g) => g['categoria'] == _categoriaSeleccionada)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filtros de categoría
          _buildCategoryFilter(),

          // Resumen de gastos
          _buildGastosSummary(),

          // Lista de gastos
          Expanded(
            child: _gastosFiltrados.isEmpty
                ? _buildEmptyState()
                : _buildGastosList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGastoDialog(context),
        backgroundColor: AppTheme.errorColor,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Gasto'),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final categoria = _categorias[index];
          final isSelected = categoria == _categoriaSeleccionada;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(categoria),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _categoriaSeleccionada = categoria;
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildGastosSummary() {
    double totalGastos = _gastosFiltrados.fold(
      0,
      (sum, gasto) => sum + gasto['monto'],
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Gastos',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              Text(
                _categoriaSeleccionada == 'Todos'
                    ? 'Este mes'
                    : _categoriaSeleccionada,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            '€ ${totalGastos.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppTheme.errorColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
          Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No hay gastos en esta categoría',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildGastosList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _gastosFiltrados.length,
      itemBuilder: (context, index) {
        final gasto = _gastosFiltrados[index];
        return _buildGastoCard(gasto);
      },
    );
  }

  Widget _buildGastoCard(Map<String, dynamic> gasto) {
    IconData icon;
    switch (gasto['categoria']) {
      case 'Proveedores':
        icon = Icons.local_shipping;
        break;
      case 'Servicios':
        icon = Icons.electrical_services;
        break;
      case 'Personal':
        icon = Icons.people;
        break;
      default:
        icon = Icons.receipt;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.errorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.errorColor),
        ),
        title: Text(
          gasto['concepto'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                gasto['categoria'],
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              gasto['fecha'],
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        trailing: Text(
          '- € ${gasto['monto'].toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppTheme.errorColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => _showGastoDetails(gasto),
      ),
    );
  }

  void _showGastoDetails(Map<String, dynamic> gasto) {
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
                  'Gasto #${gasto['id']}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            _buildDetailRow('Concepto', gasto['concepto']),
            _buildDetailRow('Categoría', gasto['categoria']),
            _buildDetailRow('Fecha', gasto['fecha']),
            const Divider(),
            _buildDetailRow(
              'Total',
              '€ ${gasto['monto'].toStringAsFixed(2)}',
              isBold: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
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
                      _deleteGasto(gasto['id']);
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
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 18 : 14,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddGastoDialog(BuildContext context) {
    final conceptoController = TextEditingController();
    final montoController = TextEditingController();
    String categoriaSelected = 'Otros';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nuevo Gasto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: conceptoController,
                  decoration: const InputDecoration(
                    labelText: 'Concepto',
                    hintText: 'Descripción del gasto',
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: categoriaSelected,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _categorias
                      .where((c) => c != 'Todos')
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      categoriaSelected = value!;
                    });
                  },
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
                if (conceptoController.text.isNotEmpty &&
                    montoController.text.isNotEmpty) {
                  setState(() {
                    _gastos.insert(0, {
                      'id': _gastos.length + 1,
                      'concepto': conceptoController.text,
                      'categoria': categoriaSelected,
                      'monto': double.tryParse(montoController.text) ?? 0.0,
                      'fecha': '01/12/2025',
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gasto añadido correctamente'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteGasto(int id) {
    setState(() {
      _gastos.removeWhere((g) => g['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gasto eliminado'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }
}
