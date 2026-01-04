import 'dart:math';

import 'package:ecomars_practise/Fintech/services/wallet_analytics_service.dart';
import 'package:ecomars_practise/widgets/custo_snk.dart';
import 'package:ecomars_practise/widgets/custom_button.dart';
import 'package:ecomars_practise/widgets/custom_text_field.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    double amount = double.tryParse(_amountController.text) ?? 0.00;

    //Analytics Logics event log start Transaction
    await _analyticsService.logTransactionStart(
      paymentMethod: _selectedtMethode.name,
      amount: amount,
      transactionType: widget.transactionType,
    );

    Navigator.pop(context);
    mySnkmsg('Processing Transaction', context);
    await Future.delayed(Duration(seconds: 2));
    String txnId = 'TNX-${Random().nextInt(99999)}';
    //Analytics Logics Complete Transaction event log
    await _analyticsService.logTransactionComplete(
      transactionId: txnId,
      paymentMethod: _selectedtMethode.name,
      amount: amount,
    );
    mySnkmsg(
      '" $amount BDT Sent via $_selectedtMethode (ID: $txnId)"',
      context,
    );
  }
}
