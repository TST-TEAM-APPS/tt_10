import 'package:flutter/material.dart';

class NoActivityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or Image placeholder
          Container(
            height: 120, // Adjust the size as needed
            width: 120, // Adjust the size as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            child: Image.asset('assets/images/knowledge_5723648.png'),
          ),
          SizedBox(height: 16), // Space between the icon and text
          Text(
            'You have no added activity',
            style: TextStyle(
              fontSize: 16, // Adjust the size as needed
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Adjust color if needed
            ),
          ),
          SizedBox(height: 8), // Space between the main text and the subtext
          Text(
            'To add an activity, tap on the "Add activity"\nbutton and it will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14, // Adjust the size as needed
              color: Colors.black54, // Lighter color for subtext
            ),
          ),
        ],
      ),
    );
  }
}
