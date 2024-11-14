import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:tt_10_artur/data/homework.dart';
// Removed unused import: 'package:tt_10/data/lesson.dart';
import 'package:tt_10_artur/styles/text_styles.dart';
import 'package:tt_10_artur/widgets/display_gradient_button.dart';

class AddHomeworkPage extends StatefulWidget {
  const AddHomeworkPage({Key? key}) : super(key: key);

  @override
  _AddHomeworkPageState createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  final _formKey = GlobalKey<FormState>();

  final _topicController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedSubject = 'Mathematics';
  DateTime _dueDate = DateTime.now();

  late Box<Homework> homeworkBox;
  // Removed: late Box<Lesson> lessonBox;

  // 1. Define a Predefined List of Subjects
  final List<String> _subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'History',
    'Geography',
    'English',
    'Computer Science',
  ];

  @override
  void initState() {
    super.initState();
    homeworkBox = Hive.box<Homework>('homeworks');
    // Removed: lessonBox = Hive.box<Lesson>('lessons');
  }

  // Removed: List<String> _getSubjects() { ... }

  void _saveHomework() async {
    if (_formKey.currentState!.validate()) {
      final homework = Homework(
        topic: _topicController.text,
        description: _descriptionController.text,
        subject: _selectedSubject,
        dueDate: _dueDate,
        status: 'Planned', // Set default status
      );

      await homeworkBox.add(homework);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Homework added successfully')),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
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
                initialDateTime: _dueDate,
                minimumDate: DateTime(2020),
                maximumDate: DateTime(2030, 12, 31),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _dueDate = newDate;
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

  Future<void> _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 12, 31),
    );
    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Removed: final subjects = _getSubjects();

    // 2. Unified InputDecoration, similar to AddLessonPage
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.blue[50],
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      // Additional parameters can be added here
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Header
              Center(
                child: Text(
                  'Add Homework',
                  style: AppTextStyles.displayLargeBold
                      .copyWith(color: const Color.fromRGBO(72, 80, 100, 1)),
                ),
              ),
              const SizedBox(height: 24),

              // 1. Topic
              Text(
                'Topic',
                style: AppTextStyles.labelLargeMedium
                    .copyWith(color: Color.fromRGBO(72, 80, 100, 0.4)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _topicController,
                decoration: inputDecoration.copyWith(
                  hintText: 'Enter topic',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a topic';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Description
              Text(
                'Description',
                style: AppTextStyles.labelLargeMedium
                    .copyWith(color: Color.fromRGBO(72, 80, 100, 0.4)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: inputDecoration.copyWith(
                  hintText: 'Enter description',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Subject Selection
              Text(
                'Subject',
                style: AppTextStyles.labelLargeMedium
                    .copyWith(color: Color.fromRGBO(72, 80, 100, 0.4)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Display Selected Subject
                    Text(
                      'Subject: $_selectedSubject',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    // PullDownButton for Subject Selection
                    PullDownButton(
                      itemBuilder: (context) => _subjects.map((subject) {
                        return PullDownMenuItem(
                          title: subject,
                          onTap: () {
                            setState(() {
                              _selectedSubject = subject;
                            });
                          },
                        );
                      }).toList(),
                      buttonBuilder: (context, showMenu) => CupertinoButton(
                        onPressed: showMenu,
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Text(
                                'Select ',
                                style: AppTextStyles.bodyLargeMedium
                                    .copyWith(color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Due Date Picker
              Text(
                'Due Date',
                style: AppTextStyles.labelLargeMedium
                    .copyWith(color: Color.fromRGBO(72, 80, 100, 0.4)),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GestureDetector(
                  onTap: _pickDate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: AppTextStyles.labelLargeMedium.copyWith(
                          color: const Color.fromRGBO(72, 80, 100, 0.4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
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
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat.yMMMd().format(_dueDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              DisplayGradientButton(
                onPressed: _saveHomework,
                text: Text(
                  'Save',
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
