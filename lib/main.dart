/*
==============================================================
Main Entry: Runs the Task Manager App
- Handles theme switching (light/dark)
- Sets up navigation routes
==============================================================
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'screens/task_list_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  ThemeMode _themeMode = ThemeMode.system;

  // Theme switcher method
  void changeTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData.dark(),
      home: TaskListScreen(onChangeTheme: changeTheme, themeMode: _themeMode),
      routes: {
        SettingsScreen.route: (_) =>
            SettingsScreen(onChangeTheme: changeTheme, themeMode: _themeMode),
      },
    );
  }
}
