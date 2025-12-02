import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});
  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerSlide;
  late Animation<double> _headerFade;
  
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _productos = [
    {'id': 1, 'nombre': 'Camiseta Basica', 'categoria': 'Ropa', 'precio': 19.99, 'stock': 45, 'imagen': null},
    {'id': 2, 'nombre': 'Pantalon Vaquero', 'categoria': 'Ropa', 'precio': 49.99, 'stock': 3, 'imagen': null},
    {'id': 3, 'nombre': 'Zapatillas Running', 'categoria': 'Calzado', 'precio': 79.99, 'stock': 12, 'imagen': null},
    {'id': 4, 'nombre': 'Mochila Sport', 'categoria': 'Accesorios', 'precio': 39.99, 'stock': 8, 'imagen': null},
    {'id': 5, 'nombre': 'Gorra Premium', 'categoria': 'Accesorios', 'precio': 14.99, 'stock': 2, 'imagen': null},
    {'id': 6, 'nombre': 'Sudadera Logo', 'categoria': 'Ropa', 'precio': 59.99, 'stock': 20, 'imagen': null},
  ];

  List<Map<String, dynamic>> get _productosFiltrados {
    if (_searchQuery.isEmpty) return _productos;
    return _productos.where((p) => 
      p['nombre'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  int get _stockBajo => _productos.where((p) => (p['stock'] as int) <= 5).length;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _listController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _headerSlide = Tween<double>(begin: -30, end: 0).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic));
    _headerFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOut));
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAnimatedSearchBar(),
          if (_stockBajo > 0) _buildAnimatedStockAlert(),
          _buildViewToggle(),
          Expanded(child: _productosFiltrados.isEmpty ? _buildEmptyState() : _buildAnimatedProductList()),
        ],
      ),
      floatingActionButton: _AnimatedFab(onPressed: () => _showAddDialog(context)),
    );
  }

  Widget _buildAnimatedSearchBar() {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _headerSlide.value),
        child: Opacity(
          opacity: _headerFade.value,
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    })
                  : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedStockAlert() {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _headerSlide.value),
        child: Opacity(
          opacity: _headerFade.value,
          child: _PulsingStockAlert(count: _stockBajo),
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) => Opacity(
        opacity: _headerFade.value,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_productosFiltrados.length} productos', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    _buildToggleButton(Icons.grid_view, true),
                    _buildToggleButton(Icons.view_list, false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(IconData icon, bool isGrid) {
    final isSelected = _isGridView == isGrid;
    return GestureDetector(
      onTap: () => setState(() => _isGridView = isGrid),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: isSelected ? Colors.white : Colors.grey),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No se encontraron productos', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildAnimatedProductList() {
    return AnimatedBuilder(
      animation: _listController,
      builder: (context, child) => Opacity(
        opacity: _listController.value,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isGridView ? _buildGridView() : _buildListView(),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      key: const ValueKey('grid'),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 12, mainAxisSpacing: 12,
      ),
      itemCount: _productosFiltrados.length,
      itemBuilder: (context, index) => _AnimatedProductGridCard(
        producto: _productosFiltrados[index], index: index,
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      key: const ValueKey('list'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _productosFiltrados.length,
      itemBuilder: (context, index) => _AnimatedProductListCard(
        producto: _productosFiltrados[index], index: index,
      ),
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
            const Text('Nuevo Producto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: 'Nombre del producto', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Precio', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
                const SizedBox(width: 12),
                Expanded(child: TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Stock', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () => Navigator.pop(context),
                child: const Text('Guardar Producto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _PulsingStockAlert extends StatefulWidget {
  final int count;
  const _PulsingStockAlert({required this.count});
  @override
  State<_PulsingStockAlert> createState() => _PulsingStockAlertState();
}

class _PulsingStockAlertState extends State<_PulsingStockAlert> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _pulse = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.orange.shade600]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alerta de Stock', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('${widget.count} productos con stock bajo', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _AnimatedProductGridCard extends StatefulWidget {
  final Map<String, dynamic> producto;
  final int index;
  const _AnimatedProductGridCard({required this.producto, required this.index});
  @override
  State<_AnimatedProductGridCard> createState() => _AnimatedProductGridCardState();
}

class _AnimatedProductGridCardState extends State<_AnimatedProductGridCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
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
    final p = widget.producto;
    final stockBajo = (p['stock'] as int) <= 5;
    return ScaleTransition(
      scale: _scale,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.inventory_2, size: 50, color: Colors.grey)),
                    if (stockBajo)
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
                          child: const Text('Stock bajo', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p['nombre'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('EUR ${p['precio']}', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                        Text('Stock: ${p['stock']}', style: TextStyle(color: stockBajo ? Colors.orange : Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedProductListCard extends StatefulWidget {
  final Map<String, dynamic> producto;
  final int index;
  const _AnimatedProductListCard({required this.producto, required this.index});
  @override
  State<_AnimatedProductListCard> createState() => _AnimatedProductListCardState();
}

class _AnimatedProductListCardState extends State<_AnimatedProductListCard> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final p = widget.producto;
    final stockBajo = (p['stock'] as int) <= 5;
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
                width: 60, height: 60,
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.inventory_2, color: Colors.grey),
              ),
              title: Text(p['nombre'], style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(p['categoria'], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('EUR ${p['precio']}', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: stockBajo ? Colors.orange.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text('Stock: ${p['stock']}', style: TextStyle(color: stockBajo ? Colors.orange : Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
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
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
      ),
    );
  }
}
