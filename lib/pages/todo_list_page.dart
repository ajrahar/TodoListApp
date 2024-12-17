import 'package:aplikasi_todo_list/helpers/database_helper.dart';
import 'package:aplikasi_todo_list/models/todo.dart';
import 'package:aplikasi_todo_list/pages/edit_todo_page.dart';
import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Todo> _todos = [];

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
    final newTodo = Todo(
      id: 0,
      title: "New Todo",
      description: "Description",
      completed: false,
    );
    await _dbHelper.insert(newTodo);
    _refreshTodoList();
  }

  void _editTodo(Todo todo) async {
    final updatedTodo = Todo(
      id: todo.id,
      title: "Updated Title",
      description: "Updated Description",
      completed: todo.completed,
    );
    await _dbHelper.update(updatedTodo);
    _refreshTodoList();
  }

  void _deleteTodo(int id) async {
    await _dbHelper.delete(id);
    _refreshTodoList();
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
        ],
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.description),
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
    );
  }
}
