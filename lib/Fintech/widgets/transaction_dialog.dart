import 'dart:math';

import 'package:ecomars_practise/Fintech/services/wallet_analytics_service.dart';
import 'package:ecomars_practise/widgets/custo_snk.dart';
import 'package:ecomars_practise/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../services/remote_config_service.dart';

enum PaymentMethode { Bkash, Nagad, Card }

class TransactionDialog extends StatefulWidget {
  final String transactionType; //Bkash Nagad Card
  const TransactionDialog({super.key, required this.transactionType});

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final TextEditingController _amountController = TextEditingController();
  PaymentMethode _selectedtMethode = PaymentMethode.Bkash;
  final WalletAnalyticsService _analyticsService = WalletAnalyticsService();
  bool _isLoading = false;
  final RemoteConfigService _remoteConfig = RemoteConfigService();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fee = _remoteConfig.transactionFee;
    return AlertDialog(
      title: Text(widget.transactionType),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.money, color: Colors.blueAccent),
              SizedBox(width: 5),
              Text('Amount', style: TextStyle(fontSize: 15)),
            ],
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _amountController,
            lableText: 'Enter Amount',
            hintText: '0',
            maxLine: 2,
            // onChanged: (value) {
            //   _analyticsService.logUserJourney("User Typeing Ammount");
            // },
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Transaction Fee: $fee%',
              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.payment, color: Colors.blueAccent),
              SizedBox(width: 5),
              Text('Payment Method', style: TextStyle(fontSize: 15)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            children: PaymentMethode.values.map((methode) {
              return ChoiceChip(
                label: Text(methode.name),
                selected: _selectedtMethode == methode,
                onSelected: (selected) {
                  setState(() {
                    _selectedtMethode = methode;
                  });
                  _analyticsService.logUserJourney(
                    "User Selected Payment Methode ${methode.name}",
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancle'),
        ),
        TextButton(
          onPressed: () {
            if (_amountController.text.isNotEmpty) {
              _confirmTransaction();
            }
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }

  //Confirm transaction button

  void _confirmTransaction() async {
    _analyticsService.logUserJourney('User Clicked Confirm Transaction Button');
    setState(() {
      _isLoading = true;
    });
    double amount = double.tryParse(_amountController.text) ?? 0.00;
    //Set Crashlytics Custom Key for See Extra Error info
    await _analyticsService.setCustomKey(
      paymentMathode: _selectedtMethode.name,
      amount: amount,
      userId: 'user 321',
    );
    try {
      if (amount <= 0) {
        throw Exception('Invalid Amount');
      }
      if (amount > 50000) {
        throw Exception('Amount Exceed');
      }
      //Analytics Logics event log start Transaction
      await _analyticsService.logTransactionStart(
        paymentMethod: _selectedtMethode.name,
        amount: amount,
        transactionType: widget.transactionType,
      );

      mySnkmsg('Processing Transaction', context);
      await Future.delayed(Duration(seconds: 2));
      int randomError = Random().nextInt(10);
      if (randomError < 2) {
        throw Exception("Payment Gateway Timeout (504)");
      } else if (randomError < 4) {
        throw Exception("Payment Failed: Insufficient Balance");
      }

      String txnId = 'TNX-${Random().nextInt(99999)}';
      //Analytics Logics Complete Transaction event log
      await _analyticsService.logTransactionComplete(
        transactionId: txnId,
        paymentMethod: _selectedtMethode.name,
        amount: amount,
      );
      if (mounted) {
        Navigator.pop(context);
        mySnkmsg(
          '" $amount BDT Sent via $_selectedtMethode (ID: $txnId)"',
          context,
        );
      }
    } catch (e, stackTrace) {
      //send Error Crash Analytics
      await _analyticsService.recordError(
        e,
        stackTrace,
        reason: 'Transaction Faild For ${widget.transactionType}',
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              " Error: ${e.toString().replaceAll('Exception:', '')}",
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'RETRY',
              textColor: Colors.white,
              onPressed: _confirmTransaction,
            ),
          ),
        );
      }
    }
  }
}
