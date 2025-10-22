/*
==============================================================
TaskListScreen:
- Displays list of tasks with add, delete, complete, and priority features.
- Uses SharedPreferences for persistence.
==============================================================
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import '../widgets/task_item.dart';
import 'settings_screen.dart';

class TaskListScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) onChangeTheme;

  const TaskListScreen({
    super.key,
    required this.onChangeTheme,
    required this.themeMode,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Task> _tasks = [];
  String _selectedPriority = 'Medium';

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load saved tasks on start
  }

  // Load saved tasks from SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('tasks');
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      setState(() {
        _tasks = decoded.map((e) => Task.fromMap(Map<String, dynamic>.from(e))).toList();
      });
    }
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_tasks.map((t) => t.toMap()).toList());
    prefs.setString('tasks', encoded);
  }

  // Add a new task
  void _addTask() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _tasks.add(Task(name: name, priority: _selectedPriority));
      _sortTasks();
      _controller.clear();
    });
    _saveTasks();
  }

  // Toggle completion
  void _toggleComplete(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
    _saveTasks();
  }

  // Delete task
  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
    _saveTasks();
  }

  // Change task priority
  void _changePriority(Task task, String newPriority) {
    setState(() {
      task.priority = newPriority;
      _sortTasks();
    });
    _saveTasks();
  }

  // Sort tasks by priority
  void _sortTasks() {
    const order = {'High': 3, 'Medium': 2, 'Low': 1};
    _tasks.sort((a, b) => order[b.priority]!.compareTo(order[a.priority]!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, SettingsScreen.route),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input row with text and priority selector
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter Task Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedPriority,
                  items: const [
                    DropdownMenuItem(value: 'High', child: Text('High')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'Low', child: Text('Low')),
                  ],
                  onChanged: (v) => setState(() => _selectedPriority = v!),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text('No tasks added yet.'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return TaskItem(
                          task: task,
                          onToggle: () => _toggleComplete(task),
                          onDelete: () => _deleteTask(task),
                          onPriorityChange: (p) => _changePriority(task, p),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
