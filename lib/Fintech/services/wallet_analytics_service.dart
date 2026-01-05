import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class WalletAnalyticsService {
  FirebaseAnalytics analytics =
      FirebaseAnalytics.instance; //Instance of Firebase Analytics
  FirebaseCrashlytics crashlytics =
      FirebaseCrashlytics.instance; //Instance of Firebase Crashlytics

  ///Firebase Analytics Logics
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

  ///Firebase Crash Analytics Logics
  Future<void> logUserJourney(String journeyName) async {
    await crashlytics.log(journeyName);
    print("Journey Log: $journeyName"); //Console Massege
  }

  //Set Custom Key Value For Easy Debug and find Accual Error
  Future<void> setCustomKey({
    required String paymentMathode,
    required double amount,
    String? userId,
  }) async {
    await crashlytics.setCustomKey('PaymentMethode', paymentMathode);
    await crashlytics.setCustomKey('Amount', amount);
    if (userId != null) {
      await crashlytics.setUserIdentifier(userId);
    }
  }

  //Screen View For Whare Error Occers
  Future<void> logScreenViewForCrash({required String screenName}) async {
    await analytics.logScreenView(screenName: screenName);
    await logUserJourney('User Open Screen $screenName');
    print('Current Screen: $screenName');
  }

  //Record Error For Crashlytics Fatal and non Fatal
  Future<void> recordError(
    dynamic exception,
    StackTrace stackTrace, {
    String reason = 'Unknown Error',
  }) async {
    await crashlytics.recordError(exception, stackTrace,reason: reason);
    print('Error Recorded: $reason');
  }
}
