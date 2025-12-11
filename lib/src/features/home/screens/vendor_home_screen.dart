import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../core/supabase/supabase_config.dart';
import '../../ventas/screens/ventas_screen.dart';
import '../../ventas/screens/crear_venta_screen.dart';
import '../../gastos/screens/gastos_screen.dart';
import '../../gastos/screens/crear_gasto_screen.dart';
import '../../productos/screens/productos_screen.dart';
import '../../productos/screens/crear_producto_screen.dart';
import '../../resumen/screens/resumen_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../settings/screens/help_screen.dart';

/// Pantalla principal para VENDEDORES
class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabController;
  late Animation<double> _fabScale;

  final List<Widget> _screens = const [
    ResumenScreen(),
    VentasScreen(),
    GastosScreen(),
    ProductosScreen(),
  ];

  final List<String> _titles = ['Resumen', 'Ventas', 'Gastos', 'Productos'];

  final List<IconData> _icons = [
    Icons.dashboard_outlined,
    Icons.point_of_sale_outlined,
    Icons.receipt_long_outlined,
    Icons.inventory_2_outlined,
  ];

  final List<IconData> _activeIcons = [
    Icons.dashboard,
    Icons.point_of_sale,
    Icons.receipt_long,
    Icons.inventory_2,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _fabController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAnimatedAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          _fabController.forward(from: 0);
        },
        children: _screens,
      ),
      bottomNavigationBar: _buildAnimatedBottomBar(),
      floatingActionButton: _buildAnimatedFab(),
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar() {
    Color appBarColor = _getAppBarColor();

    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Text(_titles[_currentIndex], key: ValueKey<int>(_currentIndex)),
      ),
      backgroundColor: appBarColor,
      actions: [
        ScaleTransition(
          scale: _fabScale,
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showNotifications(context);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            _showUserMenu(context);
          },
        ),
      ],
    );
  }

  Color _getAppBarColor() {
    switch (_currentIndex) {
      case 0: // Resumen
        return Colors.grey[800] ?? Colors.grey;
      case 1: // Ventas
        return Colors.green;
      case 2: // Gastos
        return Colors.red;
      case 3: // Productos
        return Colors.blue;
      default:
        return Colors.grey[800] ?? Colors.grey;
    }
  }

  Widget _buildAnimatedBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) {
              Color itemColor = Colors.grey;
              if (index == 1) itemColor = Colors.green; // Ventas VERDE
              if (index == 2) itemColor = Colors.red; // Gastos ROJO
              if (index == 3) itemColor = Colors.blue; // Productos AZUL

              return _AnimatedNavItem(
                icon: _icons[index],
                activeIcon: _activeIcons[index],
                label: _titles[index],
                isSelected: _currentIndex == index,
                color: itemColor,
                onTap: () {
                  _onTabTapped(index);
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget? _buildAnimatedFab() {
    if (_currentIndex == 0) return null;

    return ScaleTransition(
      scale: _fabScale,
      child: FloatingActionButton.extended(
        onPressed: () {
          _showAddDialog();
        },
        icon: const Icon(Icons.add),
        label: Text(_getFabLabel()),
        backgroundColor: _getFabColor(),
      ),
    );
  }

  String _getFabLabel() {
    switch (_currentIndex) {
      case 1:
        return 'Nueva Venta';
      case 2:
        return 'Nuevo Gasto';
      case 3:
        return 'Nuevo Producto';
      default:
        return 'Nuevo';
    }
  }

  Color _getFabColor() {
    switch (_currentIndex) {
      case 1:
        return Colors.green; // Ventas VERDE
      case 2:
        return Colors.red; // Gastos ROJO
      case 3:
        return Colors.blue; // Productos AZUL
      default:
        return Colors.blue;
    }
  }

  void _showAddDialog() {
    switch (_currentIndex) {
      case 1: // Ventas
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CrearVentaScreen()),
        );
        break;
      case 2: // Gastos
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CrearGastoScreen()),
        );
        break;
      case 3: // Productos
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CrearProductoScreen()),
        );
        break;
    }
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Icon(
                Icons.notifications_none,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sin notificaciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Las notificaciones apareceran aqui',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicador de arrastre
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Avatar y nombre de usuario
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppTheme.primaryColor,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                SupabaseConfig.currentUser?.userMetadata?['nombre'] ??
                    'Usuario',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                SupabaseConfig.currentUser?.email ?? 'correo@ejemplo.com',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // Opciones del menú
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Ayuda'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.errorColor),
                title: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _handleLogout();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Cerrar sesion'),
          ),
        ],
      ),
    );
  }
}

class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) {
        _controller.forward();
      },
      onTapUp: (d) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.color.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  widget.isSelected ? widget.activeIcon : widget.icon,
                  key: ValueKey<bool>(widget.isSelected),
                  color: widget.isSelected ? widget.color : Colors.grey,
                  size: widget.isSelected ? 28 : 24,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: widget.isSelected ? widget.color : Colors.grey,
                  fontSize: widget.isSelected ? 12 : 11,
                  fontWeight: widget.isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
