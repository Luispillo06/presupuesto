/// Modelo de Producto del CRM
class CrmProductModel {
  final String id;
  final String name;
  final String? description;
  final double priceOnePayment;
  final double priceSubscription;
  final DateTime createdAt;

  CrmProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.priceOnePayment,
    required this.priceSubscription,
    required this.createdAt,
  });

  factory CrmProductModel.fromJson(Map<String, dynamic> json) {
    return CrmProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      priceOnePayment: (json['price_one_payment'] ?? 0).toDouble(),
      priceSubscription: (json['price_subscription'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price_one_payment': priceOnePayment,
      'price_subscription': priceSubscription,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Para crear un nuevo producto (sin id, se genera en DB)
  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      'description': description,
      'price_one_payment': priceOnePayment,
      'price_subscription': priceSubscription,
    };
  }

  CrmProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? priceOnePayment,
    double? priceSubscription,
    DateTime? createdAt,
  }) {
    return CrmProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priceOnePayment: priceOnePayment ?? this.priceOnePayment,
      priceSubscription: priceSubscription ?? this.priceSubscription,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'CrmProductModel(id: $id, name: $name)';
}
