# Changelog

## 1.0.0 — 2026-08-10

### Added
- Initial release
- `CouponModel` — promo codes with validation dates, min order, max discount
- `PromotionType` — percentage/fixed/buy x get y/free shipping
- `CouponStatus` — usage tracking (unused/used/expired/invalid)
- `MarketingRepository` — validate coupons, list promotions, campaign creation
- `CouponsNotifier` — auto-validate codes against cart total
- `MoeMarketingConfig` — configurable API URL + notification channels

### Features
- Date-based validity checks (`isValid`, `isExpired`, `notYetActive`)
- Minimum order amount filtering
- Maximum discount cap support
- Product/category applicability restrictions
- Per-user usage limits
- Campaign performance metrics
