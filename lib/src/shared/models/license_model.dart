import 'client_model.dart';
import 'crm_product_model.dart';

/// Tipos de licencia
enum LicenseType {
  licenciaUnica('licencia_unica', 'Licencia Única'),
  suscripcion('suscripcion', 'Suscripción');

  final String value;
  final String displayName;
  const LicenseType(this.value, this.displayName);

  static LicenseType fromString(String value) {
    return LicenseType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LicenseType.licenciaUnica,
    );
  }
}

/// Estados de licencia
enum LicenseStatus {
  activa('activa', 'Activa'),
  inactiva('inactiva', 'Inactiva'),
  pendientePago('pendiente_pago', 'Pendiente de Pago');

  final String value;
  final String displayName;
  const LicenseStatus(this.value, this.displayName);

  static LicenseStatus fromString(String value) {
    return LicenseStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LicenseStatus.activa,
    );
  }
}

/// Modelo de Licencia del CRM
class LicenseModel {
  final String id;
  final String clientId;
  final String productId;
  final LicenseType type;
  final DateTime startDate;
  final DateTime? endDate;
  final LicenseStatus status;
  final DateTime createdAt;

  // Relaciones (opcionales, se cargan con joins)
  final ClientModel? client;
  final CrmProductModel? product;

  LicenseModel({
    required this.id,
    required this.clientId,
    required this.productId,
    required this.type,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.createdAt,
    this.client,
    this.product,
  });

  /// Verifica si la licencia está vencida
  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  /// Verifica si la licencia está activa y vigente
  bool get isActiveAndValid {
    return status == LicenseStatus.activa && !isExpired;
  }

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      id: json['id'] ?? '',
      clientId: json['client_id'] ?? '',
      productId: json['product_id'] ?? '',
      type: LicenseType.fromString(json['type'] ?? 'licencia_unica'),
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      status: LicenseStatus.fromString(json['status'] ?? 'activa'),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      client: json['clients'] != null
          ? ClientModel.fromJson(json['clients'])
          : null,
      product: json['crm_products'] != null
          ? CrmProductModel.fromJson(json['crm_products'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'product_id': productId,
      'type': type.value,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Para crear una nueva licencia (sin id, se genera en DB)
  Map<String, dynamic> toInsertJson() {
    return {
      'client_id': clientId,
      'product_id': productId,
      'type': type.value,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
      'status': status.value,
    };
  }

  LicenseModel copyWith({
    String? id,
    String? clientId,
    String? productId,
    LicenseType? type,
    DateTime? startDate,
    DateTime? endDate,
    LicenseStatus? status,
    DateTime? createdAt,
    ClientModel? client,
    CrmProductModel? product,
  }) {
    return LicenseModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      client: client ?? this.client,
      product: product ?? this.product,
    );
  }

  @override
  String toString() =>
      'LicenseModel(id: $id, type: ${type.displayName}, status: ${status.displayName})';
}
