import 'package:mexpense/constants.dart';

class Trip {
  int id = _Trip.id;
  String name = _Trip.name;
  String destination = _Trip.destination;
  String startDate = _Trip.startDate;
  String endDate = _Trip.endDate;
  bool riskAssessment = _Trip.riskAssessment;
  String description = _Trip.description;
  int total = _Trip.total;

  Trip(this.id, this.name, this.destination, this.startDate, this.endDate,
      this.riskAssessment, this.description, this.total);

  Trip.createTrip(this.name, this.destination, this.startDate, this.endDate,
      this.riskAssessment, this.description);

  Trip.empty();

  Trip.fromJSON(Map<String, dynamic> json)
      : id = json[TRIP_ID],
        name = json[TRIP_NAME],
        destination = json[TRIP_DESTINATION],
        startDate = json[TRIP_START],
        endDate = json[TRIP_END],
        riskAssessment = json[TRIP_RISK_ASSESSMENT] == 1 ? true : false,
        description = json[TRIP_DESCRIPTION],
        total = json[TRIP_TOTAL];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      TRIP_NAME: name,
      TRIP_DESTINATION: destination,
      TRIP_START: startDate,
      TRIP_END: endDate,
      TRIP_RISK_ASSESSMENT: riskAssessment ? 1 : 0,
      TRIP_DESCRIPTION: description,
      TRIP_TOTAL: total
    };
  }

  @override
  String toString() {
    return 'Trip{id: $id, name: $name, destination: $destination, startDate: $startDate, endDate: $endDate, riskAssessment: $riskAssessment, description: $description, total: $total}';
  }
}

class _Trip {
  static const id = -1;
  static const name = "";
  static const destination = "";
  static const startDate = "";
  static const endDate = "";
  static const riskAssessment = false;
  static const description = "";
  static const total = 0;
}
