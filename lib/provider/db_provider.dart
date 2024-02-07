import 'package:flutter/material.dart';
import 'package:my_pa/model/response_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum TimePeriod {
  all,
  today,
  lastWeek,
  lastMonth,
}

TimePeriod selectedTimePeriod = TimePeriod.all;

class DBProvider extends ChangeNotifier {
  static Future<Database> openDb() async {
    final database = await openDatabase(
      join(
        await getDatabasesPath(),
        "responses.db",
      ),
      onCreate: (db, version) async {
        return await db.execute(
            "CREATE TABLE IF NOT EXISTS responses(id TEXT, content TEXT, date TEXT, question TEXT)");
      },
      version: 1,
    );
    return database;
  }

  addResponse(Response response) async {
    final db = await openDb();
    await db.insert(
      "responses",
      response.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  editResponse(String id, String content) async {
    final db = await openDb();
    await db.update(
      "responses",
      {
        "content": content,
      },
      where: "id=?",
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  deleteResponse(String id) async {
    final db = await openDb();
    await db.delete(
      "responses",
      where: "id = ?",
      whereArgs: [id],
    );

    notifyListeners();
  }

  deleteAllResponses() async {
    final db = await openDb();
    await db.delete("responses");
    notifyListeners();
  }

  removeContent(String content) async {
    final db = await openDb();
    await db.delete(
      "responses",
      where: "content = ?",
      whereArgs: [content],
    );

    notifyListeners();
  }

  Future<bool> checkResponse(String content) async {
    final db = await openDb();
    final list = await db.query(
      "responses",
      where: "content = ?",
      whereArgs: [content],
    );
    notifyListeners();

    return list.isNotEmpty;
  }

  // Future<bool> searchResponse(TimePeriod selectedTimePeriod) async {
  //   final db = await openDb();
  //   DateTime startDate;
  //   DateTime now = DateTime.now();
  //   bool hasResponse;
  //   if (selectedTimePeriod != TimePeriod.all) {
  //     List<Map<String, dynamic>> list = await db.query(
  //       "responses",
  //     );
  //     hasResponse = list.isNotEmpty;
  //   } else {
  //     if (selectedTimePeriod == TimePeriod.today) {
  //       startDate = DateTime(now.year, now.month, now.day);
  //     } else if (selectedTimePeriod == TimePeriod.lastWeek) {
  //       startDate = now.subtract(const Duration(days: 7));
  //     } else if (selectedTimePeriod == TimePeriod.lastMonth) {
  //       startDate = DateTime(now.year, now.month - 1, now.day);
  //     }
  //     List<Map<String, dynamic>> list = await db.query(
  //       "responses",
  //       where: "date >= ?",
  //       whereArgs: [startDate],
  //     );
  //     hasResponse = list.isNotEmpty;
  //   }

  //   notifyListeners();
  //   return hasResponse;
  // }

  Future<int> countResponses() async {
    final db = await openDb();
    final List<Map<String, dynamic>> count = await db.query(
      "responses",
    );
    notifyListeners();

    return count.length;
  }

  Future<List<Response>> responsesListDesc() async {
    final db = await openDb();

    final List<Map<String, dynamic>> responses =
        await db.query("responses", orderBy: "date DSC");
    return List.generate(responses.length, (index) {
      return Response(
          id: responses[index]["id"],
          content: responses[index]["content"],
          date: responses[index]["date"],
          question: responses[index]["question"]);
    });
  }

  Future<List<Response>> responsesList() async {
    final db = await openDb();

    final List<Map<String, dynamic>> responses =
        await db.query("responses", orderBy: "date ASC");
    return List.generate(responses.length, (index) {
      return Response(
          id: responses[index]["id"],
          content: responses[index]["content"],
          date: responses[index]["date"],
          question: responses[index]["question"]);
    });
  }
}
