import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart'; // Import PullDownButton
import 'package:tt_10_artur/data/homework.dart';
import 'package:tt_10_artur/styles/text_styles.dart';
import 'package:tt_10_artur/widgets/display_gradient_button.dart';

class EditHomeworkPage extends StatefulWidget {
  final Homework homework;

  const EditHomeworkPage({Key? key, required this.homework}) : super(key: key);

  @override
  _EditHomeworkPageState createState() => _EditHomeworkPageState();
}

class _EditHomeworkPageState extends State<EditHomeworkPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _topicController;
  late TextEditingController _descriptionController;
  String? _selectedStatus;
  String? _selectedSubject;
  DateTime _dueDate = DateTime.now();

  // Define the list of subjects
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

  // Define the list of statuses
  final List<String> _statuses = ['Planned', 'In work', 'Finished'];

  @override
  void initState() {
    super.initState();
    _selectedSubject = widget.homework.subject;
    _topicController = TextEditingController(text: widget.homework.topic);
    _descriptionController =
        TextEditingController(text: widget.homework.description);
    _selectedStatus = widget.homework.status;
    _dueDate = widget.homework.dueDate;
  }

  @override
  void dispose() {
    _topicController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveHomework() async {
    if (_formKey.currentState!.validate()) {
      try {
        widget.homework.subject = _selectedSubject!;
        widget.homework.topic = _topicController.text;
        widget.homework.description = _descriptionController.text;
        widget.homework.status = _selectedStatus!;
        widget.homework.dueDate = _dueDate;

        await widget.homework.save();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Homework updated successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating homework: $e')),
        );
      }
    }
  }

  Future<void> _pickDueDate() async {
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

  // Define a common InputDecoration
  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(72, 80, 100, 0.08),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide.none,
      ),
      hintText: hintText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dueDateFormatted = DateFormat.yMMMd().format(_dueDate);

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
                  'Edit Homework',
                  style: AppTextStyles.displayLargeBold.copyWith(
                    color: const Color.fromRGBO(72, 80, 100, 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 1. Topic
              Text(
                'Topic',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _topicController,
                decoration: _inputDecoration(hintText: 'Enter topic'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the topic';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 2. Description
              Text(
                'Description',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration(hintText: 'Enter description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 3. Subject Selection using PullDownButton
              Text(
                'Subject',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
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
              // 4. Due Date
              Text(
                'Due Date',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDueDate,
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
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                        dueDateFormatted,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Status Dropdown
              Text(
                'Status',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              PullDownButton(
                itemBuilder: (context) => _statuses.map((status) {
                  return PullDownMenuItem(
                    title: status,
                    onTap: () {
                      setState(() {
                        _selectedStatus = status;
                      });
                    },
                  );
                }).toList(),
                buttonBuilder: (context, showMenu) => CupertinoButton(
                  onPressed: showMenu,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(28, 72, 80, 100),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      _selectedStatus!,
                      style: AppTextStyles.bodyLargeMedium.copyWith(
                        color: const Color.fromARGB(255, 49, 55, 68),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Save Button
              DisplayGradientButton(
                onPressed: _saveHomework,
                text: Text(
                  'Save Changes',
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
