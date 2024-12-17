import 'package:aplikasi_todo_list/helpers/database_helper.dart';
import 'package:aplikasi_todo_list/models/todo.dart';
import 'package:flutter/material.dart';

class EditTodoPage extends StatefulWidget {
  final Todo todo;

  EditTodoPage({required this.todo});

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.todo.title;
    _description = widget.todo.description;
  }

  void _editTodo() async {
    if (_formKey.currentState!.validate()) {
      final updatedTodo = Todo(
        id: widget.todo.id,
        title: _title,
        description: _description,
        completed: widget.todo.completed,
      );
      await _dbHelper.update(updatedTodo);
      Navigator.pop(context); // kembali ke halaman sebelumnya setelah mengedit todo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
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
                initialValue: _description,
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
                onPressed: _editTodo,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
