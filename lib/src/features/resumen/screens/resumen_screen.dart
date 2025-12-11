import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/providers/data_providers.dart';

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
  Timer? _cardsTimer;
  Timer? _listTimer;

  late Animation<double> _balanceScale;
  late Animation<double> _balanceSlide;
  late Animation<double> _cardsFade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    // Cargar datos reales al iniciar
    Future.microtask(() {
      if (mounted) {
        context.read<ResumenProvider>().loadResumen();
      }
    });
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

    _balanceScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _balanceController, curve: Curves.easeOut),
    );

    _balanceSlide = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _balanceController, curve: Curves.easeOut),
    );

    _cardsFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cardsController, curve: Curves.easeOut));

    _balanceController.forward();

    // Stagger animations slightly
    _cardsTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) _cardsController.forward();
    });

    _listTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _cardsTimer?.cancel();
    _listTimer?.cancel();
    _balanceController.dispose();
    _cardsController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResumenProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedBalanceCard(provider),
              const SizedBox(height: 20),
              _buildAnimatedStatsCards(provider),
              const SizedBox(height: 24),
              _buildAnimatedTransactions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBalanceCard(ResumenProvider provider) {
    return AnimatedBuilder(
      animation: _balanceController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _balanceSlide.value),
          child: Transform.scale(scale: _balanceScale.value, child: child),
        );
      },
      child: _BalanceCard(
        targetBalance: provider.balance,
        targetIngresos: provider.totalVentas,
        targetGastos: provider.totalGastos,
      ),
    );
  }

  Widget _buildAnimatedStatsCards(ResumenProvider provider) {
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
                      value: provider.totalVentas,
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
                      value: provider.totalGastos,
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
                      value: provider.totalProductos.toDouble(),
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
                      value: provider.productosStockBajo.toDouble(),
                      icon: Icons.warning,
                      color: AppTheme.warningColor,
                      delay: 3,
                      isInteger: true,
                      isPulsing: provider.productosStockBajo > 0,
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
                      'Transacciones Recientes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Consumer<ResumenProvider>(
                  builder: (context, provider, _) {
                    if (provider.recentTransactions.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'No hay transacciones recientes',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.recentTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = provider.recentTransactions[index];
                        final isVenta = transaction['type'] == 'venta';
                        final date = transaction['date'] as DateTime;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 0,
                          color: Colors.grey.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isVenta
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              child: Icon(
                                isVenta
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: isVenta ? Colors.green : Colors.red,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              transaction['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${transaction['subtitle']} • ${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            trailing: Text(
                              '${isVenta ? '+' : '-'} \$${(transaction['amount'] as double).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isVenta ? Colors.green : Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
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
  final double targetBalance;
  final double targetIngresos;
  final double targetGastos;

  const _BalanceCard({
    required this.targetBalance,
    required this.targetIngresos,
    required this.targetGastos,
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
              // Badge de tendencia - solo se muestra si hay datos
              targetBalance > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            targetBalance > 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${targetBalance > 0 ? '+' : ''}${(targetBalance / 100 * 5).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: targetBalance),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Text(
                'EUR ${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildDetail('Ingresos', targetIngresos, Icons.arrow_upward),
              const SizedBox(width: 32),
              _buildDetail('Gastos', targetGastos, Icons.arrow_downward),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(String label, double targetValue, IconData icon) {
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
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: targetValue),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Text(
                  'EUR ${value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _AnimatedStatCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
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
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                isPulsing
                    ? _PulsingIcon(icon: icon, color: color)
                    : Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              builder: (context, val, child) {
                return Text(
                  isInteger
                      ? '$prefix${val.toInt()}'
                      : '$prefix${val.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
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
