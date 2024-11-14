import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tt_10_artur/classes_view/add_task_page.dart';
import 'package:tt_10_artur/classes_view/edit_lesson_page.dart';
import 'package:tt_10_artur/data/lesson.dart';
import 'package:tt_10_artur/data/task.dart';
import 'package:tt_10_artur/styles/text_styles.dart';
import 'package:tt_10_artur/widgets/display_gradient_button.dart';
import 'notes_page.dart';
import 'edit_task_page.dart';

class OpenClassPage extends StatefulWidget {
  final Lesson lesson;

  const OpenClassPage({Key? key, required this.lesson}) : super(key: key);

  @override
  _OpenClassPageState createState() => _OpenClassPageState();
}

class _OpenClassPageState extends State<OpenClassPage> {
  late Box<Task> taskBox;
  late Lesson lesson;

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Task>('tasks');
    lesson = widget.lesson;
  }

  List<Task> _getTasksForLesson() {
    return taskBox.values
        .where((task) => task.lessonKey == lesson.key)
        .toList();
  }

  void _navigateToAddTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(lesson: lesson),
      ),
    );
    setState(() {});
  }

  void _navigateToEditTask(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskPage(task: task),
      ),
    );
    setState(() {});
  }

  void _navigateToEditLesson() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLessonPage(lesson: lesson),
      ),
    );
    setState(() {
      lesson = Hive.box<Lesson>('lessons').get(lesson.key)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = _getTasksForLesson();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        iconTheme: IconThemeData(color: Colors.green),
        title: Center(
          child: Column(
            children: [
              Text(
                'Class Chedule',
                style: AppTextStyles.bodyLargeMedium
                    .copyWith(color: const Color.fromRGBO(72, 80, 100, 1)),
              ),
              Text(
                lesson.name,
                style: AppTextStyles.labelLargeMedium
                    .copyWith(color: Color.fromRGBO(72, 80, 100, 0.4)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _navigateToEditLesson,
            child: const Text(
              'Edit',
              style: TextStyle(color: Color.fromRGBO(65, 192, 114, 1)),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson Card
          Card(
            color: Colors.white,
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        lesson.subject,
                        style: AppTextStyles.labelLargeMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lesson.name,
                    style: AppTextStyles.displaySmallBold
                        .copyWith(color: Color.fromRGBO(72, 80, 100, 1)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Cabinet: ',
                          style: TextStyle(color: Colors.grey[700])),
                      Text(
                        '${lesson.room}',
                        style: AppTextStyles.labelLargeMedium,
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text('${lesson.duration} min',
                          style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(width: 16),
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text(DateFormat.yMMMd().format(lesson.date),
                          style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Notes Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/d045979ceb1da9e8086d567f746c56c6.png',
                  width: 24,
                ),
                title: const Text(
                  'Notes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesPage(lesson: lesson),
                    ),
                  );
                },
              ),
            ),
          ),

          // Tasks Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tasks',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]),
            ),
          ),
          Expanded(
            child: tasks.isNotEmpty
                ? ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(
                                72, 80, 100, 0.08), // Light background color
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        task.title,
                                        style: AppTextStyles.bodyLargeMedium
                                            .copyWith(
                                                color: Color.fromRGBO(
                                                    72, 80, 100, 1)),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () =>
                                          _navigateToEditTask(task),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 255,
                                      255), // Light background color
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.description,
                                      style: AppTextStyles.labelLargeMedium
                                          .copyWith(
                                              color: Color.fromRGBO(
                                                  72, 80, 100, 0.4)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormat.yMMMd().format(task.date),
                                          style: AppTextStyles.labelLargeMedium
                                              .copyWith(
                                                  color: Color.fromRGBO(
                                                      72, 80, 100, 0.4)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/2e0882ee6de44923ddf3eab3fd327f78.png',
                            width: 100,
                          ),
                          Text(
                            'You have no tasks added',
                            style: AppTextStyles.bodyLargeMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),

          // Add Task Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: DisplayGradientButton(
                onPressed: _navigateToAddTask,
                text: Text(
                  'Add task',
                  style: AppTextStyles.bodyLargeMedium
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
