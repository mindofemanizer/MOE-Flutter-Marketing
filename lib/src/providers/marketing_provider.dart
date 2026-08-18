import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_marketing/src/models/coupon_model.dart';
import 'package:moe_flutter_marketing/src/services/marketing_repository.dart';

/// State for coupons.
sealed class CouponState {
  const CouponState();
}

final class CouponInitial extends CouponState {
  const CouponInitial();
}

final class CouponLoading extends CouponState {
  const CouponLoading();
}

final class CouponLoaded extends CouponState {
  final CouponModel coupon;
  const CouponLoaded(this.coupon);
}

final class CouponError extends CouponState {
  final AppFailure failure;
  const CouponError(this.failure);
}

/// Notifier for coupons.
class CouponsNotifier extends StateNotifier<CouponState> {
  final MarketingRepository _repository;

  CouponsNotifier(this._repository) : super(const CouponInitial());

  Future<AppResult<CouponModel>> validate(
    String code, {
    double? cartTotal,
  }) async {
    state = const CouponLoading();

    final result = await _repository.validateCoupon(code, cartTotal: cartTotal);

    switch (result) {
      case Ok(:final data):
        state = CouponLoaded(data);
      case Err(:final failure):
        state = CouponError(failure);
    }

    return result;
  }

  Future<AppResult<List<CouponModel>>> listCoupons({
    bool onlyValid = true,
  }) async {
    final result = await _repository.listCoupons(onlyValid: onlyValid);
    return result;
  }
}

/// Provider for MarketingRepository.
final marketingRepositoryProvider = Provider<MarketingRepository>((ref) {
  throw UnimplementedError('MoeMarketing.setup() must be called before use.');
});

/// Provider for CouponsNotifier.
final couponsProvider = StateNotifierProvider<CouponsNotifier, CouponState>(
  (ref) => CouponsNotifier(ref.watch(marketingRepositoryProvider)),
);
