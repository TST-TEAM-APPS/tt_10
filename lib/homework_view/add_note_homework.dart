import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../data/note_homework.dart';
import '../styles/text_styles.dart';
import '../widgets/display_gradient_button.dart';

class AddNoteHomeworkPage extends StatefulWidget {
  final int homeworkKey; // Ключ домашнего задания

  const AddNoteHomeworkPage({
    Key? key,
    required this.homeworkKey,
  }) : super(key: key);

  @override
  _AddNoteHomeworkPageState createState() => _AddNoteHomeworkPageState();
}

class _AddNoteHomeworkPageState extends State<AddNoteHomeworkPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  late Box<NoteHomework> noteHomeworkBox;

  @override
  void initState() {
    super.initState();
    noteHomeworkBox = Hive.box<NoteHomework>('notes_homework');
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newNoteHomework = NoteHomework(
        title: _titleController.text,
        content: _contentController.text,
        homeworkKey: widget.homeworkKey,
        date: _selectedDate, // Include the selected date
      );

      noteHomeworkBox.add(newNoteHomework);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note added successfully')),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030, 12, 31),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    // Unified InputDecoration similar to other pages
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.blue[50],
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      // Additional parameters can be added here
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLargeMedium.copyWith(
            color: Color.fromRGBO(72, 80, 100, 0.4),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: inputDecoration.copyWith(),
          maxLines: maxLines,
          validator: validator,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Note',
              style: AppTextStyles.displayLargeBold.copyWith(
                color: const Color.fromRGBO(72, 80, 100, 1),
              ),
            ),
            Text(
              'Homework Notes',
              style: AppTextStyles.labelLargeMedium.copyWith(
                color: const Color.fromRGBO(72, 80, 100, 0.4),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              _buildInputField(
                label: 'Title',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),

              // Content Field
              _buildInputField(
                label: 'Content',
                controller: _contentController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),

              // Date Picker
              Text(
                'Date',
                style: AppTextStyles.labelLargeMedium
                    .copyWith(color: Color.fromRGBO(72, 80, 100, 0.4)),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(72, 80, 100, 0.08),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat.yMMMd().format(_selectedDate),
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
                  'Save',
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
