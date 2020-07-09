import 'dart:convert';

import 'package:first_team_project/core/models/subtask.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database _db;
  static const TABLE = "Tasks";
  static const DB_NAME = "task_storage.db";
  static const ID = "id";
  static const TITLE = "title";
  static const DESCRIPTION = "description";
  static const FROM = "from_";
  static const TO = "to_";
  static const SUBTASKS = "subtasks";
  static const TOTALSUBTASKS = "total_subtasks";
  static const SUBTASKCOMPLETED = "subtask_completed";
  static const TASKCOLOR = "task_color";
  static const ISCOMPLETED = "is_completed";
  static const ISFAILED = "is_failed";
  static const COMPLETIONTIME = "completion_time";

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = openDatabase(path, version: 5, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database database, int version) async {
    await database.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $TITLE STRING, $DESCRIPTION STRING, $FROM STRING, $TO STRING, $SUBTASKS STRING, $TOTALSUBTASKS INTEGER, $SUBTASKCOMPLETED INTEGER, $TASKCOLOR STRING, $ISCOMPLETED INTEGER, $ISFAILED INTEGER, $COMPLETIONTIME STRING)");
  }

  Future<void> insertTask(Task task) async {
    var dbClient = await db;
    await dbClient.insert(TABLE, task.toJson());
  }

  Future<void> updateTask(Task task) async {
    var dbClient = await db;
    await dbClient.update(TABLE, task.toJson(),
        where: '$ID = ?',
        whereArgs: [task.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTask(Task task) async {
    var dbClient = await db;
    await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [task.id]);
  }

  Future<List<Task>> fetchAllTasks() async {
    var dbClient = await db;
    final map = await dbClient.query(TABLE, columns: null);
    List<Task> tasks = List();
    for (final task in map) {
      final taskobj = Task.fromJson(task);
      tasks.add(taskobj);
    }
    return tasks;
  }
}
