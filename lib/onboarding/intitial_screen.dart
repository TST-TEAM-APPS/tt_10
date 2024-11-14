import 'dart:async';
import 'package:all_day_lesson_planner/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:all_day_lesson_planner/onboarding/onboarding_page.dart';
import 'package:all_day_lesson_planner/settings_view/privacy_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:all_day_lesson_planner/domain/config.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final _config = Config.instance;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigate(context));

  Future<void> _navigate(BuildContext context) async {
    bool isFirstTime = await IsFirstRun.isFirstRun();
    if (isFirstTime) {
      InAppReview.instance.requestReview();
    }
    if (_config.usePrivacy) {
      if (isFirstTime) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            ),
          );
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomNavigationBar(),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PrivacyPage(),
          ),
        );
      }
    }

    if (mounted) {
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
