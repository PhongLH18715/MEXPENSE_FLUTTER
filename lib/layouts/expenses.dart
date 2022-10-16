import 'package:flutter/material.dart';
import 'package:mexpense/database/expenseDB.dart';
import 'package:mexpense/database/tripDB.dart';
import 'package:mexpense/layouts/expenseForm.dart';
import 'package:mexpense/layouts/tripForm.dart';
import 'package:mexpense/main.dart';
import 'package:mexpense/model/trip.dart';

import '../model/expense.dart';

class Expenses extends StatefulWidget {
  Expenses({Key? key, this.trip}) : super(key: key);
  Trip? trip;

  @override
  State<StatefulWidget> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  void initState() {
    super.initState();
    setState(() {
      getTrip(widget.trip!.id);
      getExpenses(widget.trip!.id);
    });
  }

  Future<Trip> getTrip(int tripId) async {
    return await TripDB.helper.getTrip(tripId);
  }

  Future<List<Expense>> getExpenses(int tripId) async {
    return await ExpenseDB.helper.getExpenses(tripId);
  }

  updateTrip() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TripForm(
                  trip: widget.trip!,
                )));
  }

  deleteTrip() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content: const Text(
                "This trip will be deleted and the action cannot be undone?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    TripDB.helper.deleteTrip(widget.trip!.id);
                    Navigator.pushNamed(context, Routes.trips);
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
        title: Text(widget.trip!.name),
        actions: <Widget>[
          IconButton(onPressed: deleteTrip, icon: const Icon(Icons.delete)),
          IconButton(onPressed: updateTrip, icon: const Icon(Icons.update)),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: FutureBuilder(
                future: getTrip(widget.trip!.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.data!.name),
                            Text(snapshot.data!.destination),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text("Trip loading"));
                  }
                }),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: getExpenses(widget.trip!.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return expenseList(snapshot);
              } else {
                return const Center(
                    child: Text("No Expense available, please add one!"));
              }
            },
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExpenseForm(
                        trip: widget.trip!,
                      )));
        },
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget expenseList(AsyncSnapshot snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data?.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExpenseForm(
                              trip: widget.trip!,
                              expense: snapshot.data![index],
                            )));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data![index].name),
                          Text("${snapshot.data![index].date}")
                        ],
                      ),
                      Column(children: [
                        Column(
                          children: [
                            Text(
                                "\$${snapshot.data![index].cost} x ${snapshot.data![index].amount}"),
                          ],
                        )
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
