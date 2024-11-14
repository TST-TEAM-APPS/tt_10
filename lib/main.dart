import 'package:all_day_lesson_planner/onboarding/intitial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:all_day_lesson_planner/data/homework.dart';
import 'package:all_day_lesson_planner/data/lesson.dart';
import 'package:all_day_lesson_planner/data/note.dart';
import 'package:all_day_lesson_planner/data/note_homework.dart';
import 'package:all_day_lesson_planner/data/task.dart';
import 'package:all_day_lesson_planner/domain/config.dart';

void main() async {
  await _initApplication();

  runApp(const MainApp());
}

Future<void> _initApplication() async {
  final bindings = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: bindings);

  await Config.instance.init();
  initLifecycleHandler();
  await Hive.initFlutter();
  Hive.registerAdapter(LessonAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(HomeworkAdapter());
  Hive.registerAdapter(NoteHomeworkAdapter());

  await Hive.openBox<Lesson>('lessons');
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<NoteHomework>('notes_homework');
  await Hive.openBox<Homework>('homeworks');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Day: Lesson Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SFProText',
      ),
      home: const InitialScreen(),
    );
  }
}

void initLifecycleHandler() {
  WidgetsBinding.instance.addObserver(
    AppLifecycleListener(onDetach: Config.instance.closeClient),
  );
}
