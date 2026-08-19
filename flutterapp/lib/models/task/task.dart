enum Priority { low, medium, high }

extension PriorityX on Priority {
  String get value => name.toUpperCase();

  static Priority fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'high':
        return Priority.high;
      case 'low':
        return Priority.low;
      case 'medium':
      default:
        return Priority.medium;
    }
  }
}

class Task {
  final int? id;
  final String title;
  final String? description;
  final Priority priority;
  final String? category;
  final DateTime createdAt;
  final DateTime? deadline;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.description,
    this.priority = Priority.medium,
    this.category,
    required this.createdAt,
    this.deadline,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      priority: PriorityX.fromString(json['priority']),
      category: json['category'],
      createdAt: json['createAt'] != null
          ? DateTime.parse(json['createAt'])
          : DateTime.now(),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'priority': priority.value,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    Priority? priority,
    String? category,
    DateTime? createdAt,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
