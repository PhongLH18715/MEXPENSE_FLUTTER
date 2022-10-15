import 'package:flutter/material.dart';
import 'package:mexpense/database/expenseDB.dart';
import 'package:mexpense/database/tripDB.dart';
import 'package:mexpense/layouts/expenseForm.dart';
import 'package:mexpense/model/trip.dart';

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
      ExpenseDB.helper.getExpenses(widget.trip!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        FutureBuilder(
            future: TripDB.helper.getTrip(widget.trip!.id),
            builder: (context, snapshot) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(snapshot.data!.name),
                      Text(snapshot.data!.destination)
                    ],
                  ),
                ],
              );
            }),
        Expanded(
          child: FutureBuilder(
            future: ExpenseDB.helper.getExpenses(widget.trip!.id),
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
            padding: const EdgeInsets.fromLTRB(12.0, 6, 12, 6),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(snapshot.data![index].name),
                          ],
                        ),
                        Column(
                          children: [
                            Text(snapshot.data![index].destination),
                          ],
                        )
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(snapshot.data![index].date),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                                "\$${snapshot.data![index].cost} x ${snapshot.data![index].amount}"),
                          ],
                        )
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(snapshot.data![index].comment ??= "No comments")
                      ]),
                ],
              ),
            ),
          );
        });
  }
}
