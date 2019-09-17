import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';

class ExpensesList extends StatefulWidget {
  @override
  _ExpensesListState createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList>
    with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'Notebook',
      amount: 2000.0,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Headphone',
      amount: 1500.0,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'test',
      amount: 500.0,
      date: DateTime.now(),
    ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return this._userTransactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    setState(
      () {
        this._userTransactions.add(
              Transaction(
                title: title,
                amount: amount,
                date: chosenDate,
                id: DateTime.now().toString(),
              ),
            );
      },
    );
  }

  void _startNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction(this._addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      this._userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  Widget _buildShowCartContent(
      MediaQueryData mediaQuery, AppBar appBar, double ratio) {
    return this._showChart
        ? Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                ratio,
            child: Chart(this._recentTransactions),
          )
        : Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.7,
            child: TransactionList(
                this._userTransactions, this._deleteTransaction),
          );
  }

  PreferredSizeWidget _buildAppBar() {
    Text title = Text('Personal Expenses');

    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: title,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () => this._startNewTransaction(context),
            )
          ],
        ),
      );
    }

    return AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => this._startNewTransaction(context),
        )
      ],
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = this._buildAppBar();

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Show chart: ',
                    style: Theme.of(context).textTheme.title,
                  ),
                  Switch.adaptive(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  )
                ],
              ),
            if (this._showChart || !isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    (isLandscape ? 0.7 : 0.3),
                child: Chart(this._recentTransactions),
              ),
            if (!this._showChart || !isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.7,
                child: TransactionList(
                    this._userTransactions, this._deleteTransaction),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => this._startNewTransaction(context),
                  ),
          );
  }
}
