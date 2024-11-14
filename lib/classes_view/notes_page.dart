import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:all_day_lesson_planner/data/lesson.dart';
import 'package:all_day_lesson_planner/data/note.dart';
import 'package:all_day_lesson_planner/styles/text_styles.dart';
import 'package:all_day_lesson_planner/widgets/display_gradient_button.dart';
import 'add_note_page.dart';

class NotesPage extends StatefulWidget {
  final Lesson lesson;

  const NotesPage({Key? key, required this.lesson}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late Box<Note> noteBox;

  @override
  void initState() {
    super.initState();
    noteBox = Hive.box<Note>('notes');
  }

  List<Note> _getNotesForLesson() {
    return noteBox.values
        .where((note) => note.lessonKey == widget.lesson.key)
        .toList();
  }

  void _deleteNote(Note note) async {
    await note.delete();
    setState(() {});
  }

  void _navigateToAddNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNotePage(lesson: widget.lesson),
      ),
    );
    setState(() {}); // Refresh notes after adding a new one
  }

  void _confirmDelete(Note note) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              _deleteNote(note); // Delete the note
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Note> notes = _getNotesForLesson();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        iconTheme: IconThemeData(color: Colors.green),
        title: Center(
          child: Column(
            children: [
              Text(
                widget.lesson.name,
                style: AppTextStyles.bodyLargeMedium
                    .copyWith(color: const Color.fromRGBO(72, 80, 100, 1)),
              ),
              Text(
                'Notes',
                style: AppTextStyles.labelLargeMedium
                    .copyWith(color: Color.fromRGBO(72, 80, 100, 0.4)),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: notes.isNotEmpty
                ? ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(72, 80, 100, 0.08),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.content,
                                      style: AppTextStyles.bodyLargeMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${DateFormat.yMMMd().format(note.date)}',
                                          style: AppTextStyles.labelLargeMedium
                                              .copyWith(
                                                  color: Color.fromRGBO(
                                                      72, 80, 100, 0.4)),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: IconButton(
                                        onPressed: () {
                                          _deleteNote(note);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/d045979ceb1da9e8086d567f746c56c6.png',
                          width: 98,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'You have no notes added',
                          style: AppTextStyles.bodyLargeMedium,
                        ),
                      ],
                    ),
                  ),
          ),
          // Add Note Button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DisplayGradientButton(
              onPressed: _navigateToAddNote,
              text: Text(
                'Add Note',
                style:
                    AppTextStyles.bodyLargeMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
