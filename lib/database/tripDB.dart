// ignore_for_file: constant_identifier_names

import 'package:mexpense/model/trip.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants.dart';

class TripDB {
  static const TABLE_NAME = "trip";

  // Singleton pattern
  // https://docs.flutter.dev/cookbook/persistence/sqlite
  static final TripDB helper = TripDB._init();

  static Database? _database;

  TripDB._init();

  Future<Database> get database async =>
      _database ??= await getDatabase(DB_PATH);

  Future<Database> getDatabase(String path) async {
    String databasePath = await getDatabasesPath();
    return await openDatabase(join(databasePath, path),
        onCreate: ((db, version) async {
      return await db.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_NAME ( $TRIP_ID INTEGER PRIMARY KEY AUTOINCREMENT, $TRIP_NAME TEXT, $TRIP_DESTINATION TEXT, $TRIP_START TEXT, $TRIP_END TEXT, $TRIP_RISK_ASSESSMENT INTEGER, $TRIP_DESCRIPTION TEXT, $TRIP_TOTAL INTEGER)");
    }), version: 1);
  }
  //

  Future closeDB() async {
    final db = await helper.database;
    db.close();
  }

  Future<List<Trip>> getTrips() async {
    final db = await helper.database;
    final trips = await db.query(TABLE_NAME);
    return trips.map((t) => Trip.fromJSON(t)).toList();
  }

  Future<Trip> getTrip(int id) async {
    final db = await helper.database;
    final List<Map<String, Object?>> res =
        await db.query(TABLE_NAME, where: "$TRIP_ID = ?", whereArgs: [id]);
    return Trip.fromJSON(res.first);
  }

  Future addTrip(Trip t) async {
    var trip = t.toJson();
    trip[TRIP_ID] = null;
    final db = await helper.database;
    await db.insert(TABLE_NAME, trip,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future deleteTrip(int id) async {
    final db = await helper.database;
    await db.delete(TABLE_NAME, where: "$TRIP_ID = ?", whereArgs: [id]);
  }

  Future updateTrip(int id, Trip trip) async {
    final db = await helper.database;
    await db.update(TABLE_NAME, trip.toJson(),
        where: "$TRIP_ID = ?", whereArgs: [id]);
  }
}
