import 'package:flutter/material.dart';
import 'package:mexpense/database/tripDB.dart';

import '../main.dart';
import '../model/trip.dart';
import 'expenses.dart';

class Trips extends StatefulWidget {
  const Trips({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TripState();
}

class _TripState extends State<Trips> {
  TextEditingController searchController = TextEditingController();

  late Future<List<Trip>> trips;

  @override
  void initState() {
    super.initState();

    setState(() {
      trips = getTrips();
    });
  }

  Future<List<Trip>> getTrips() async {
    return await TripDB.helper.getTrips();
  }

  void searchTrip(String value) async {
    setState(() {
      trips = TripDB.helper.getTripByName(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
            child: TextFormField(
              controller: searchController,
              keyboardType: TextInputType.text,
              onChanged: (value) => searchTrip(value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: trips,
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
                            Text(snapshot.data![index].startDate),
                            Text(snapshot.data![index].endDate)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(snapshot.data![index].destination),
                            const Text(""),
                            Text(
                                "Total: ${snapshot.data![index].total.toString()}")
                          ],
                        )
                      ]),
                ),
              ),
            ),
          );
        });
  }
}
