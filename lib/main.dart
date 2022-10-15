import 'package:flutter/material.dart';
import 'package:mexpense/layouts/tripForm.dart';
import 'package:mexpense/layouts/trips.dart';
import 'package:mexpense/model/trip.dart';

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
