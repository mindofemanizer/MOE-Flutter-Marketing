/// Coupon redemption status.
enum CouponStatus {
  unused('unused', 'Belum Digunakan'),
  used('used', 'Digunakan'),
  expired('expired', 'Kadaluarsa'),
  invalid('invalid', 'Tidak Valid');

  const CouponStatus(this.value, this.displayName);
  final String value;
  final String displayName;

  factory CouponStatus.fromValue(String value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse: () => invalid,
    );
  }

  bool get isAvailable => this == unused && !isExpired;
  bool get isExpired => this == expired;
}
