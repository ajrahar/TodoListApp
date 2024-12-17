import 'package:aplikasi_todo_list/helpers/database_helper.dart';
import 'package:aplikasi_todo_list/models/todo.dart';
import 'package:aplikasi_todo_list/pages/edit_todo_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import untuk menangani format tanggal

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Todo> _todos = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshTodoList();
  }

  void _refreshTodoList() async {
    final todos = await _dbHelper.queryAllTodos();
    setState(() {
      _todos = todos;
    });
  }

  void _addTodo() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);

    final newTodo = Todo(
      id: 0,
      title: "New Todo",
      description: "Description",
      completed: false,
      date: formattedDate,
      time: formattedTime,
    );
    await _dbHelper.insert(newTodo);
    _refreshTodoList();
  }

  void _editTodo(Todo todo) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);

    final updatedTodo = Todo(
      id: todo.id,
      title: "Updated Title",
      description: "Updated Description",
      completed: todo.completed,
      date: formattedDate,
      time: formattedTime,
    );
    await _dbHelper.update(updatedTodo);
    _refreshTodoList();
  }

  void _deleteTodo(int id) async {
    await _dbHelper.delete(id);
    _refreshTodoList();
  }

  void _logout() {
    // Implementasi logout: contoh menghapus sesi atau kembali ke halaman login
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Tambahkan aksi jika diperlukan, seperti navigasi ke halaman lain
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addTodo').then((_) => _refreshTodoList());
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todo.description),
                Text(
                  'Tanggal: ${todo.date}, Jam: ${todo.time}', // Menampilkan tanggal dan jam yang telah diformat
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditTodoPage(todo: todo)),
                    ).then((_) => _refreshTodoList());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTodo(todo.id!),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
