import 'package:hive/hive.dart';

part 'lesson.g.dart';

@HiveType(typeId: 0)
class Lesson extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String subject;

  @HiveField(2)
  String room;

  @HiveField(3)
  int duration; // in minutes

  @HiveField(4)
  DateTime date;

  Lesson({
    required this.name,
    required this.subject,
    required this.room,
    required this.duration,
    required this.date,
  });
}
