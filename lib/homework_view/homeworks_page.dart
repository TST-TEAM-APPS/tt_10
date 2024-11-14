import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:tt_10_artur/homework_view/edit_homework_page.dart';
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
        Hive.box<Homework>('homeworks'); // Убедитесь, что имя бокса совпадает
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
    setState(() {}); // Обновляем состояние при возврате
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHomeworkPage(homework: hw),
      ),
    ).then((_) {
      setState(() {}); // Обновляем состояние после редактирования
    });
  }

  void _deleteHomework(Homework hw) async {
    // Подтверждение удаления (опционально)
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Homework'),
        content: const Text('Are you sure'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await hw.delete(); // Удаляем из Hive
      setState(() {}); // Обновляем состояние
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Succesfully deleted')),
      );
    }
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
            const SizedBox(height: 20),
            // Фильтры статусов
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: _buildStatusFilters(),
              ),
            ),
            const SizedBox(height: 16),
            // Список домашних заданий или сообщение об отсутствии
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
                          onDelete: () =>
                              _deleteHomework(hw), // Передаём callback удаления
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
            // Кнопка добавления домашнего задания
            DisplayGradientButton(
              onPressed: _navigateToAddHomework,
              text: Text(
                'Add Homework',
                style:
                    AppTextStyles.bodyLargeMedium.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 100),
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
  final VoidCallback onDelete; // Добавляем callback для удаления

  const HomeworkCard({
    Key? key,
    required this.homework,
    required this.onTap,
    required this.onEdit,
    required this.onDelete, // Обязательный параметр
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
            color: const Color.fromRGBO(72, 80, 100, 0.08), // Светлый фон
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок домашнего задания и меню
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.school),
                          const SizedBox(width: 10),
                          Text(
                            homework.topic,
                            style: AppTextStyles.bodyLargeMedium.copyWith(
                              color: const Color.fromRGBO(72, 80, 100, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Статус домашнего задания
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
                    // Выпадающее меню

                    PullDownButton(
                        itemBuilder: (context) => [
                              PullDownMenuItem(onTap: onEdit, title: 'Edit'),
                              PullDownMenuItem(onTap: onDelete, title: 'Delete')
                            ],
                        buttonBuilder: (context, showMenu) => CupertinoButton(
                              onPressed: showMenu,
                              padding: EdgeInsets.zero,
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black,
                              ),
                            ))
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Описание и дата домашнего задания
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Белый фон
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Описание домашнего задания
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
                    // Дата домашнего задания
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
