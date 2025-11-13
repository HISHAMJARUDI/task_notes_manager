
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_item.dart';  // Import your TaskItem model
import '../services/database_helper.dart';  // Import your DatabaseHelper

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;  // Default to light mode

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Toggle theme and save to SharedPreferences
  Future<void> _toggleTheme(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newValue);
    setState(() {
      _isDarkMode = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Notes Manager',
      theme: ThemeData.light(),  // Light theme
      darkTheme: ThemeData.dark(),  // Dark theme
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final Future<void> Function(bool) onThemeToggle;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks & Notes'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Tasks & Notes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (bool value) => onThemeToggle(value),
          ),
          Expanded(
            child: FutureBuilder<List<TaskItem>>(
              future: DatabaseHelper().getAllTasks(),  // Dynamically fetch from SQFLite
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tasks yet. Add one!'));
                } else {
                  final tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Priority: ${task.priority}'),
                            Text('Description: ${task.description}'),
                            if (task.isCompleted) const Text('Completed', style: TextStyle(color: Colors.green)),
                          ],
                        ),
                        trailing: task.isCompleted
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Screen2()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPriority = 'Medium';  // Default priority
  bool _isCompleted = false;

  // Priority options
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Generate simple ID (using timestamp for uniqueness)
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final id = _generateId();
      final task = TaskItem(
        id: id,
        title: _titleController.text,
        priority: _selectedPriority,
        description: _descriptionController.text,
        isCompleted: _isCompleted,
      );

      // Insert into SQFLite database
      await DatabaseHelper().insertTask(task);

      // Clear form and pop back to HomeScreen (list auto-refreshes via FutureBuilder)
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedPriority = 'Medium';
        _isCompleted = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Task/Note'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => value!.isEmpty ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedPriority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: _priorities.map((priority) {
                      return DropdownMenuItem(value: priority, child: Text(priority));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedPriority = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _isCompleted,
                        onChanged: (value) => setState(() => _isCompleted = value!),
                      ),
                      const Text('Completed'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,  // Now inserts to database
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
            ),
        );
    }
}