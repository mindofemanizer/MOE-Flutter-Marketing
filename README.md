# MOE-Flutter-Marketing

Marketing package for MOE Flutter ecosystem â€” coupons, promotions, campaigns.

## Installation

```yaml
dependencies:
  moe_flutter_marketing:
    git:
      url: https://github.com/mindofemanizer/MOE-Flutter-Marketing.git
      ref: v1.0.0
```

## Usage

### Setup

```dart
import 'package:moe_flutter_foundation/moe_flutter_foundation.dart';
import 'package:moe_flutter_marketing/moe_flutter_marketing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  await MoeFoundation.setup(
    envConfig: EnvConfig.fromEnvironment(),
    sharedPreferences: prefs,
  );

  MoeMarketing.setup(
    config: MoeMarketingConfig(
      apiUrl: 'https://api.kioskit.com/api/marketing',
      enablePushNotifications: true,
      enableEmailMarketing: false, // disable for this app
    ),
  );

  runApp(MoeFoundationProviderScope(child: MyApp()));
}
```

### Validate Coupon Code

```dart
final state = ref.watch(couponsProvider.notifier);

// Validate code when user enters it
await ref.read(couponsProvider.notiant).validate(
  'SUMMER25',
  cartTotal: 150000, // Optional: filter by cart total
);

switch (state) {
  case CouponLoaded(:final coupon):
    print('âœ… Valid coupon!');
    print('${coupon.name}: ${coupon.value}% off');
    
    // Apply discount to cart
    final discountAmount = calculateDiscount(
      cartTotal: 150000,
      coupon: coupon,
    );
    
  case CouponLoading:
    CircularProgressIndicator();
    
  case CouponError(:final failure):
    Text('Invalid code: ${failure.message}', style: TextStyle(color: Colors.red));
}
```

### Display Available Coupons

```dart
final result = await ref.read(couponsProvider.notifier).listCoupons(onlyValid: true);

if (result is Ok) {
  ListView.builder(
    itemCount: result.data.length,
    itemBuilder: (ctx, i) => Card(
      child: ListTile(
        title: Text(result.data[i].code),
        subtitle: Text(result.data[i].name),
        trailing: Chip(
          label: Text(
            result.data[i].validUntil.day == 1 
                ? 'Habis besok' 
                : 'Berlalu ${Formatters.date(result.data[i].validUntil)}',
            style: TextStyle(fontSize: 10),
          ),
        ),
      ),
    ),
  );
}
```

### Create Campaign

```dart
// Send push notification about new sale
await ref.read(marketingRepositoryProvider).createCampaign(
  name: 'Summer Sale 2026',
  channel: 'push',
  targetUserIds: ['user_1', 'user_2'],
  message: 'Diskon 25% selama 48 jam saja!',
  scheduledAt: DateTime(2026, 8, 15, 9, 0), // Schedule for future
);
```

### Check Coupon Validity

```dart
// In checkout screen
Widget buildCouponSection() {
  if (state is CouponLoaded && !((state as CouponLoaded).coupon).isValid) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.red.shade100,
      child: Text('Kupon sudah kadaluarsa'),
    );
  }
  
  return TextField(
    decoration: InputDecoration(
      labelText: 'Masukkan kode kupon',
      suffixIcon: IconButton(
        icon: Icon(Icons.check_circle),
        onPressed: () => validateCoupon(),
      ),
    ),
  );
}
```

## What's Included

| Module | Description |
|--------|-------------|
| `CouponModel` | Full promo code with validity, discounts, restrictions |
| `PromotionType` | Percentage/Fixed/BOGO/Free Shipping types |
| `CouponStatus` | Usage tracking states |
| `MarketingRepository` | Validate, list, create campaigns |
| `CouponsNotifier` | Auto-validation with cart total check |
