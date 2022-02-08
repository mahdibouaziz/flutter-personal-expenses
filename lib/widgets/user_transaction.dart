import 'package:flutter/material.dart';
import 'package:flutter_personal_expenses/models/transaction.dart';
import 'package:flutter_personal_expenses/widgets/new_transaction.dart';
import 'package:flutter_personal_expenses/widgets/transaction_list.dart';

class UserTransaction extends StatefulWidget {
  const UserTransaction({Key? key}) : super(key: key);

  @override
  _UserTransactionState createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransaction> {
  final List<Transaction> userTransactions = [
    Transaction(
        amomunt: 60, date: DateTime.now(), id: 't1', title: 'New Shoes'),
    Transaction(
        amomunt: 40, date: DateTime.now(), id: 't1', title: 'Weekly Groceries'),
    Transaction(
        amomunt: 30, date: DateTime.now(), id: 't1', title: 'New Shoes2'),
    Transaction(
        amomunt: 57, date: DateTime.now(), id: 't1', title: 'New Shoes3'),
  ];

  void addNewTransaction(String title, double amount) {
    final newTx = Transaction(
        amomunt: amount,
        date: DateTime.now(),
        id: DateTime.now().toString(),
        title: title);

    setState(() {
      userTransactions.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NewTransaction(addNewTransaction: addNewTransaction),
        TransactionList(userTransactions: userTransactions),
      ],
    );
  }
}
