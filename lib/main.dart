import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tt_10_artur/data/homework.dart';
import 'package:tt_10_artur/data/lesson.dart';
import 'package:tt_10_artur/data/note.dart';
import 'package:tt_10_artur/data/note_homework.dart';
import 'package:tt_10_artur/data/task.dart';
import 'package:tt_10_artur/domain/config.dart';
import 'package:tt_10_artur/onboarding/onboarding_page.dart';

void main() async {
  await _initApplication();

  runApp(const MainApp());
}

Future<void> _initApplication() async {
  final bindings = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: bindings);

  await Config.instance.init();
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
      home: OnboardingScreen(),
    );
  }
}

void initHandler() {
  WidgetsBinding.instance.addObserver(
    AppLifecycleListener(onDetach: Config.instance.closeClient),
  );
}
