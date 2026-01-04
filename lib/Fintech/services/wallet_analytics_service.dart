import 'package:firebase_analytics/firebase_analytics.dart';

class WalletAnalyticsService {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  //Screen View Log
  Future<void> logScreenView(String screenName) async {
    await analytics.logScreenView(screenName: screenName);
    print('Current Screen: $screenName');
  }

  //transaction Starting  log
  Future<void> logTransactionStart({
    required String paymentMethod,
    required double amount,
    required String transactionType,
  }) async {
    await analytics.logEvent(
      name: 'transaction_initiated',
      parameters: {
        'transaction_type': transactionType,
        'payment_method': paymentMethod,
        'amount': amount,
        "currency": "BDT",
      },
    );
    print("Analytics: Transaction Initiated ($transactionType - $amount)");
  }

  //Complete transaction log
  Future<void> logTransactionComplete({
    required String transactionId,
    required String paymentMethod,
    required double amount,
  }) async {
    await analytics.logEvent(
      name: 'transaction_completed',
      parameters: {
        "transaction_id": transactionId,
        "payment_method": paymentMethod,
        "amount": amount,
        "success": true,
      },
    );

    //User property ,which Methode User Can use
    await analytics.setUserProperty(
      name: 'preferred_payment_method',
      value: paymentMethod,
    );
    print("Analytics: Transaction Completed ($transactionId)");
  }

  //History Cheak Event
  Future<void> logTransactionHistory(String transactionId) async {
    await analytics.logEvent(
      name: 'transaction_view',
      parameters: {"transaction_id": transactionId},
    );
  }
}
