import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/license_model.dart';
import '../../../shared/providers/crm_provider.dart';

/// Formulario para crear/editar licencias
class CrmLicenseFormScreen extends StatefulWidget {
  const CrmLicenseFormScreen({super.key});

  @override
  State<CrmLicenseFormScreen> createState() => _CrmLicenseFormScreenState();
}

class _CrmLicenseFormScreenState extends State<CrmLicenseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedClientId;
  String? _selectedProductId;
  LicenseType _selectedType = LicenseType.licenciaUnica;
  LicenseStatus _selectedStatus = LicenseStatus.activa;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  LicenseModel? _existingLicense;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is LicenseModel && _existingLicense == null) {
      _existingLicense = args;
      _selectedClientId = args.clientId;
      _selectedProductId = args.productId;
      _selectedType = args.type;
      _selectedStatus = args.status;
      _startDate = args.startDate;
      _endDate = args.endDate;
    }
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        // Si la fecha fin es anterior a inicio, ajustar
        if (_endDate != null && _endDate!.isBefore(_startDate)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 30)),
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione un cliente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione un producto'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final provider = context.read<CrmProvider>();
    bool success;

    final license = LicenseModel(
      id: _existingLicense?.id ?? '',
      clientId: _selectedClientId!,
      productId: _selectedProductId!,
      type: _selectedType,
      startDate: _startDate,
      endDate: _selectedType == LicenseType.suscripcion ? _endDate : null,
      status: _selectedStatus,
      createdAt: _existingLicense?.createdAt ?? DateTime.now(),
    );

    if (_existingLicense != null) {
      success = await provider.updateLicense(license);
    } else {
      success = await provider.createLicense(license);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _existingLicense != null
                ? 'Licencia actualizada'
                : 'Licencia creada',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Error al guardar'),
          backgroundColor: Colors.red,
        ),
      );
      provider.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _existingLicense != null;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Licencia' : 'Nueva Licencia'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CrmProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icono
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isEditing ? Icons.key : Icons.vpn_key,
                        size: 48,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Cliente
                  DropdownButtonFormField<String>(
                    value: _selectedClientId,
                    decoration: InputDecoration(
                      labelText: 'Cliente *',
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: provider.clients.map((client) {
                      return DropdownMenuItem(
                        value: client.id,
                        child: Text(client.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedClientId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Seleccione un cliente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Producto
                  DropdownButtonFormField<String>(
                    value: _selectedProductId,
                    decoration: InputDecoration(
                      labelText: 'Producto *',
                      prefixIcon: const Icon(Icons.inventory_2_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: provider.products.map((product) {
                      return DropdownMenuItem(
                        value: product.id,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProductId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Seleccione un producto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tipo de licencia
                  DropdownButtonFormField<LicenseType>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Tipo de licencia *',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: LicenseType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value ?? LicenseType.licenciaUnica;
                        if (_selectedType == LicenseType.licenciaUnica) {
                          _endDate = null;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Estado
                  DropdownButtonFormField<LicenseStatus>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Estado *',
                      prefixIcon: const Icon(Icons.flag_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: LicenseStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value ?? LicenseStatus.activa;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Fecha de inicio
                  InkWell(
                    onTap: _selectStartDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Fecha de inicio *',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(dateFormat.format(_startDate)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fecha de fin (solo para suscripciones)
                  if (_selectedType == LicenseType.suscripcion) ...[
                    InkWell(
                      onTap: _selectEndDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Fecha de fin',
                          prefixIcon: const Icon(Icons.event),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: _endDate != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _endDate = null;
                                    });
                                  },
                                )
                              : null,
                        ),
                        child: Text(
                          _endDate != null
                              ? dateFormat.format(_endDate!)
                              : 'Sin fecha de fin',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 16),

                  // Botón guardar
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              isEditing
                                  ? 'Actualizar Licencia'
                                  : 'Crear Licencia',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
