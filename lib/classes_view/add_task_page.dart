import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:all_day_lesson_planner/data/lesson.dart';
import 'package:all_day_lesson_planner/data/task.dart';
import 'package:all_day_lesson_planner/styles/text_styles.dart';
import 'package:all_day_lesson_planner/widgets/display_gradient_button.dart';

class AddTaskPage extends StatefulWidget {
  final Lesson lesson;

  const AddTaskPage({Key? key, required this.lesson}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _taskDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Initialize task date with lesson date
    _taskDate = widget.lesson.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _taskDate,
        lessonKey: widget.lesson.key as int,
      );

      final taskBox = Hive.box<Task>('tasks');
      await taskBox.add(task);

      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    // Allow user to pick a date using CupertinoDatePicker
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _taskDate,
                minimumDate: DateTime(2020),
                maximumDate: DateTime(2030, 12, 31),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _taskDate = newDate;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lessonDateFormatted = DateFormat.yMMMd().format(_taskDate);

    // Define a common style for input fields
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(
          72, 80, 100, 0.08), // Background color for input fields
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide.none, // Remove borders
      ),
      // Optionally, you can add icons or other parameters
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Add Task',
                  style: AppTextStyles.displayLargeBold.copyWith(
                    color: const Color.fromRGBO(72, 80, 100, 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Task Title
              Text(
                'Task Title',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: inputDecoration.copyWith(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Task Description
              Text(
                'Task Description',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: inputDecoration.copyWith(),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the task description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Lesson Date
              Text(
                'Lesson Date',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(72, 80, 100, 0.08),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                        lessonDateFormatted,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Save Task Button
              DisplayGradientButton(
                onPressed: _saveTask,
                text: Text(
                  'Save Task',
                  style: AppTextStyles.bodyLargeMedium
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
