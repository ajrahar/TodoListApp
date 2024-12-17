import 'package:aplikasi_todo_list/helpers/database_helper.dart';
import 'package:aplikasi_todo_list/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTodoPage extends StatefulWidget {
  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  String _title = '';
  String _description = '';
  String? _selectedDate;
  String? _selectedTime;

  void _addTodo() async {
    if (_formKey.currentState!.validate()) {
      final formattedDate = _selectedDate != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(_selectedDate!)) : '';
      final formattedTime = _selectedTime != null ? _selectedTime! : '';

      final newTodo = Todo(
        title: _title,
        description: _description,
        completed: false,
        date: formattedDate,  // Using the formatted date
        time: formattedTime,  // Using the formatted time
      );

      await _dbHelper.insert(newTodo);
      Navigator.pop(context);
    }
  }
  
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
        title: const Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Todo Title ',
                          style: TextStyle(
                            color: Colors.blue, 
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '(Required)',
                          style: TextStyle(
                            color: Colors.red, 
                            fontSize: 14, 
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(color: Colors.grey), // Warna teks label
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1.5), // Outline saat tidak fokus
                        borderRadius: BorderRadius.circular(8.0), // Radius sudut outline
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green, width: 2.0), // Outline saat fokus
                        borderRadius: BorderRadius.circular(8.0), // Radius sudut outline
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red, width: 1.5), // Outline saat error
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red, width: 2.0), // Outline saat error dan fokus
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
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
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Description ',
                          style: TextStyle(
                            color: Colors.blue, 
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '(Required)',
                          style: TextStyle(
                            color: Colors.red, 
                            fontSize: 14, 
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(color: Colors.grey), // Warna teks label
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1.5), // Outline saat tidak fokus
                        borderRadius: BorderRadius.circular(8.0), // Radius sudut outline
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green, width: 2.0), // Outline saat fokus
                        borderRadius: BorderRadius.circular(8.0), 
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red, width: 1.5), // Outline saat error
                        borderRadius: BorderRadius.circular(8.0), 
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red, width: 2.0), // Outline saat error & fokus
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
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
                ],
              ),
              const SizedBox(height: 20),
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

              // Time Picker
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Warna background button
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Radius sudut button
                  ),
                ),
                onPressed: _addTodo,
                child: const Text(
                  'Add Todo',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
