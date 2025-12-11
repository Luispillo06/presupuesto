import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/client_model.dart';
import '../../../shared/models/license_model.dart';
import '../../../shared/providers/crm_provider.dart';

/// Pantalla de detalle del cliente con sus licencias
class CrmClientDetailScreen extends StatelessWidget {
  const CrmClientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final client = ModalRoute.of(context)?.settings.arguments as ClientModel?;

    if (client == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cliente')),
        body: const Center(child: Text('Cliente no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(client.name),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          Consumer<CrmProvider>(
            builder: (context, provider, _) {
              if (!provider.isAdmin) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/crm-client-form',
                    arguments: client,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CrmProvider>(
        builder: (context, provider, _) {
          final clientLicenses = provider.getLicensesByClient(client.id);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del cliente
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            client.name.isNotEmpty
                                ? client.name[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          client.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (client.company != null &&
                            client.company!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            client.company!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Datos de contacto
                        _InfoRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: client.email,
                        ),
                        if (client.phone != null && client.phone!.isNotEmpty)
                          _InfoRow(
                            icon: Icons.phone,
                            label: 'Teléfono',
                            value: client.phone!,
                          ),
                        _InfoRow(
                          icon: Icons.calendar_today,
                          label: 'Registrado',
                          value: DateFormat(
                            'dd/MM/yyyy',
                          ).format(client.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Licencias del cliente
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Licencias (${clientLicenses.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (provider.isAdmin)
                      TextButton.icon(
                        onPressed: () {
                          // Navegar a crear licencia con cliente preseleccionado
                          Navigator.pushNamed(context, '/crm-license-form');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Nueva'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                if (clientLicenses.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.key_off,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sin licencias asignadas',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ...clientLicenses.map(
                    (license) => _LicenseCard(
                      license: license,
                      isAdmin: provider.isAdmin,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LicenseCard extends StatelessWidget {
  final LicenseModel license;
  final bool isAdmin;

  const _LicenseCard({required this.license, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.key, color: _getStatusColor()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        license.product?.name ?? 'Producto',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        license.type.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    license.status.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inicio',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        dateFormat.format(license.startDate),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (license.endDate != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fin',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          dateFormat.format(license.endDate!),
                          style: TextStyle(
                            fontSize: 13,
                            color: license.isExpired ? Colors.red : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isAdmin)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/crm-license-form',
                        arguments: license,
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (license.status) {
      case LicenseStatus.activa:
        return Colors.green;
      case LicenseStatus.inactiva:
        return Colors.grey;
      case LicenseStatus.pendientePago:
        return Colors.orange;
    }
  }
}
