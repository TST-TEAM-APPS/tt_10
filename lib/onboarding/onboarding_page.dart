import 'package:flutter/material.dart';
import 'package:tt_10_artur/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:tt_10_artur/widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pageData = [
    {
      'title': 'Class schedule',
      'subtitle':
          'Create a class schedule and record all homework assignments in one place',
      'imagePath': 'assets/images/e74be46d534071609c1de3e41e2605af.png',
      'buttonText': 'Next',
    },
    {
      'title': 'Class notes',
      'subtitle':
          "Write down important points right in class so you don't miss anything.",
      'imagePath': 'assets/images/d045979ceb1da9e8086d567f746c56c6.png',
      'buttonText': 'Next',
    },
    {
      'title': 'Start planning your studies',
      'subtitle': 'Get started by adding your first schedule or assignment!',
      'imagePath': 'assets/images/36ddc955628fb01dd98fa45fad51d9e5.png',
      'buttonText': 'Get started',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pageData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final page = _pageData[index];
                return OnboardingPage(
                  title: page['title']!,
                  subtitle: page['subtitle']!,
                  imagePath: page['imagePath']!,
                  buttonText: page['buttonText']!,
                  currentIndex: _currentIndex,
                  totalPageCount: _pageData.length,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 70.0),
        child: GradientButton(
          text: _currentIndex == _pageData.length - 1 ? "Get started" : "Next",
          onPressed: () {
            if (_currentIndex < _pageData.length - 1) {
              _controller.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomNavigationBar()));
            }
          },
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String buttonText;
  final int currentIndex;
  final int totalPageCount;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.buttonText,
    required this.currentIndex,
    required this.totalPageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(flex: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 72, 80, 100),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 20),
          // Верхний индикатор страниц
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              totalPageCount,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 7,
                width: index == currentIndex ? 37 : 24,
                decoration: BoxDecoration(
                  color:
                      index == currentIndex ? Colors.green : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          SizedBox(height: 90),
          Center(
            child: Image.asset(
              imagePath,
              height: 200,
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}
