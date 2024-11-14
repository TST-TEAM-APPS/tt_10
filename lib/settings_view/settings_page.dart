import 'package:all_day_lesson_planner/domain/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _config = Config.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About the program',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                  children: [
                    _buildSettingsCard(
                        icon: Icons.lock,
                        label: 'Privacy Policy',
                        onTap: () => launchUrlString(_config.privacyLink)),
                    _buildSettingsCard(
                      icon: Icons.description,
                      label: 'Terms of Use',
                      onTap: () => launchUrlString(_config.termsLink),
                    ),
                    _buildSettingsCard(
                      icon: Icons.rate_review,
                      label: 'Rate us',
                      onTap: () async =>
                          await InAppReview.instance.requestReview(),
                    ),
                    _buildSettingsCard(
                      icon: Icons.feedback,
                      label: 'Feedback',
                      onTap: () async => await FlutterEmailSender.send(
                        Email(
                          recipients: ['iqbalbachi255@gmail.com'], 
                          body: 'You can write your message here...', 
                          subject: "Message to \"All Day: Lesson Planner\" support"
                        ),
                      ),
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

  Widget _buildSettingsCard(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      minSize: 1,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
