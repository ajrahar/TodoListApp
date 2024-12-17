import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  // Pabrik model pengguna dari peta
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
    );
  }
}

class UserDatabaseHelper {
  static final _databaseName = "UserDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'users';

  static final columnId = '_id'; // Column id
  static final columnUsername = 'username';
  static final columnPassword = 'password';

  UserDatabaseHelper._privateConstructor();
  static final UserDatabaseHelper instance = UserDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Rute lokasi database
    String path = await getDatabasesPath() + _databaseName;

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUsername TEXT NOT NULL,
            $columnPassword TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {},
    );
  }

  Future<int> insert(User user) async {
    Database db = await instance.database;
    return await db.insert(table, user.toMap());
  }

  Future<User?> queryUser(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: '$columnUsername = ? AND $columnPassword = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }
}
