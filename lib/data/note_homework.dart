import 'package:hive/hive.dart';

part 'note_homework.g.dart';

@HiveType(typeId: 4)
class NoteHomework extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  int homeworkKey; // Ключ связанного домашнего задания

  @HiveField(3) // New field added
  DateTime? date; // Date of the note (nullable)

  NoteHomework({
    required this.title,
    required this.content,
    required this.homeworkKey,
    this.date,
  });
}
