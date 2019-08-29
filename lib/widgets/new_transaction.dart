import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function _addTransactionAction;

  NewTransaction(this._addTransactionAction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  void _submitData() {
    final String title = this.titleController.text;
    final double amount = double.parse(this.amountController.text);

    if (title.isEmpty || amount <= 0) {
      return;
    }

    this.widget._addTransactionAction(title, amount);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'title'),
              controller: this.titleController,
              onSubmitted: (_) => this._submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'amount'),
              controller: this.amountController,
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
              ),
              onSubmitted: (_) => this._submitData(),
            ),
            FlatButton(
              child: Text('Add transaction'),
              textColor: Colors.purple,
              onPressed: this._submitData,
            )
          ],
        ),
      ),
    );
  }
}
