import 'package:hive/hive.dart';

part 'homework.g.dart';

@HiveType(typeId: 3)
class Homework extends HiveObject {
  @HiveField(0)
  String topic;

  @HiveField(1)
  String description;

  @HiveField(2)
  String subject;

  @HiveField(3)
  DateTime dueDate;

  @HiveField(4)
  String status; // 'Planned', 'In work', 'Finished'

  Homework({
    required this.topic,
    required this.description,
    required this.subject,
    required this.dueDate,
    this.status = 'Planned',
  });
}
