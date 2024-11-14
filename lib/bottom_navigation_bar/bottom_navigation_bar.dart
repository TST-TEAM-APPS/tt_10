import 'package:flutter/material.dart';
import 'package:all_day_lesson_planner/classes_view/classes_page.dart';
import 'package:all_day_lesson_planner/homework_view/homeworks_page.dart';
import 'package:all_day_lesson_planner/settings_view/settings_page.dart';

class CustomNavigationBar extends StatefulWidget {
  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = 0; // Индекс выбранной страницы

  final List<Widget> _pages = [
    ClassesPage(),
    HomeworksPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Содержимое текущей страницы
          _pages[_currentIndex],
          // Навигационная панель, расположенная внизу
          Positioned(
            bottom: 16.0, // Отступ от нижнего края
            left: 16.0, // Отступ от левого края
            right: 16.0, // Отступ от правого края
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25), // Закругленные углы
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12, // Цвет тени
                    blurRadius: 10, // Радиус размытия тени
                    offset: Offset(0, 5), // Смещение тени
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      icon: Icons.school,
                      label: 'Classes',
                      isActive: _currentIndex == 0,
                      onTap: () => _onItemTapped(0),
                    ),
                    _NavBarItem(
                      icon: Icons.book,
                      label: 'Homework',
                      isActive: _currentIndex == 1,
                      onTap: () => _onItemTapped(1),
                    ),
                    _NavBarItem(
                      icon: Icons.settings,
                      label: 'Settings',
                      isActive: _currentIndex == 2,
                      onTap: () => _onItemTapped(2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.green : Colors.grey,
            size: 28,
          ),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.green : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
