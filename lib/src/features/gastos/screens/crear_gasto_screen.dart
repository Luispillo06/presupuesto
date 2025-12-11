import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/supabase/supabase_config.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/data_providers.dart';

class CrearGastoScreen extends StatefulWidget {
  final Gasto? gasto;

  const CrearGastoScreen({super.key, this.gasto});

  @override
  State<CrearGastoScreen> createState() => _CrearGastoScreenState();
}

class _CrearGastoScreenState extends State<CrearGastoScreen> {
  final _conceptoController = TextEditingController();
  final _montoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _notasController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.gasto != null) {
      _conceptoController.text = widget.gasto!.concepto;
      _montoController.text = widget.gasto!.monto.toString();
      _categoriaController.text = widget.gasto!.categoria;
      _notasController.text = widget.gasto!.notas ?? '';
    }
  }

  @override
  void dispose() {
    _conceptoController.dispose();
    _montoController.dispose();
    _categoriaController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  void _save() async {
    if (SupabaseConfig.currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Debes estar autenticado')));
      return;
    }

    if (_conceptoController.text.isEmpty || _montoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final gasto = Gasto(
        id: widget.gasto?.id ?? 0,
        concepto: _conceptoController.text,
        monto: double.parse(_montoController.text),
        fecha: widget.gasto?.fecha ?? DateTime.now(),
        categoria: _categoriaController.text.isNotEmpty
            ? _categoriaController.text
            : 'General',
        notas: _notasController.text.isNotEmpty ? _notasController.text : null,
      );

      bool result;
      if (widget.gasto != null) {
        result = await context.read<GastosProvider>().updateGasto(gasto);
      } else {
        result = await context.read<GastosProvider>().addGasto(gasto);
      }

      if (mounted) {
        setState(() => _isLoading = false);
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.gasto != null ? '✅ Gasto actualizado' : '✅ Gasto creado',
              ),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.gasto != null
                    ? '❌ Error al actualizar'
                    : '❌ Error al crear',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gasto != null ? 'Editar Gasto' : 'Crear Gasto'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _conceptoController,
                decoration: const InputDecoration(
                  labelText: 'Concepto *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto *',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                  hintText: 'ej: Alimentación, Transporte',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notasController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.gasto != null
                              ? 'Guardar Cambios'
                              : 'Crear Gasto',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
