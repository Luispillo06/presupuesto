import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda y Soporte'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpCard(
            context,
            icon: Icons.point_of_sale,
            title: 'Cómo crear una venta',
            description:
                'Ve a la pestaña "Ventas", pulsa el botón "+" y selecciona los productos. El total se calculará automáticamente.',
          ),
          const SizedBox(height: 16),
          _buildHelpCard(
            context,
            icon: Icons.inventory_2,
            title: 'Gestionar Inventario',
            description:
                'En la pestaña "Productos" puedes añadir nuevo stock, editar precios o eliminar productos obsoletos.',
          ),
          const SizedBox(height: 16),
          _buildHelpCard(
            context,
            icon: Icons.receipt_long,
            title: 'Registrar Gastos',
            description:
                'Mantén tus finanzas en orden registrando cada gasto en la pestaña "Gastos".',
          ),
          const SizedBox(height: 24),
          const Text(
            'Preguntas Frecuentes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildFaqItem('¿Cómo recupero mi contraseña?', 'Contacta con el administrador del sistema.'),
          _buildFaqItem('¿Puedo exportar mis datos?', 'Esta función estará disponible en futuras actualizaciones.'),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implementar contacto
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contactando soporte...')),
                );
              },
              icon: const Icon(Icons.support_agent),
              label: const Text('Contactar Soporte'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: TextStyle(color: Colors.grey[700])),
        ),
      ],
    );
  }
}
