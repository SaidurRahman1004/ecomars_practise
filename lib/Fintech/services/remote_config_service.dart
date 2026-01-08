import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  // Singleton Pattern For Entire App
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  factory RemoteConfigService() => _instance;

  RemoteConfigService._internal();

  //Parameter Key For Remote Config
  final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance; //instance Of Fire BAse!
  static const String _keyIsPaymentEnabled = 'is_payment_enabled';
  static const String _keyTransactionFee = 'transaction_fee_percentage';
  static const String _keySupportPhone = 'support_phone_number';
  static const String _keyFeaturedService = 'featured_service';

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 1),
        ),
      );
      //Default Value For Remote Config If Internet Not Worked Then show it
      await _remoteConfig.setDefaults({
        _keyIsPaymentEnabled: true,
        _keyTransactionFee: 10,
        _keySupportPhone: '+1234567890',
        _keyFeaturedService: 'Service A',
      });
      //Fetch From Server First time
      await fetchAndActivate();
    } catch (e) {
      debugPrint('Remote Config Init Error: $e');
    }
  }

  Future<bool> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();
    debugPrint('Remote Config Updated: $updated');
    return updated;
  }

  //Gratter Find Value From Another
  bool get isPaymentEnabled => _remoteConfig.getBool(_keyIsPaymentEnabled);
  double get transactionFee => _remoteConfig.getDouble(_keyTransactionFee);
  String get supportPhoneNumber => _remoteConfig.getString(_keySupportPhone);
  String get featuredService => _remoteConfig.getString(_keyFeaturedService);
}
