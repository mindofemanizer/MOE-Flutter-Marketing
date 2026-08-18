import 'package:flutter_test/flutter_test.dart';
import 'package:moe_flutter_marketing/moe_flutter_marketing.dart';

void main() {
  group('CouponModel', () {
    test('isValid returns true when current time is in range', () {
      final now = DateTime(2026, 8, 10);
      final coupon = CouponModel(
        id: 'c1',
        code: 'SUMMER25',
        name: 'Summer Sale',
        value: 25.0, // 25% off
        validFrom: DateTime(2026, 7, 1),
        validUntil: DateTime(2026, 9, 1),
        createdAt: now,
        updatedAt: now,
      );

      expect(coupon.isValid, isTrue);
      expect(coupon.isExpired, isFalse);
    });

    test('isExpired returns true when past validity date', () {
      final coupon = CouponModel(
        id: 'c1',
        code: 'EXPIRED',
        name: 'Expired Promo',
        value: 50000,
        validFrom: DateTime(2026, 1, 1),
        validUntil: DateTime(2026, 6, 1),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

      expect(coupon.isExpired, isTrue);
      expect(coupon.isValid, isFalse);
    });

    test('notYetActive returns true when before validFrom', () {
      final coupon = CouponModel(
        id: 'c1',
        code: 'UPCOMING',
        name: 'Coming Soon',
        value: 30000,
        validFrom: DateTime(2026, 9, 1),
        validUntil: DateTime(2026, 10, 1),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(coupon.notYetActive, isTrue);
      expect(coupon.isValid, isFalse);
    });

    test('fromJson parses all fields', () {
      final json = {
        'id': 'coupon-summer-2026',
        'code': 'SUMMER25',
        'name': 'Summer Sale 25%',
        'description': '25% discount summer promotion',
        'value': 25,
        'minimum_order': '100000',
        'maximum_discount': '500000',
        'applicable_products': ['prod_123'],
        'valid_from': '2026-07-01T00:00:00.000Z',
        'valid_until': '2026-08-31T23:59:59.000Z',
        'created_at': '2026-06-15T10:00:00.000Z',
        'updated_at': '2026-06-15T10:00:00.000Z',
      };

      final coupon = CouponModel.fromJson(json);

      expect(coupon.code, equals('SUMMER25'));
      expect(coupon.name, equals('Summer Sale 25%'));
      expect(coupon.value, equals(25));
      expect(coupon.minimumOrder, equals('100000'));
      expect(coupon.maximumDiscount, equals('500000'));
      expect(coupon.applicableProducts, equals(['prod_123']));
      expect(coupon.validFrom.year, equals(2026));
      expect(coupon.validUntil.month, equals(8));
      expect(coupon.isValid, isTrue);
    });
  });

  group('CouponStatus', () {
    test('isAvailable returns true only for unused and not expired', () {
      final unusedCoupon = CouponStatus.unused;
      expect(unusedCoupon.isAvailable, isTrue);
      
      // Simulate expired status
      final expiredCoupon = CouponStatus.expired;
      expect(expiredCoupon.isAvailable, isFalse);
      expect(expiredCoupon.isExpired, isTrue);
    });
  });

  group('PromotionType', () {
    test('has correct string values', () {
      expect(PromotionType.percentage.stringValue, equals('percentage'));
      expect(PromotionType.fixed.stringValue, equals('fixed'));
      expect(PromotionType.buyXGetY.stringValue, equals('buy_x_get_y'));
      expect(PromotionType.freeShipping.stringValue, equals('free_shipping'));
    });
  });

  group('MoeMarketingConfig', () {
    test('has required apiUrl', () {
      const config = MoeMarketingConfig(
        apiUrl: 'https://api.example.com/marketing',
      );

      expect(config.apiUrl, equals('https://api.example.com/marketing'));
      expect(config.enablePushNotifications, isTrue);
      expect(config.enableEmailMarketing, isTrue);
    });
  });
}
