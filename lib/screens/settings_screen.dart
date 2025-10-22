/*
==============================================================
SettingsScreen:
- Allows the user to toggle between Light, Dark, and System theme.
- Fixed onChanged type to accept nullable ThemeMode? values.
==============================================================
*/

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const route = '/settings';
  final ThemeMode themeMode;
  final void Function(ThemeMode) onChangeTheme;

  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onChangeTheme,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.themeMode;
  }

  // ✅ Accept nullable ThemeMode (ThemeMode?) from RadioListTile
  void _apply(ThemeMode? mode) {
    if (mode == null) return; // guard against null
    setState(() => _mode = mode);
    widget.onChangeTheme(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light Theme'),
              value: ThemeMode.light,
              groupValue: _mode,
              onChanged: _apply,
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark Theme'),
              value: ThemeMode.dark,
              groupValue: _mode,
              onChanged: _apply,
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: _mode,
              onChanged: _apply,
            ),
          ],
        ),
      ),
    );
  }
}
