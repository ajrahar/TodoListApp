import 'package:aplikasi_todo_list/helpers/database_helper.dart';
import 'package:aplikasi_todo_list/models/todo.dart';
import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  String _title = '';
  String _description = '';

  void _addTodo() async {
    if (_formKey.currentState!.validate()) {
      final newTodo = Todo(
        title: _title,
        description: _description,
        completed: false,
      );
      await _dbHelper.insert(newTodo);
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah menambahkan todo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  _title = value;
                }),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  _description = value;
                }),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTodo,
                child: Text('Add Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
