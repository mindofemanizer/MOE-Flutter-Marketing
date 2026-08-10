/// Promotion type.
sealed class PromotionType {
  const PromotionType();
  
  String get stringValue;
  
  factory PromotionType.fromString(String value) {
    switch (value) {
      case 'percentage':
        return percentage;
      case 'fixed':
        return fixed;
      case 'buy_x_get_y':
        return buyXGetY;
      case 'free_shipping':
        return freeShipping;
      default:
        throw Exception('Unknown promotion type: $value');
    }
  }

  static const percentage = _PromotionTypePercentage();
  static const fixed = _PromotionTypeFixed();
  static const buyXGetY = _PromotionTypeBuyXGetY();
  static const freeShipping = _PromotionTypeFreeShipping();
}

class _PromotionTypePercentage extends PromotionType {
  const _PromotionTypePercentage();
  @override
  String get stringValue => 'percentage';
}

class _PromotionTypeFixed extends PromotionType {
  const _PromotionTypeFixed();
  @override
  String get stringValue => 'fixed';
}

class _PromotionTypeBuyXGetY extends PromotionType {
  const _PromotionTypeBuyXGetY();
  @override
  String get stringValue => 'buy_x_get_y';
}

class _PromotionTypeFreeShipping extends PromotionType {
  const _PromotionTypeFreeShipping();
  @override
  String get stringValue => 'free_shipping';
}
