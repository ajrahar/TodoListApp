class Todo {
  final int? id; // id sekarang bisa null dan di-set oleh database secara otomatis
  final String title;
  final String description;
  final bool completed;

  Todo({
    this.id, // id sebagai null awalnya
    required this.title,
    required this.description,
    this.completed = false, // default to false jika tidak diberikan
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0, // completed sebagai integer (0/1)
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['_id'], // ambil nilai id dari peta
      title: map['title'],
      description: map['description'],
      completed: map['completed'] == 1, // konversi dari integer ke boolean
    );
  }
}
