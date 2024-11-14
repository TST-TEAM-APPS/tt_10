import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  int lessonKey; // Ссылка на урок

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.lessonKey,
  });
}
