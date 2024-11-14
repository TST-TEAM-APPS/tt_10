import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tt_10_artur/data/lesson.dart';
import 'package:tt_10_artur/data/note.dart';
import 'package:tt_10_artur/styles/text_styles.dart';
import 'package:tt_10_artur/widgets/display_gradient_button.dart';

class AddNotePage extends StatefulWidget {
  final Lesson lesson;

  const AddNotePage({Key? key, required this.lesson}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      try {
        final note = Note(
          content: _contentController.text,
          date: widget.lesson.date,
          lessonKey: widget.lesson.key as int, // Hive assigns integer keys
        );

        final noteBox = Hive.box<Note>('notes');
        await noteBox.add(note);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note added successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving note: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonDateFormatted = DateFormat.yMMMd().format(widget.lesson.date);

    // Define a common style for input fields
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(
          72, 80, 100, 0.08), // Background color for input fields
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide.none, // Remove borders
      ),
      // Optionally, you can add icons or other parameters
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Page Title
              Center(
                child: Text(
                  'Add Note',
                  style: AppTextStyles.displayLargeBold.copyWith(
                    color: const Color.fromRGBO(72, 80, 100, 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Note Content
              Text(
                'Note Content',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                decoration: inputDecoration.copyWith(),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter note content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Lesson Date
              Text(
                'Lesson Date',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  // Optional: Implement date picker if needed
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(72, 80, 100, 0.08),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                        lessonDateFormatted,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Save Button
              DisplayGradientButton(
                onPressed: _saveNote,
                text: Text(
                  'Save Note',
                  style: AppTextStyles.bodyLargeMedium
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
