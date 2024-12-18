class Todo {
  final int id;
  final String title;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: int.tryParse(json['id'].toString()) ?? 0, // Konversi ke int
      title: json['title'] ?? '',
      isCompleted: (json['is_completed'] == "1" || json['is_completed'] == 1)
          ? true
          : false, // Tangani boolean dari String atau int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted ? 1 : 0, // Ubah boolean ke int (1 atau 0)
    };
  }
}
