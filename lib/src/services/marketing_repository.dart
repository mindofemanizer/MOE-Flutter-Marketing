import 'package:dio/dio.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_marketing/src/config/marketing_config.dart';
import 'package:moe_flutter_marketing/src/models/coupon_model.dart';

/// Repository for marketing operations.
class MarketingRepository {
  final Dio _dio;

  MarketingRepository(this._dio, MoeMarketingConfig _);

  // ── Coupons ────────────────────────────────────────────────

  /// Validate coupon code.
  Future<AppResult<CouponModel>> validateCoupon(
    String code, {
    double? cartTotal,
  }) async {
    try {
      final params = <String, dynamic>{'code': code};
      if (cartTotal != null) {
        params['cart_total'] = cartTotal;
      }

      final response = await _dio.get(
        '/coupons/validate',
        queryParameters: params,
      );
      return Ok(CouponModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(type: FailureType.unknown, message: e.toString()));
    }
  }

  /// List available coupons.
  Future<AppResult<List<CouponModel>>> listCoupons({
    DateTime? startDate,
    DateTime? endDate,
    bool onlyValid = true,
  }) async {
    try {
      final params = <String, dynamic>{
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        'only_valid': onlyValid,
      };
      final response = await _dio.get('/coupons', queryParameters: params);
      final data = response.data as List<dynamic>;
      final coupons = data
          .whereType<Map<String, dynamic>>()
          .map((c) => CouponModel.fromJson(c))
          .toList();
      return Ok(coupons);
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(type: FailureType.unknown, message: e.toString()));
    }
  }

  // ── Campaigns ──────────────────────────────────────────────

  /// Create marketing campaign (push/email).
  Future<AppResult<void>> createCampaign({
    required String name,
    required String channel,
    required List<String> targetUserIds,
    String? message,
    DateTime? scheduledAt,
  }) async {
    try {
      await _dio.post(
        '/campaigns',
        data: {
          'name': name,
          'channel': channel,
          'target_user_ids': targetUserIds,
          'message': ?message,
          if (scheduledAt != null)
            'scheduled_at': scheduledAt.toIso8601String(),
        },
      );
      return const Ok(null);
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(type: FailureType.unknown, message: e.toString()));
    }
  }

  // ── Analytics ──────────────────────────────────────────────

  /// Get campaign performance metrics.
  Future<AppResult<Map<String, double>>> getCampaignMetrics(
    String campaignId,
  ) async {
    try {
      final response = await _dio.get('/campaigns/$campaignId/metrics');
      final data = response.data as Map<String, dynamic>;
      return Ok({
        'impressions': (data['impressions'] as num).toDouble(),
        'clicks': (data['clicks'] as num).toDouble(),
        'conversions': (data['conversions'] as num).toDouble(),
      });
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(type: FailureType.unknown, message: e.toString()));
    }
  }
}
