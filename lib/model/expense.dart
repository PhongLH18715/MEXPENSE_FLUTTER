import 'package:mexpense/constants.dart';

class Expense {
  int id = _Expense.id;
  String name = _Expense.name;
  String date = _Expense.date;
  int cost = _Expense.cost;
  int amount = _Expense.amount;
  String notes = _Expense.notes;
  int tripId = _Expense.tripId;

  Expense(this.id, this.name, this.date, this.cost, this.amount, this.notes,
      this.tripId);

  Expense.createExpense(
      this.name, this.date, this.cost, this.amount, this.notes, this.tripId);

  Expense.empty();

  Expense.fromJSON(Map<String, dynamic> json)
      : id = json[EXPENSE_ID],
        name = json[EXPENSE_NAME],
        cost = json[EXPENSE_COST],
        amount = json[EXPENSE_AMOUNT],
        notes = json[EXPENSE_NOTES],
        tripId = json[EXPENSE_TRIP_ID];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      EXPENSE_NAME: name,
      EXPENSE_DATE: date,
      EXPENSE_COST: cost,
      EXPENSE_AMOUNT: amount,
      EXPENSE_NOTES: notes,
      EXPENSE_TRIP_ID: tripId
    };
  }
}

class _Expense {
  static const id = -1;
  static const name = "";
  static const date = "";
  static const cost = 0;
  static const amount = 0;
  static const notes = "";
  static const tripId = -1;
}
