import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/components/weekly_goals.dart';
import 'package:collective/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WeeklyGoalsButton extends StatelessWidget {
  const WeeklyGoalsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('weekly_goal_submissions')
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .where('week', isEqualTo: getCurrentWeekNumber())
              .where('complete', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            final isComplete = snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isNotEmpty;
            return ElevatedButton.icon(
              icon: Icon(
                isComplete ? Icons.verified_rounded : Icons.checklist_rounded,
                size: 24,
                color: Colors.white,
              ),
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
                backgroundColor:
                    isComplete ? Colors.green : Theme.of(context).primaryColor,
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
            );
          },
        ),
      ),
    );
  }
}
