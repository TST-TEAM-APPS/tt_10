import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../data/homework.dart';
import 'add_homework_page.dart';
import 'open_homework_page.dart';
import 'package:tt_10_artur/styles/text_styles.dart';
import 'package:tt_10_artur/widgets/display_gradient_button.dart';

class HomeworksPage extends StatefulWidget {
  const HomeworksPage({Key? key}) : super(key: key);

  @override
  _HomeworksPageState createState() => _HomeworksPageState();
}

class _HomeworksPageState extends State<HomeworksPage> {
  late Box<Homework> homeworkBox;
  String _selectedStatus = 'All Homeworks';

  @override
  void initState() {
    super.initState();
    homeworkBox =
        Hive.box<Homework>('homeworks'); // Ensure the box name matches
  }

  List<Homework> _getFilteredHomeworks() {
    if (_selectedStatus == 'All Homeworks') {
      return homeworkBox.values.toList();
    } else {
      return homeworkBox.values
          .where((hw) => hw.status == _selectedStatus)
          .toList();
    }
  }

  List<Widget> _buildStatusFilters() {
    List<String> statuses = [
      'All Homeworks',
      'Planned',
      'In Work',
      'Finished',
    ];

    return statuses.map((status) {
      bool isSelected = _selectedStatus == status;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ChoiceChip(
          side: const BorderSide(style: BorderStyle.none),
          showCheckmark: false,
          label: Text(status),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedStatus = status;
            });
          },
          selectedColor: Colors.green,
          backgroundColor: Colors.grey[200],
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      );
    }).toList();
  }

  void _navigateToAddHomework() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddHomeworkPage(),
      ),
    );
    setState(() {}); // Refresh the state upon return
  }

  void _navigateToOpenHomework(Homework hw) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OpenHomeworkPage(homework: hw),
      ),
    );
  }

  void _navigateToEditHomework(Homework hw) {
    // Implement navigation to edit homework page if exists
    // For example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EditHomeworkPage(homework: hw),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    List<Homework> homeworks = _getFilteredHomeworks();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: Text(
                'Homeworks',
                style: AppTextStyles.displayLargeBold.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 1),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Status Filters
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: _buildStatusFilters(),
              ),
            ),
            const SizedBox(height: 16),
            // Homework List or Empty Message
            Expanded(
              child: homeworks.isNotEmpty
                  ? ListView.builder(
                      itemCount: homeworks.length,
                      itemBuilder: (context, index) {
                        final hw = homeworks[index];
                        return HomeworkCard(
                          homework: hw,
                          onTap: () => _navigateToOpenHomework(hw),
                          onEdit: () => _navigateToEditHomework(hw),
                        );
                      },
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'You have no homeworks added',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ),
            ),
            // Add Homework Button
            DisplayGradientButton(
              onPressed: _navigateToAddHomework,
              text: Text(
                'Add Homework',
                style:
                    AppTextStyles.bodyLargeMedium.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class HomeworkCard extends StatelessWidget {
  final Homework homework;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const HomeworkCard({
    Key? key,
    required this.homework,
    required this.onTap,
    required this.onEdit,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return Colors.blueAccent;
      case 'in work':
        return Colors.orangeAccent;
      case 'finished':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(homework.dueDate);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(
                72, 80, 100, 0.08), // Light background color
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Homework Title and Edit Button
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.school),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            homework.topic,
                            style: AppTextStyles.bodyLargeMedium.copyWith(
                              color: const Color.fromRGBO(72, 80, 100, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Homework Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        homework.status,
                        style: TextStyle(
                          color: _getStatusColor(homework.status),
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: onEdit,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Homework Description and Date
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white, // White background color
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Homework Description
                    Text(
                      homework.description.length > 100
                          ? '${homework.description.substring(0, 100)}...'
                          : homework.description,
                      style: AppTextStyles.labelLargeMedium.copyWith(
                        color: const Color.fromRGBO(72, 80, 100, 0.4),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Homework Date
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: AppTextStyles.labelLargeMedium.copyWith(
                            color: const Color.fromRGBO(72, 80, 100, 0.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
