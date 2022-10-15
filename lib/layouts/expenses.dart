import 'package:flutter/material.dart';
import 'package:mexpense/database/expenseDB.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Row(children: []),
        Expanded(
          child: FutureBuilder(
            future: ExpenseDB.helper.getExpenses(),
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
