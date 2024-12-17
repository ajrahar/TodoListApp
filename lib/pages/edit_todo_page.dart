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
  String? _selectedDate;
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _title = widget.todo.title;
    _description = widget.todo.description;
    _selectedDate = widget.todo.date;  // assuming 'date' is nullable in Todo
    _selectedTime = widget.todo.time;  // assuming 'time' is nullable in Todo
  }

  void _editTodo() async {
    if (_formKey.currentState!.validate()) {
      final updatedTodo = Todo(
        id: widget.todo.id,
        title: _title,
        description: _description,
        completed: widget.todo.completed,
        date: _selectedDate ?? '',
        time: _selectedTime ?? '',
      );
      await _dbHelper.update(updatedTodo);
      Navigator.pop(context); // kembali ke halaman sebelumnya setelah mengedit todo
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate;

    // Cek jika _selectedDate tidak null dan dapat di-parsing ke DateTime
    if (_selectedDate != null && _selectedDate!.isNotEmpty) {
      try {
        pickedDate = DateTime.parse(_selectedDate!);
      } catch (e) {
        // Jika gagal parse, gunakan tanggal sekarang sebagai fallback
        pickedDate = DateTime.now();
      }
    } else {
      pickedDate = DateTime.now(); // fallback ke tanggal sekarang jika tidak ada nilai
    }

    pickedDate = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Format tanggal menjadi string dalam format yang sesuai
      final formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      setState(() {
        _selectedDate = formattedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime != null
          ? TimeOfDay(
              hour: int.parse(_selectedTime!.split(':')[0]),
              minute: int.parse(_selectedTime!.split(':')[1]),
            )
          : TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime.format(context);
      });
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
              Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: Text('Pick Date'),
                  ),
                  const SizedBox(width: 10),
                  Text(_selectedDate ?? 'No date chosen'),
                ],
              ),
              const SizedBox(height: 20),
              Text('Select Time', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickTime,
                    child: Text('Pick Time'),
                  ),
                  const SizedBox(width: 10),
                  Text(_selectedTime ?? 'No time chosen'),
                ],
              ),
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
