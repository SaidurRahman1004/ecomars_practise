import 'package:ecomars_practise/Fintech/screens/transaction_history_screen.dart';
import 'package:ecomars_practise/Fintech/services/wallet_analytics_service.dart';
import 'package:ecomars_practise/Fintech/widgets/transaction_dialog.dart';
import 'package:ecomars_practise/widgets/custo_snk.dart';
import 'package:ecomars_practise/widgets/custom_button.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../services/remote_config_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  WalletAnalyticsService _analyticsService = WalletAnalyticsService();
  final RemoteConfigService _remoteConfig = RemoteConfigService();
  bool _isLoading = false;

  Future<void> refreshConfig() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _remoteConfig.fetchAndActivate();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) mySnkmsg('Failed to fetch config', context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _analyticsService.logScreenView('WalletScreen');
    refreshConfig();
  }

  @override
  Widget build(BuildContext context) {
    bool isEnabled = _remoteConfig.isPaymentEnabled;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshConfig,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.lightBlueAccent],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'FinTech Wallet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //balance
                  Positioned(
                    top: 80,
                    left: 20,
                    right: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: SizedBox(
                        height: 140,
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                'Current Balance',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                '৳10,000',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_remoteConfig.supportPhoneNumber.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Support: ${_remoteConfig.supportPhoneNumber}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 110),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.flash_on_outlined),
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 110),
              if (!isEnabled)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Payment temporarily unavailable",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildActionButton('Sent Money', Icons.send, isEnabled),
                    _buildActionButton(
                      'Request Money',
                      Icons.request_quote,
                      isEnabled,
                    ),
                    _buildActionButton(
                      'Pay Bill',
                      Icons.receipt_long,
                      isEnabled,
                    ),
                    _buildActionButton(
                      'Mobile Recharge',
                      Icons.phonelink_ring,
                      isEnabled,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonName: 'View History',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionHistoryScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonName: "Crash",
                onPressed: () {
                  FirebaseCrashlytics.instance.crash();
                  _analyticsService.logUserJourney('User Clicked Crash');
                  mySnkmsg('Crashed', context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, bool isEnabled) {
    bool isFeatured = _remoteConfig.featuredService == title;
    return InkWell(
      onTap: isEnabled
          ? () {
              showDialog(
                context: context,
                builder: (context) => TransactionDialog(transactionType: title),
              );
              _analyticsService.logUserJourney('User Clicked $title');
            }
          : () => mySnkmsg("This feature is currently disabled", context),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: isFeatured ? Colors.blue.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isFeatured ? Colors.blue : Colors.grey.shade200,
                width: isFeatured ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade100, blurRadius: 5),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isFeatured)
                  const Badge(
                    label: Text("Featured"),
                    backgroundColor: Colors.orange,
                  ),
                Icon(
                  icon,
                  size: 40,
                  color: isFeatured ? Colors.blue : Colors.deepPurple,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
