import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

class ResumenScreen extends StatefulWidget {
  const ResumenScreen({super.key});

  @override
  State<ResumenScreen> createState() => _ResumenScreenState();
}

class _ResumenScreenState extends State<ResumenScreen>
    with TickerProviderStateMixin {
  late AnimationController _balanceController;
  late AnimationController _cardsController;
  late AnimationController _listController;

  late Animation<double> _balanceScale;
  late Animation<double> _balanceSlide;
  late Animation<double> _cardsFade;

  // Valores animados
  double _animatedBalance = 0;
  double _animatedIngresos = 0;
  double _animatedGastos = 0;

  final double _targetBalance = 2350.00;
  final double _targetIngresos = 3200.00;
  final double _targetGastos = 850.00;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animateValues();
  }

  void _setupAnimations() {
    _balanceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _listController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _balanceScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _balanceController, curve: Curves.elasticOut),
    );

    _balanceSlide = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(parent: _balanceController, curve: Curves.easeOutCubic),
    );

    _cardsFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cardsController, curve: Curves.easeOut));

    _balanceController.forward().then((v) {
      _cardsController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _listController.forward();
    });
  }

  void _animateValues() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      const steps = 30;
      const stepDuration = Duration(milliseconds: 30);

      for (int i = 1; i <= steps; i++) {
        Future.delayed(stepDuration * i, () {
          if (!mounted) return;
          setState(() {
            _animatedBalance = _targetBalance * (i / steps);
            _animatedIngresos = _targetIngresos * (i / steps);
            _animatedGastos = _targetGastos * (i / steps);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _cardsController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedBalanceCard(),
          const SizedBox(height: 20),
          _buildAnimatedStatsCards(),
          const SizedBox(height: 24),
          _buildAnimatedTransactions(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBalanceCard() {
    return AnimatedBuilder(
      animation: _balanceController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _balanceSlide.value),
          child: Transform.scale(
            scale: _balanceScale.value,
            child: _BalanceCard(
              balance: _animatedBalance,
              ingresos: _animatedIngresos,
              gastos: _animatedGastos,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedStatsCards() {
    return AnimatedBuilder(
      animation: _cardsController,
      builder: (context, child) {
        return Opacity(
          opacity: _cardsFade.value,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _AnimatedStatCard(
                      title: 'Ventas Hoy',
                      value: 450.00,
                      prefix: 'EUR ',
                      icon: Icons.trending_up,
                      color: AppTheme.successColor,
                      delay: 0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AnimatedStatCard(
                      title: 'Gastos Hoy',
                      value: 120.00,
                      prefix: 'EUR ',
                      icon: Icons.trending_down,
                      color: AppTheme.errorColor,
                      delay: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _AnimatedStatCard(
                      title: 'Productos',
                      value: 24,
                      icon: Icons.inventory_2,
                      color: AppTheme.secondaryColor,
                      delay: 2,
                      isInteger: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AnimatedStatCard(
                      title: 'Stock Bajo',
                      value: 3,
                      icon: Icons.warning,
                      color: AppTheme.warningColor,
                      delay: 3,
                      isInteger: true,
                      isPulsing: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTransactions() {
    return AnimatedBuilder(
      animation: _listController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _listController.value)),
          child: Opacity(
            opacity: _listController.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ultimas Transacciones',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Ver todas'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _AnimatedTransaction(
                  title: 'Venta - Cliente #45',
                  amount: 'EUR 85.00',
                  icon: Icons.add_circle,
                  color: AppTheme.successColor,
                  time: 'Hace 2 horas',
                  delay: 0,
                ),
                _AnimatedTransaction(
                  title: 'Compra - Proveedor ABC',
                  amount: 'EUR 250.00',
                  icon: Icons.remove_circle,
                  color: AppTheme.errorColor,
                  time: 'Hace 5 horas',
                  delay: 1,
                ),
                _AnimatedTransaction(
                  title: 'Venta - Cliente #44',
                  amount: 'EUR 120.00',
                  icon: Icons.add_circle,
                  color: AppTheme.successColor,
                  time: 'Ayer',
                  delay: 2,
                ),
                _AnimatedTransaction(
                  title: 'Gasto - Luz',
                  amount: 'EUR 75.00',
                  icon: Icons.remove_circle,
                  color: AppTheme.errorColor,
                  time: 'Ayer',
                  delay: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final double ingresos;
  final double gastos;

  const _BalanceCard({
    required this.balance,
    required this.ingresos,
    required this.gastos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Balance del Mes',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '+12%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'EUR ${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildDetail(
                'Ingresos',
                'EUR ${ingresos.toStringAsFixed(0)}',
                Icons.arrow_upward,
              ),
              const SizedBox(width: 32),
              _buildDetail(
                'Gastos',
                'EUR ${gastos.toStringAsFixed(0)}',
                Icons.arrow_downward,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnimatedStatCard extends StatefulWidget {
  final String title;
  final double value;
  final String prefix;
  final IconData icon;
  final Color color;
  final int delay;
  final bool isInteger;
  final bool isPulsing;

  const _AnimatedStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
    this.prefix = '',
    this.isInteger = false,
    this.isPulsing = false,
  });

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  double _animatedValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    Future.delayed(Duration(milliseconds: 100 * widget.delay), () {
      if (mounted) {
        _controller.forward();
        _animateValue();
      }
    });
  }

  void _animateValue() {
    const steps = 20;
    const stepDuration = Duration(milliseconds: 25);

    for (int i = 1; i <= steps; i++) {
      Future.delayed(stepDuration * i, () {
        if (mounted) {
          setState(() {
            _animatedValue = widget.value * (i / steps);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                widget.isPulsing
                    ? _PulsingIcon(icon: widget.icon, color: widget.color)
                    : Icon(widget.icon, color: widget.color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.isInteger
                  ? '${widget.prefix}${_animatedValue.toInt()}'
                  : '${widget.prefix}${_animatedValue.toStringAsFixed(2)}',
              style: TextStyle(
                color: widget.color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;

  const _PulsingIcon({required this.icon, required this.color});

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.repeat(reverse: true);
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(widget.icon, color: widget.color, size: 20),
    );
  }
}

class _AnimatedTransaction extends StatefulWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final String time;
  final int delay;

  const _AnimatedTransaction({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.time,
    required this.delay,
  });

  @override
  State<_AnimatedTransaction> createState() => _AnimatedTransactionState();
}

class _AnimatedTransactionState extends State<_AnimatedTransaction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: 100 * widget.delay), () {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon, color: widget.color),
                ),
                title: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  widget.time,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                trailing: Text(
                  widget.amount,
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
