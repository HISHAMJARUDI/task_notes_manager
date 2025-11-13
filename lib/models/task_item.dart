class TaskItem {
  final String id;
  final String title;
  final String priority;
  final String description;
  final bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.priority,
    required this.description,
    this.isCompleted = false,  // Default to false if not provided
  });


  // Method to convert to JSON map
  Map<String, dynamic> toJson() {
    return {
    'id': id,
    'title': title,
    'priority': priority,
    'description': description,
    'isCompleted': isCompleted,
    };
  }


  // Factory constructor to create from JSON
  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: json['priority'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}