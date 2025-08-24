import 'package:collective/components/weekly_goals.dart';
import 'package:flutter/material.dart';

class WeeklyGoalsButton extends StatelessWidget {
  const WeeklyGoalsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.checklist_rounded, size: 24, color: Colors.white),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Text(
              'Show Weekly Goals',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => WeeklyGoals(),
            );
          },
        ),
      ),
    );
  }
}
