import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:all_day_lesson_planner/data/lesson.dart';
import 'package:all_day_lesson_planner/styles/text_styles.dart';
import 'package:all_day_lesson_planner/widgets/display_gradient_button.dart';

class AddLessonPage extends StatefulWidget {
  final DateTime initialDate;

  const AddLessonPage({Key? key, required this.initialDate}) : super(key: key);

  @override
  State<AddLessonPage> createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  String _selectedSubject = 'Mathematics';
  final _roomController = TextEditingController();
  int _duration = 60;
  DateTime _selectedDate = DateTime.now();

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
    _selectedDate = widget.initialDate;
  }

  void _saveLesson() async {
    if (_formKey.currentState!.validate()) {
      final lesson = Lesson(
        name: _nameController.text,
        subject: _selectedSubject,
        room: _roomController.text,
        duration: _duration,
        date: _selectedDate,
      );

      final lessonBox = Hive.box<Lesson>('lessons');
      await lessonBox.add(lesson);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    super.dispose();
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
                initialDateTime: _selectedDate,
                minimumDate: DateTime(2020),
                maximumDate: DateTime(2030, 12, 31),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
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

  Future<void> _pickDuration() async {
    int tempDuration = _duration;
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: CupertinoPicker(
                backgroundColor:
                    CupertinoColors.systemBackground.resolveFrom(context),
                itemExtent: 32.0,
                scrollController: FixedExtentScrollController(
                    initialItem: (tempDuration - 15) ~/ 15),
                onSelectedItemChanged: (int index) {
                  tempDuration = 15 + index * 15;
                },
                children: List<Widget>.generate(12, (int index) {
                  int value = 15 + index * 15;
                  return Center(child: Text('$value mins'));
                }),
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () {
                setState(() {
                  _duration = tempDuration;
                });
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  'Add Class',
                  style: AppTextStyles.displayLargeBold.copyWith(
                    color: const Color.fromRGBO(72, 80, 100, 1),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Lesson Name
              Text(
                'Class Topic',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: inputDecoration.copyWith(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter lesson name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Subject
              Text(
                'Academic Subject',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedSubject,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
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
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Room Number
              Text(
                'Room Number',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _roomController,
                decoration: inputDecoration.copyWith(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter room number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Date and Duration in one row
              Row(
                children: [
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
                                  DateFormat.yMMMd().format(_selectedDate),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDuration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration',
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
                                const Icon(Icons.timer),
                                const SizedBox(width: 8),
                                Text(
                                  '$_duration mins',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Save Button
              DisplayGradientButton(
                onPressed: _saveLesson,
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
