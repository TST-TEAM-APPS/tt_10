import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tt_10_artur/data/lesson.dart';
import 'package:tt_10_artur/styles/text_styles.dart';
import 'package:tt_10_artur/widgets/display_gradient_button.dart';
import 'package:tt_10_artur/widgets/non_activity_widget.dart';
import 'add_lesson_page.dart';
import 'open_class_page.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({Key? key}) : super(key: key);

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final _controller = EasyInfiniteDateTimelineController();
  DateTime _selectedDate = DateTime.now();

  final DateTime _firstDate = DateTime(2020);
  final DateTime _lastDate = DateTime(2030, 12, 31);

  late Box<Lesson> lessonBox;

  String? _selectedSubject; // null означает 'Все' предметы

  @override
  void initState() {
    super.initState();
    lessonBox = Hive.box<Lesson>('lessons');
  }

  void _changeWeek(int increment) {
    setState(() {
      DateTime newDate = _selectedDate.add(Duration(days: increment * 7));

      // Убедимся, что новая дата в допустимом диапазоне
      if (newDate.isBefore(_firstDate)) {
        newDate = _firstDate;
      } else if (newDate.isAfter(_lastDate)) {
        newDate = _lastDate;
      }

      _selectedDate = newDate;
      _controller.jumpToDate(_selectedDate);
    });
  }

  void _navigateToAddLesson() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLessonPage(
          initialDate: _selectedDate,
        ),
      ),
    );
    setState(() {}); // Обновляем состояние при возврате
  }

  List<Lesson> _getLessonsForSelectedDate() {
    return lessonBox.values
        .where((lesson) =>
            DateUtils.isSameDay(lesson.date, _selectedDate) &&
            (_selectedSubject == null || lesson.subject == _selectedSubject))
        .toList();
  }

  List<String> _getSubjects() {
    final lessons = lessonBox.values.toList();
    final subjects = lessons.map((lesson) => lesson.subject).toSet().toList();
    subjects.sort();
    return subjects;
  }

  List<Widget> _buildSubjectFilters() {
    List<Widget> filters = [];

    // Фильтр 'Все'
    filters.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ChoiceChip(
          showCheckmark: false,
          side: const BorderSide(style: BorderStyle.none),
          label: const Text('Все'),
          selected: _selectedSubject == null,
          onSelected: (selected) {
            setState(() {
              _selectedSubject = null;
            });
          },
          selectedColor: Colors.green,
          backgroundColor: Colors.grey[200],
          labelStyle: TextStyle(
            color: _selectedSubject == null ? Colors.white : Colors.black,
          ),
        ),
      ),
    );

    final subjects = _getSubjects();

    for (var subject in subjects) {
      bool isSelected = _selectedSubject == subject;
      filters.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            showCheckmark: false,
            side: const BorderSide(style: BorderStyle.none),
            label: Text(subject),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedSubject = selected ? subject : null;
              });
            },
            selectedColor: Colors.green,
            backgroundColor: Colors.grey[200],
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }

    return filters;
  }

  @override
  Widget build(BuildContext context) {
    final monthText = DateFormat('LLLL', 'en_US').format(_selectedDate);
    const textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    List<Lesson> lessons = _getLessonsForSelectedDate();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                'Class chedule',
                style: AppTextStyles.displayLargeBold.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 1),
                ),
              ),
            ),
            // Заголовок с навигацией по неделям
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Color.fromARGB(255, 14, 173, 0)),
                    onPressed: () => _changeWeek(-1),
                  ),
                  Text(monthText,
                      style: textStyle.copyWith(
                          color: const Color.fromARGB(255, 0, 128, 64))),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        color: Color.fromARGB(255, 20, 122, 0)),
                    onPressed: () => _changeWeek(1),
                  ),
                ],
              ),
            ),
            EasyInfiniteDateTimeLine(
              showTimelineHeader: false,
              controller: _controller,
              firstDate: _firstDate,
              focusDate: _selectedDate,
              lastDate: _lastDate,
              onDateChange: (selectedDate) {
                setState(() {
                  _selectedDate = selectedDate;
                });
              },
              dayProps: EasyDayProps(
                width: 50,
                height: 60,
                dayStructure: DayStructure.dayNumDayStr,
                activeDayNumStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                inactiveDayNumStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                activeDayStrStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                inactiveDayStrStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
                activeDayDecoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                inactiveDayDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            // Фильтры по предметам
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: _buildSubjectFilters(),
              ),
            ),
            const SizedBox(height: 16),
            // Отображение уроков или сообщение "Нет уроков"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Your classes',
                    style: AppTextStyles.displaySmallSemibold,
                  )
                ],
              ),
            ),
            Expanded(
              child: lessons.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        childAspectRatio:
                            1, // Уменьшили для увеличения высоты карточки
                      ),
                      itemCount: lessons.length,
                      itemBuilder: (context, index) {
                        final lesson = lessons[index];
                        return GestureDetector(
                          onTap: () {
                            // Переход на страницу открытого урока
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OpenClassPage(lesson: lesson),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                color: Colors.yellow.shade600,
                                width: 2,
                              ),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Subject and Icon Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.school,
                                          color: Colors.black),
                                      const Icon(Icons.more_vert,
                                          color: Colors.grey),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      lesson.subject,
                                      style: TextStyle(
                                        color: Colors.yellow.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Lesson Name
                                  Text(
                                    lesson.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  // Cabinet Information
                                  Text(
                                    'Cabinet: ${lesson.room}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  // Time and Date Row
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${lesson.duration} min',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat('dd MMM yyyy', 'en_US')
                                            .format(lesson.date),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: NoActivityWidget(),
                    ),
            ),
            // Кнопка "Добавить урок"
            DisplayGradientButton(
              onPressed: _navigateToAddLesson,
              text: Text(
                'Add class',
                style: AppTextStyles.displayLargeMedium
                    .copyWith(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
