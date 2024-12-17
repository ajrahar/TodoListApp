import 'package:aplikasi_todo_list/models/todo.dart';
import 'package:aplikasi_todo_list/pages/add_todo_page.dart';
import 'package:aplikasi_todo_list/pages/auth/login_page.dart';
import 'package:aplikasi_todo_list/pages/auth/register_page.dart';
import 'package:aplikasi_todo_list/pages/edit_todo_page.dart';
import 'package:aplikasi_todo_list/pages/landing_page.dart';
import 'package:aplikasi_todo_list/pages/profile_page.dart';
import 'package:aplikasi_todo_list/pages/splash_screen.dart';
import 'package:aplikasi_todo_list/pages/todo_list_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App with SQLite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splashscreen', // Halaman awal adalah login
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/todoList': (context) => TodoListPage(),
        '/splashscreen': (context) => SplashScreen(),
        '/addTodo': (context) => AddTodoPage(),
        '/editTodo': (context) => EditTodoPage(todo: ModalRoute.of(context)!.settings.arguments as Todo),
        '/profile': (context) => ProfilePage(),
        '/landing': (context) => MainMenuPage(),
      },
    );
  }
}
