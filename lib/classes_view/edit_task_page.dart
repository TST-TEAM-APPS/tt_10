import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tt_10_artur/data/task.dart';
import 'package:tt_10_artur/styles/text_styles.dart';
import 'package:tt_10_artur/widgets/display_gradient_button.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _taskDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _taskDate = widget.task.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        widget.task.title = _titleController.text;
        widget.task.description = _descriptionController.text;
        widget.task.date = _taskDate;

        await widget.task.save();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Задача успешно обновлена')),
        );

        Navigator.pop(context);
      } catch (e) {
        // Показать сообщение об ошибке
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при сохранении задачи: $e')),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _taskDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030, 12, 31),
    );
    if (pickedDate != null && pickedDate != _taskDate) {
      setState(() {
        _taskDate = pickedDate;
      });
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить задачу'),
        content: const Text('Вы уверены, что хотите удалить эту задачу?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await widget.task.delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Задача успешно удалена')),
                );
                Navigator.pop(context); // Выход из EditTaskPage
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка при удалении задачи: $e')),
                );
              }
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskDateFormatted = DateFormat.yMMMd().format(_taskDate);

    // Определяем общий стиль для полей ввода
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor:
          const Color.fromRGBO(72, 80, 100, 0.08), // Цвет фона полей ввода
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide.none, // Убираем границы
      ),
      // Опционально можно добавить иконки или другие параметры
    );

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Edit task',
                  style: AppTextStyles.displayLargeBold.copyWith(
                    color: const Color.fromRGBO(72, 80, 100, 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Заголовок задачи
              Text(
                'Заголовок задачи',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: inputDecoration.copyWith(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите заголовок задачи';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Описание задачи
              Text(
                'Описание задачи',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: inputDecoration.copyWith(),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите описание задачи';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Дата задачи
              Text(
                'Дата задачи',
                style: AppTextStyles.labelLargeMedium.copyWith(
                  color: const Color.fromRGBO(72, 80, 100, 0.4),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
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
                        offset: const Offset(0, 3), // Изменение позиции тени
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                        taskDateFormatted,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Кнопка сохранения
              DisplayGradientButton(
                onPressed: _saveTask,
                text: Text(
                  'Сохранить изменения',
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
