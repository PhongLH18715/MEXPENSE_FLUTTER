// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mexpense/database/tripDB.dart';
import 'package:mexpense/main.dart';

import '../model/trip.dart';

class TripForm extends StatefulWidget {
  TripForm({Key? key, this.trip}) : super(key: key);
  Trip? trip;

  @override
  State<StatefulWidget> createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  bool assessment = false;

  final trip_key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: trip_key,
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
                        prefixIcon: Icon(Icons.airplanemode_active),
                        labelText: "Trip Name",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    validator: textValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: destinationController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_pin),
                        labelText: "Destination",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    controller: startController,
                    readOnly: true,
                    onTap: () => getDate('Start'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    controller: startController,
                    readOnly: true,
                    onTap: () => getDate('End'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Assessment"),
                        Switch(
                            value: assessment,
                            onChanged: ((value) {
                              setState(() {
                                assessment = value;
                              });
                            }))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_pin),
                        labelText: "Destination",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ElevatedButton(
                      onPressed: saveTrip,
                      child: const Text('Save'),
                    )),
              ],
            )),
      ),
    );
  }

  void saveTrip() {
    if (trip_key.currentState!.validate()) {
      var currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      Trip t = Trip.createTrip(
          nameController.text,
          destinationController.text,
          startController.text,
          endController.text,
          assessment,
          descriptionController.text);

      if (widget.trip!.id == -1) {
        TripDB.helper.addTrip(t);
        Navigator.pushNamed(context, Routes.trips);
      } else {
        TripDB.helper.updateTrip(widget.trip!.id, t);
        Navigator.pushNamed(context, Routes.trips);
      }
    }
  }

  void getDate(String dateController) async {
    DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2077));

    if (datePicker != null) {
      if (dateController == "Start") {
        setState(() {
          startController.text = DateFormat("dd/MM/yyyy").format(datePicker);
        });
      } else {
        setState(() {
          endController.text = DateFormat("dd/MM/yyyy").format(datePicker);
        });
      }
    }
  }

  static String? textValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty";
    }
    return null;
  }
}
