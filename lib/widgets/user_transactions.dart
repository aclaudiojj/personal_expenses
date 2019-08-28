import 'package:flutter/material.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';

class UserTransactions extends StatefulWidget {
  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'computer',
      amount: 2000.0,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'headphone',
      amount: 1500.0,
      date: DateTime.now(),
    ),
  ];

  void _addNewTransaction(String title, double amount) {
    setState(() {
      this._userTransactions.add(
            Transaction(
              title: title,
              amount: amount,
              date: DateTime.now(),
              id: DateTime.now().toString(),
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NewTransaction(this._addNewTransaction),
        TransactionList(this._userTransactions),
      ],
    );
  }
}
