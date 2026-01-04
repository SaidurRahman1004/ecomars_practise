import 'package:ecomars_practise/widgets/custo_snk.dart';
import 'package:flutter/material.dart';

import '../services/wallet_analytics_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  //SaMPLE daTA
  final List<Map<String, dynamic>> transactions = [
    {"id": "TXN-101", "title": "Send Money", "amount": 500, "date": "Today"},
    {
      "id": "TXN-102",
      "title": "Mobile Recharge",
      "amount": 100,
      "date": "Yesterday",
    },
    {
      "id": "TXN-103",
      "title": "Pay Bill",
      "amount": 1200,
      "date": "2 Jan 2026",
    },
  ];
  WalletAnalyticsService _analyticsService = WalletAnalyticsService();
  @override
  void initState() {
    super.initState();
    _analyticsService.logScreenView('TransactionHistoryScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (_, index) {
          final data = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(data['title']),
              subtitle: Text(data['date']),
              trailing: Text("৳ ${data['amount']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                //Analytics Logics event log
                _analyticsService.logTransactionHistory(data['id']);
                mySnkmsg("Viewing Details for ${data['id']}", context);
              }
            ),
          );

        },
      ),
    );
  }
}
