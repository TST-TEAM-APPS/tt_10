import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:tt_10_artur/data/lesson.dart';
import 'package:tt_10_artur/styles/text_styles.dart';
import 'package:tt_10_artur/widgets/display_gradient_button.dart';

class EditLessonPage extends StatefulWidget {
  final Lesson lesson;

  const EditLessonPage({Key? key, required this.lesson}) : super(key: key);

  @override
  State<EditLessonPage> createState() => _EditLessonPageState();
}

class _EditLessonPageState extends State<EditLessonPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _roomController;
  late String _selectedSubject;
  late int _duration;
  late DateTime _selectedDate;

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
    _nameController = TextEditingController(text: widget.lesson.name);
    _roomController = TextEditingController(text: widget.lesson.room);
    _selectedSubject = widget.lesson.subject;
    _duration = widget.lesson.duration;
    _selectedDate = widget.lesson.date;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _saveLesson() async {
    if (_formKey.currentState!.validate()) {
      try {
        widget.lesson.name = _nameController.text;
        widget.lesson.subject = _selectedSubject;
        widget.lesson.room = _roomController.text;
        widget.lesson.duration = _duration;
        widget.lesson.date = _selectedDate;

        await widget.lesson.save();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lesson updated successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        // Показать сообщение об ошибке
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving lesson: $e')),
        );
      }
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
                children: List<Widget>.generate(11, (int index) {
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

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lesson'),
        content: const Text('Are you sure you want to delete this lesson?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await widget.lesson.delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lesson deleted successfully')),
                );
                Navigator.pop(context); // Exit the EditLessonPage
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting lesson: $e')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Определяем общий стиль для полей ввода
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor:
          const Color.fromRGBO(72, 80, 100, 0.08), // Цвет фона полей ввода
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide.none, // Убираем границы
      ),
      // Опционально можно добавить иконки или другие параметры
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
            tooltip: 'Delete Lesson',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Edit Class',
                  style: AppTextStyles.displayLargeBold.copyWith(
                    color: const Color.fromRGBO(72, 80, 100, 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                  color: Colors.white, // Цвет фона
                  borderRadius:
                      BorderRadius.circular(16.0), // Закругленные края
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Изменение позиции тени
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Room
              Text(
                'Cabinet Number',
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
              // Date и Duration в одной строке
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
