import 'package:flutter/material.dart';
import 'package:mexpense/database/tripDB.dart';

import '../main.dart';
import 'expenses.dart';

class Trips extends StatefulWidget {
  const Trips({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TripState();
}

class _TripState extends State<Trips> {
  @override
  void initState() {
    super.initState();
    setState(() {
      TripDB.helper.getTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: TripDB.helper.getTrips(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return tripList(snapshot);
                } else {
                  return const Center(
                      child: Text("No Trip available, please add one!"));
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.trips_form);
        },
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget tripList(AsyncSnapshot snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data?.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print("Clicked");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Expenses(
                        trip: snapshot.data![index],
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data![index].name),
                        Text(snapshot.data![index].startDate),
                        Text(snapshot.data![index].endDate)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(snapshot.data![index].destination),
                        const Text(""),
                        Text("Total: ${snapshot.data![index].total.toString()}")
                      ],
                    )
                  ]),
            ),
          );
        });
  }
}
