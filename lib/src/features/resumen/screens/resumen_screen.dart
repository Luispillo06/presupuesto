import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/summary_card.dart';

/// Pantalla de resumen/dashboard con el balance general
class ResumenScreen extends StatelessWidget {
  const ResumenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta de balance principal
          _buildBalanceCard(context),

          const SizedBox(height: 20),

          // Fila de estadísticas rápidas
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Ventas Hoy',
                  value: '€ 450.00',
                  icon: Icons.trending_up,
                  color: AppTheme.successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Gastos Hoy',
                  value: '€ 120.00',
                  icon: Icons.trending_down,
                  color: AppTheme.errorColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Productos',
                  value: '24',
                  icon: Icons.inventory_2,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Stock Bajo',
                  value: '3',
                  icon: Icons.warning,
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Últimas transacciones
          _buildRecentTransactions(context),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance del Mes',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            '€ 2,350.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildBalanceDetail('Ingresos', '€ 3,200', Icons.arrow_upward),
              const SizedBox(width: 24),
              _buildBalanceDetail('Gastos', '€ 850', Icons.arrow_downward),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetail(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
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

  Widget _buildRecentTransactions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Últimas Transacciones',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(onPressed: () {}, child: const Text('Ver todas')),
          ],
        ),
        const SizedBox(height: 8),
        _buildTransactionItem(
          'Venta - Cliente #45',
          '€ 85.00',
          Icons.add_circle,
          AppTheme.successColor,
          'Hace 2 horas',
        ),
        _buildTransactionItem(
          'Compra - Proveedor ABC',
          '€ 250.00',
          Icons.remove_circle,
          AppTheme.errorColor,
          'Hace 5 horas',
        ),
        _buildTransactionItem(
          'Venta - Cliente #44',
          '€ 120.00',
          Icons.add_circle,
          AppTheme.successColor,
          'Ayer',
        ),
        _buildTransactionItem(
          'Gasto - Luz',
          '€ 75.00',
          Icons.remove_circle,
          AppTheme.errorColor,
          'Ayer',
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String amount,
    IconData icon,
    Color color,
    String time,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(time),
        trailing: Text(
          amount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
