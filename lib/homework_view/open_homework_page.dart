import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:tt_10_artur/homework_view/add_note_homework.dart';
import 'package:tt_10_artur/homework_view/edit_homework_page.dart'; // Import the EditHomeworkPage
import 'package:tt_10_artur/styles/text_styles.dart';
import '../data/homework.dart';
import '../data/note_homework.dart';
import 'package:tt_10_artur/widgets/display_gradient_button.dart';

class OpenHomeworkPage extends StatefulWidget {
  final Homework homework;

  const OpenHomeworkPage({Key? key, required this.homework}) : super(key: key);

  @override
  _OpenHomeworkPageState createState() => _OpenHomeworkPageState();
}

class _OpenHomeworkPageState extends State<OpenHomeworkPage> {
  String? _selectedStatus;
  late Box<NoteHomework> noteHomeworkBox;

  // Список статусов
  final List<String> _statuses = ['Planned', 'In Progress', 'Finished'];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.homework.status;
    noteHomeworkBox = Hive.box<NoteHomework>('notes_homework');
  }

  void _updateStatus(String? newStatus) {
    if (newStatus != null) {
      setState(() {
        _selectedStatus = newStatus;
        widget.homework.status = newStatus;
        widget.homework.save();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $newStatus')),
      );
    }
  }

  void _navigateToAddNoteHomework() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoteHomeworkPage(
          homeworkKey: widget.homework.key as int,
        ),
      ),
    );
    // Refresh notes after adding a new one
    setState(() {});
  }

  void _navigateToEditHomework() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHomeworkPage(
          homework: widget.homework,
        ),
      ),
    );
    // Refresh homework details after editing
    setState(() {});
  }

  void _deleteNoteHomework(NoteHomework note) async {
    await note.delete();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Note deleted successfully')),
    );
  }

  void _confirmDelete(NoteHomework note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              _deleteNoteHomework(note); // Delete the note
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(NoteHomework note) {
    final noteDate = note.date ?? DateTime.now(); // Assign default date if null

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(72, 80, 100, 0.08),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Note Content
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Text(
                note.content,
                style: AppTextStyles.bodyLargeMedium,
              ),
            ),
            // Note Metadata and Actions
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Note Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat.yMMMd().format(noteDate),
                        style: AppTextStyles.labelLargeMedium.copyWith(
                          color: const Color.fromRGBO(72, 80, 100, 0.4),
                        ),
                      ),
                    ],
                  ),
                  // Delete Button
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () => _confirmDelete(note),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesList(List<NoteHomework> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return _buildNoteCard(note);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/d045979ceb1da9e8086d567f746c56c6.png',
            width: 98,
          ),
          const SizedBox(height: 30),
          Text(
            'You have no notes added',
            style: AppTextStyles.bodyLargeMedium,
          ),
        ],
      ),
    );
  }

  // Новый виджет для выбора статуса
  Widget _buildStatusSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Отображение выбранного статуса
          Text(
            'Status: $_selectedStatus',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          // PullDownButton для выбора статуса
          PullDownButton(
            itemBuilder: (context) => _statuses.map((status) {
              return PullDownMenuItem(
                title: status,
                onTap: () {
                  _updateStatus(status);
                },
              );
            }).toList(),
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      'Select ',
                      style: AppTextStyles.bodyLargeMedium
                          .copyWith(color: Colors.white),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve notes associated with this homework
    List<NoteHomework> notes = noteHomeworkBox.values
        .where((note) => note.homeworkKey == widget.homework.key)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.homework.topic,
              style: AppTextStyles.displayLargeBold.copyWith(
                color: const Color.fromRGBO(72, 80, 100, 1),
              ),
            ),
            Text(
              'Homework Details',
              style: AppTextStyles.labelLargeMedium.copyWith(
                color: const Color.fromRGBO(72, 80, 100, 0.4),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _navigateToEditHomework, // Navigate to EditHomeworkPage
            child: const Text(
              'Edit',
              style: TextStyle(color: Color.fromRGBO(65, 192, 114, 1)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Homework Details Card
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject
                    Row(
                      children: [
                        Icon(Icons.school, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          widget.homework.subject,
                          style: AppTextStyles.labelLargeMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Topic
                    Text(
                      widget.homework.topic,
                      style: AppTextStyles.displaySmallBold.copyWith(
                        color: const Color.fromRGBO(72, 80, 100, 1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(),
                    const SizedBox(height: 8),
                    // Due Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.yMMMd().format(widget.homework.dueDate),
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // **Замененный виджет выбора статуса**
            _buildStatusSelector(),
            const SizedBox(height: 16),
            // Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(72, 80, 100, 0.08),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SingleChildScrollView(
                child: Text(
                  widget.homework.description,
                  style: AppTextStyles.bodyLargeMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Notes Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: AppTextStyles.labelLargeMedium.copyWith(
                      color: const Color.fromRGBO(72, 80, 100, 0.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: notes.isNotEmpty
                        ? _buildNotesList(notes)
                        : _buildEmptyState(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Add Note Button
            DisplayGradientButton(
              onPressed: _navigateToAddNoteHomework,
              text: Text(
                'Add Note',
                style: AppTextStyles.bodyLargeMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
