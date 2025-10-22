/*
==============================================================
TaskItem Widget:
- Displays a single task row with checkbox, name, priority, and delete button.
==============================================================
*/

import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final void Function(String) onPriorityChange;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onPriorityChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.name,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: DropdownButton<String>(
          value: task.priority,
          items: const [
            DropdownMenuItem(value: 'High', child: Text('High Priority')),
            DropdownMenuItem(value: 'Medium', child: Text('Medium Priority')),
            DropdownMenuItem(value: 'Low', child: Text('Low Priority')),
          ],
          onChanged: (v) => onPriorityChange(v!),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
