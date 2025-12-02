import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});
  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  
  final List<Map<String, dynamic>> _ventas = [
    {'id': 1, 'cliente': 'Cliente General', 'monto': 85.00, 'fecha': '01/12/2025', 'productos': ['Producto A x2']},
    {'id': 2, 'cliente': 'Maria Garcia', 'monto': 120.50, 'fecha': '01/12/2025', 'productos': ['Producto C x3']},
    {'id': 3, 'cliente': 'Juan Perez', 'monto': 45.00, 'fecha': '30/11/2025', 'productos': ['Producto A x1']},
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    double total = _ventas.fold(0.0, (s, v) => s + (v['monto'] as double));
    return Scaffold(
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) => Opacity(
          opacity: _fade.value,
          child: Column(children: [
            _buildHeader(total),
            Expanded(child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _ventas.length,
              itemBuilder: (ctx, i) => _buildCard(_ventas[i], i),
            )),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Venta'),
      ),
    );
  }

  Widget _buildHeader(double total) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.successColor, AppTheme.successColor.withValues(alpha: 0.8)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.successColor.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Total Ventas', style: TextStyle(color: Colors.white70, fontSize: 14)),
          Text('Este mes', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ]),
        Text('\u20AC${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildCard(Map<String, dynamic> v, int i) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (i * 100)),
      curve: Curves.easeOut,
      builder: (ctx, val, child) => Transform.translate(
        offset: Offset(50 * (1 - val), 0),
        child: Opacity(opacity: val, child: child),
      ),
      child: Dismissible(
        key: Key('v_${v['id']}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => setState(() => _ventas.removeWhere((x) => x['id'] == v['id'])),
        background: Container(
          alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(color: AppTheme.errorColor, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50, height: 50,
              decoration: BoxDecoration(color: AppTheme.successColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.shopping_cart, color: AppTheme.successColor),
            ),
            title: Text(v['cliente'], style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text((v['productos'] as List).join(', '), maxLines: 1),
            trailing: Text('\u20AC${(v['monto'] as double).toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.successColor, fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () => _showDetails(v),
          ),
        ),
      ),
    );
  }

  void _showDetails(Map<String, dynamic> v) {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Venta #${v['id']}', style: Theme.of(context).textTheme.titleLarge),
        const Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Cliente'), Text(v['cliente'])]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total'), Text('\u20AC${(v['monto'] as double).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar'))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            onPressed: () { Navigator.pop(ctx); setState(() => _ventas.removeWhere((x) => x['id'] == v['id'])); },
            child: const Text('Eliminar'))),
        ]),
      ])),
    );
  }

  void _showAddDialog(BuildContext context) {
    final cCtrl = TextEditingController();
    final mCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Nueva Venta'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: cCtrl, decoration: const InputDecoration(labelText: 'Cliente', prefixIcon: Icon(Icons.person))),
        const SizedBox(height: 16),
        TextField(controller: mCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Monto', prefixIcon: Icon(Icons.euro))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        ElevatedButton(onPressed: () {
          if (mCtrl.text.isNotEmpty) {
            setState(() => _ventas.insert(0, {'id': _ventas.length + 1, 'cliente': cCtrl.text.isEmpty ? 'Cliente General' : cCtrl.text, 'monto': double.tryParse(mCtrl.text) ?? 0.0, 'fecha': '01/12/2025', 'productos': ['Producto']}));
            Navigator.pop(ctx);
          }
        }, child: const Text('Guardar')),
      ],
    ));
  }
}
