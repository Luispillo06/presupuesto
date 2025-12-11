import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../core/supabase/supabase_config.dart';
import 'store_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.grey[800],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSectionHeader('General'),
          _buildSettingItem(
            context,
            icon: Icons.store,
            title: 'Información de la Tienda',
            subtitle: 'Nombre, dirección, contacto',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StoreProfileScreen()),
              );
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.language,
            title: 'Idioma',
            subtitle: 'Español',
            onTap: () {},
          ),
          _buildSettingItem(
            context,
            icon: Icons.dark_mode,
            title: 'Tema',
            subtitle: 'Sistema',
            onTap: () {},
          ),
          const Divider(),
          _buildSectionHeader('Notificaciones'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active),
            title: const Text('Notificaciones Push'),
            subtitle: const Text('Recibir alertas de stock bajo'),
            value: true,
            onChanged: (val) {},
            activeColor: AppTheme.primaryColor,
          ),
          const Divider(),
          _buildSectionHeader('Seguridad'),
          _buildSettingItem(
            context,
            icon: Icons.lock,
            title: 'Cambiar Contraseña',
            onTap: () {
              _showChangePasswordDialog(context);
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Versión 1.0.0',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Nueva Contraseña',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPassword = passwordController.text;
              if (newPassword.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres')),
                );
                return;
              }

              try {
                await SupabaseConfig.client.auth.updateUser(
                  UserAttributes(password: newPassword),
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Contraseña actualizada')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
