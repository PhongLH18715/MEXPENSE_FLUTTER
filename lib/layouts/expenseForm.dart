// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mexpense/model/expense.dart';
import '../database/expenseDB.dart';
import '../main.dart';
import '../model/trip.dart';
import 'expenses.dart';

class ExpenseForm extends StatefulWidget {
  ExpenseForm({Key? key, this.expense, this.trip}) : super(key: key);
  Expense? expense;
  Trip? trip;

  @override
  State<StatefulWidget> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      nameController.text = widget.expense!.name;
      dateController.text = widget.expense!.date;
      costController.text = widget.expense!.cost.toString();
      amountController.text = widget.expense!.amount.toString();
      noteController.text = widget.expense!.notes;
    }
  }

  final expense_key = GlobalKey<FormState>();

  deleteExpense() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content: const Text(
                "This expense will be deleted and the action cannot be undone."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Expenses(
                                  trip: widget.trip!,
                                )));
                  },
                  child: const Text("Yes")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: widget.expense != null
            ? <Widget>[
                IconButton(
                    onPressed: deleteExpense, icon: const Icon(Icons.delete)),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: Form(
              key: expense_key,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      validator: textValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.category),
                          labelText: "Name",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      controller: dateController,
                      readOnly: true,
                      onTap: getDate,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          labelText: "Date",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      validator: numValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: costController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.attach_money),
                          labelText: "Cost",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      validator: numValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: amountController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          labelText: "Amount",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      controller: noteController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_pin),
                          labelText: "Other notes",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: ElevatedButton(
                        onPressed: saveExpense,
                        child: const Text('Save'),
                      )),
                ],
              )),
        ),
      ),
    );
  }

  void saveExpense() {
    if (expense_key.currentState!.validate()) {
      var currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      Expense e = Expense.createExpense(
          nameController.text,
          dateController.text,
          int.parse(costController.text),
          int.parse(amountController.text),
          noteController.text,
          widget.trip!.id);

      if (widget.expense == null) {
        ExpenseDB.helper.addExpense(e);
      } else {
        ExpenseDB.helper.updateExpense(widget.expense!.id, e);
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Expenses(
                    trip: widget.trip!,
                  )));
    }
  }

  void getDate() async {
    DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2077));
    if (datePicker != null) {
      dateController.text = DateFormat("dd/MM/yyyy").format(datePicker);
    }
  }

  static String? textValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty";
    }
    return null;
  }

  static String? numValidator(String? value) {
    if (value == null || value == "0") {
      return "Please enter a number";
    }
    return null;
  }
}
