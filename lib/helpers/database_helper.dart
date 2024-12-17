import 'package:aplikasi_todo_list/models/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "TodoApp.db";
  static final _databaseVersion = 1;

  static final table = 'todos';

  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnDescription = 'description';
  static final columnCompleted = 'completed';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, _databaseName),
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnCompleted INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(Todo todo) async {
    Database db = await instance.database;
    return await db.insert(table, todo.toMap());
  }

  Future<List<Todo>> queryAllTodos() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(table);
    return result.map((map) => Todo.fromMap(map)).toList();
  }

  Future<int> update(Todo todo) async {
    Database db = await instance.database;
    return await db.update(
      table,
      todo.toMap(),
      where: '$columnId = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
