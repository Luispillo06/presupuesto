import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

class GastosScreen extends StatefulWidget {
  const GastosScreen({super.key});
  @override
  State<GastosScreen> createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerSlide;
  
  String _categoriaSeleccionada = 'Todos';
  final List<String> _categorias = ['Todos', 'Proveedores', 'Servicios', 'Personal', 'Otros'];
  
  final List<Map<String, dynamic>> _gastos = [
    {'id': 1, 'concepto': 'Compra a Proveedor ABC', 'categoria': 'Proveedores', 'monto': 250.00, 'fecha': '01/12/2025'},
    {'id': 2, 'concepto': 'Factura de Luz', 'categoria': 'Servicios', 'monto': 75.50, 'fecha': '30/11/2025'},
    {'id': 3, 'concepto': 'Salario empleado', 'categoria': 'Personal', 'monto': 1200.00, 'fecha': '28/11/2025'},
    {'id': 4, 'concepto': 'Material de oficina', 'categoria': 'Otros', 'monto': 45.00, 'fecha': '25/11/2025'},
    {'id': 5, 'concepto': 'Internet y telefono', 'categoria': 'Servicios', 'monto': 60.00, 'fecha': '20/11/2025'},
  ];

  List<Map<String, dynamic>> get _gastosFiltrados {
    if (_categoriaSeleccionada == 'Todos') return _gastos;
    return _gastos.where((g) => g['categoria'] == _categoriaSeleccionada).toList();
  }

  double get _totalGastos => _gastosFiltrados.fold(0, (sum, g) => sum + g['monto']);

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _listController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _headerSlide = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAnimatedFilters(),
          _buildAnimatedSummary(),
          Expanded(child: _gastosFiltrados.isEmpty ? _buildEmptyState() : _buildAnimatedList()),
        ],
      ),
      floatingActionButton: _AnimatedFab(onPressed: () => _showAddDialog(context)),
    );
  }

  Widget _buildAnimatedFilters() {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _headerSlide.value),
        child: Opacity(
          opacity: _headerController.value,
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final cat = _categorias[index];
                final isSelected = cat == _categoriaSeleccionada;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _AnimatedChip(
                    label: cat,
                    isSelected: isSelected,
                    onTap: () => setState(() => _categoriaSeleccionada = cat),
                    delay: index,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSummary() {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _headerSlide.value),
        child: Opacity(
          opacity: _headerController.value,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.errorColor, AppTheme.errorColor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppTheme.errorColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Gastos', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text(_categoriaSeleccionada == 'Todos' ? 'Este mes' : _categoriaSeleccionada, 
                         style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _totalGastos),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) => Text(
                    'EUR ${value.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          Text('No hay gastos en esta categoria', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildAnimatedList() {
    return AnimatedBuilder(
      animation: _listController,
      builder: (context, child) => Opacity(
        opacity: _listController.value,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _gastosFiltrados.length,
          itemBuilder: (context, index) => _AnimatedGastoCard(
            gasto: _gastosFiltrados[index],
            index: index,
            onDelete: () => _deleteGasto(_gastosFiltrados[index]['id']),
          ),
        ),
      ),
    );
  }

  void _deleteGasto(int id) {
    setState(() => _gastos.removeWhere((g) => g['id'] == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Gasto eliminado'), behavior: SnackBarBehavior.floating,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('Nuevo Gasto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: 'Concepto', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 16),
            TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Monto (EUR)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () => Navigator.pop(context),
                child: const Text('Guardar Gasto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _AnimatedChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int delay;
  const _AnimatedChip({required this.label, required this.isSelected, required this.onTap, required this.delay});
  @override
  State<_AnimatedChip> createState() => _AnimatedChipState();
}

class _AnimatedChipState extends State<_AnimatedChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    Future.delayed(Duration(milliseconds: 50 * widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected ? AppTheme.errorColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(widget.label, style: TextStyle(color: widget.isSelected ? Colors.white : Colors.black87, fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }
}

class _AnimatedGastoCard extends StatefulWidget {
  final Map<String, dynamic> gasto;
  final int index;
  final VoidCallback onDelete;
  const _AnimatedGastoCard({required this.gasto, required this.index, required this.onDelete});
  @override
  State<_AnimatedGastoCard> createState() => _AnimatedGastoCardState();
}

class _AnimatedGastoCardState extends State<_AnimatedGastoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _slide = Tween<double>(begin: 50, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case 'Proveedores': return Icons.local_shipping;
      case 'Servicios': return Icons.electrical_services;
      case 'Personal': return Icons.people;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gasto = widget.gasto;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(_slide.value, 0),
        child: Opacity(
          opacity: _fade.value,
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: AppTheme.errorColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(_getCategoryIcon(gasto['categoria']), color: AppTheme.errorColor),
              ),
              title: Text(gasto['concepto'], style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                    child: Text(gasto['categoria'], style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                  ),
                  const SizedBox(width: 8),
                  Text(gasto['fecha'], style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('EUR ${gasto['monto'].toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  GestureDetector(
                    onTap: widget.onDelete,
                    child: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedFab extends StatefulWidget {
  final VoidCallback onPressed;
  const _AnimatedFab({required this.onPressed});
  @override
  State<_AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<_AnimatedFab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FloatingActionButton.extended(
        onPressed: widget.onPressed,
        backgroundColor: AppTheme.errorColor,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Gasto'),
      ),
    );
  }
}
