import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle displayLargeBold = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 40 / 32, // This is the line height
  );

  static const TextStyle displayLargeMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 40 / 32, // This is the line height
  );

  static const TextStyle displayMediumBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 32 / 24,
  );

  static const TextStyle displaySmallBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 28 / 20,
  );

  static const TextStyle displaySmallSemibold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600, // Semibold
    height: 24 / 18,
  );

  static const TextStyle bodyLargeSemibold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600, // Semibold
    height: 22 / 16,
  );

  static const TextStyle bodyLargeMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    height: 22 / 16,
  );

  static const TextStyle bodyLargeRegular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal, // Regular
    height: 22 / 16,
  );

  static const TextStyle labelLargeMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    height: 20 / 14,
  );

  static const TextStyle labelSmallMedium = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500, // Medium
    height: 14 / 10,
  );
}
