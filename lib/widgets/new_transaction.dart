import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function _addTransactionAction;

  NewTransaction(this._addTransactionAction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (this._amountController.text.isEmpty) {
      return;
    }

    final String title = this._titleController.text;
    final double amount = double.parse(this._amountController.text);

    if (title.isEmpty || amount <= 0 || this._selectedDate == null) {
      return;
    }

    this.widget._addTransactionAction(title, amount, this._selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedData) {
      if (pickedData == null) {
        return;
      }

      setState(() {
        this._selectedDate = pickedData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'title'),
                controller: this._titleController,
                onSubmitted: (_) => this._submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'amount'),
                controller: this._amountController,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onSubmitted: (_) => this._submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(this._selectedDate == null
                          ? 'No date chosen!'
                          : 'Selected date: ${DateFormat.yMd().format(this._selectedDate)}'),
                    ),
                    AdaptiveFlatButton('Select date', this._presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: this._submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
