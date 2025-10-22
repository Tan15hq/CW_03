/*
==============================================================
Task Model: Represents a single task item with name, completion
status, and priority level.
==============================================================
*/

class Task {
  String name;
  bool isCompleted;
  String priority;

  Task({
    required this.name,
    this.isCompleted = false,
    this.priority = 'Medium',
  });

  // Convert to Map for SharedPreferences storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'priority': priority,
    };
  }

  // Create from Map (for loading saved tasks)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['name'],
      isCompleted: map['isCompleted'],
      priority: map['priority'],
    );
  }
}
