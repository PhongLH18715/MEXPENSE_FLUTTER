import 'package:flutter/material.dart';
import 'package:mexpense/database/tripDB.dart';

import '../main.dart';

class Trips extends StatefulWidget {
  const Trips({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TripState();
}

class _TripState extends State<Trips> {
  @override
  void initState() {
    super.initState();
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
          return Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 6, 12, 6),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(snapshot.data![index].name),
                      Text(snapshot.data![index].startDate),
                      Text(snapshot.data![index].endDate)
                    ],
                  ),
                  Column(
                    children: [
                      Text(snapshot.data![index].destination),
                      Text(snapshot.data![index].total)
                    ],
                  )
                ]),
          );
        });
  }
}
