import 'package:aplikasi_todo_list/models/user.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserDatabaseHelper _userDbHelper = UserDatabaseHelper.instance;

  void _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Tampilkan pesan kesalahan jika ada yang kosong
      _showErrorDialog('Please enter both username and password.');
      return;
    }

    // Cek apakah username sudah digunakan
    final existingUser = await _userDbHelper.queryUser(username, password);
    if (existingUser != null) {
      _showErrorDialog('Username already exists.');
      return;
    }

    // Daftar pengguna baru
    final newUser = User(username: username, password: password);
    await _userDbHelper.insert(newUser);

    // Redirect ke halaman LoginPage setelah registrasi berhasil
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Already have an account? Login here'),
            ),
          ],
        ),
      ),
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
