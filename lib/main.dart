// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mexpense/layouts/expenseForm.dart';
import 'package:mexpense/layouts/expenses.dart';
import 'package:mexpense/layouts/tripForm.dart';
import 'package:mexpense/layouts/trips.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Routes.trips: (context) => const Trips(),
        Routes.trips_form: (context) => TripForm(),
        Routes.expense: (context) => Expenses(),
        Routes.expense_form: (context) => ExpenseForm(),
      },
      initialRoute: Routes.trips,
    );
  }
}

class Routes {
  static const trips = "/trip";
  static const trips_form = "/trip/form";
  static const expense = "/expense";
  static const expense_form = "/expense/form";
}
