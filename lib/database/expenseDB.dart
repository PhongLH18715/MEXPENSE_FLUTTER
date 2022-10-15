// ignore_for_file: constant_identifier_names, file_names

import 'package:mexpense/constants.dart';
import 'package:mexpense/model/expense.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDB {
  static const TABLE_NAME = "expense";

  static final ExpenseDB helper = ExpenseDB._init();

  static Database? _database;

  ExpenseDB._init();

  Future<Database> get database async =>
      _database ??= await getDatabase("flutter.db");

  Future<Database> getDatabase(String path) async {
    String databasePath = await getDatabasesPath();
    return await openDatabase(join(databasePath, path),
        onCreate: ((db, version) async {
      return await db.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_NAME ( $EXPENSE_ID INTEGER PRIMARY KEY AUTOINCREMENT, $EXPENSE_NAME TEXT, $EXPENSE_DATE TEXT, $EXPENSE_COST INTEGER, $EXPENSE_AMOUNT INTEGER, $EXPENSE_NOTES TEXT, $EXPENSE_TRIP_ID, FOREIGN KEY($EXPENSE_TRIP_ID) REFERENCES trip($TRIP_ID) ON DELETE CASCADE )");
    }), version: 1);
  }

  Future closeDB() async {
    final db = await helper.database;
    db.close();
  }

  Future<List<Expense>> getExpenses(int trip_id) async {
    final db = await helper.database;
    final List<Map<String, Object?>> expenses = await db.query(TABLE_NAME, whereArgs:[trip_id], where:  "$EXPENSE_TRIP_ID = ?");
    return expenses.map((e) => Expense.fromJSON(e)).toList();
  }

  Future<Expense> getExpense(int id) async {
    final db = await helper.database;
    final List<Map<String, Object?>> res =
        await db.query(TABLE_NAME, where: "$EXPENSE_ID = ?", whereArgs: [id]);
    return Expense.fromJSON(res.first);
  }

  Future addExpense(Expense e) async {
    var expense = e.toJson();
    expense[EXPENSE_ID] = null;
    final db = await helper.database;
    await db.insert(TABLE_NAME, expense,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future deleteExpense(int id) async {
    final db = await helper.database;
    await db.delete(TABLE_NAME, where: "$EXPENSE_ID = ?", whereArgs: [id]);
  }

  Future updateExpense(int id, Expense e) async {
    final db = await helper.database;
    await db.update(TABLE_NAME, e.toJson(),
        where: "$EXPENSE_ID = ?", whereArgs: [id]);
  }
}
