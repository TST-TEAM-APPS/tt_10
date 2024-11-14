import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  String content;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  int lessonKey; // Reference to the Lesson

  Note({
    required this.content,
    required this.date,
    required this.lessonKey,
  });
}
