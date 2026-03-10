class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String status;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.status = 'Pending',
    required this.createdAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> data, String id) {
    return TaskModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      status: data['status'] ?? (data['isCompleted'] == true ? 'Completed' : 'Pending'),
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    String? status,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
