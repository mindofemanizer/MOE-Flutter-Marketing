/// Promotional coupon/discount code.
class CouponModel extends Equatable {
  final String id;
  final String code;
  final String name;
  final String description;
  final double value;
  final String? minimumOrder;
  final String? maximumDiscount;
  final List<String>? applicableProducts;
  final String? applicableCategories;
  final int maxUsesPerUser;
  final DateTime validFrom;
  final DateTime validUntil;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CouponModel({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.value,
    this.minimumOrder,
    this.maximumDiscount,
    this.applicableProducts,
    this.applicableCategories,
    this.maxUsesPerUser,
    required this.validFrom,
    required this.validUntil,
    required this.createdAt,
    required this.updatedAt,
  }) : assert value > 0;

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      value: (json['value'] as num).toDouble(),
      minimumOrder: json['minimum_order'] as String?,
      maximumDiscount: json['maximum_discount'] as String?,
      applicableProducts: (json['applicable_products'] as List<dynamic>?)?.map((p) => p as String).toList(),
      applicableCategories: json['applicable_categories'] as String?,
      maxUsesPerUser: json['max_uses_per_user'] as int?,
      validFrom: DateTime.parse(json['valid_from'] as String),
      validUntil: DateTime.parse(json['valid_until'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'value': value,
      if (minimumOrder != null) 'minimum_order': minimumOrder,
      if (maximumDiscount != null) 'maximum_discount': maximumDiscount,
      if (applicableProducts != null) 'applicable_products': applicableProducts,
      if (applicableCategories != null) 'applicable_categories': applicableCategories,
      if (maxUsesPerUser != null) 'max_uses_per_user': maxUsesPerUser,
      'valid_from': validFrom.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Check if coupon is currently valid.
  bool get isValid => 
    DateTime.now().isAfter(validFrom) && 
    DateTime.now().isBefore(validUntil);

  /// Is coupon expired?
  bool get isExpired => DateTime.now().isAfter(validUntil);

  /// Is coupon not yet active?
  bool get notYetActive => DateTime.now().isBefore(validFrom);

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        description,
        value,
        minimumOrder,
        maximumDiscount,
        applicableProducts,
        applicableCategories,
        maxUsesPerUser,
        validFrom,
        validUntil,
        createdAt,
        updatedAt,
      ];
}
