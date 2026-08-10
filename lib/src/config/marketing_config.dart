import 'package:equatable/equatable.dart';

/// Configuration for MOE Marketing module.
class MoeMarketingConfig extends Equatable {
  final String apiUrl;
  final bool enablePushNotifications;
  final bool enableEmailMarketing;

  const MoeMarketingConfig({
    required this.apiUrl,
    this.enablePushNotifications = true,
    this.enableEmailMarketing = true,
  });

  @override
  List<Object?> get props => [apiUrl, enablePushNotifications, enableEmailMarketing];
}
