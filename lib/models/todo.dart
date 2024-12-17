class Todo {
  int? id;
  String title;
  String description;
  bool completed;
  String? date;
  String? time;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.completed,
    this.date,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
      'date': date,
      'time': time,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['_id'],
      title: map['title'],
      description: map['description'],
      completed: map['completed'] == 1,
      date: map['date'],
      time: map['time'],
    );
  }
}
