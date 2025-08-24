import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collective/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WeeklyGoals extends StatefulWidget {
  const WeeklyGoals({Key? key}) : super(key: key);

  @override
  State<WeeklyGoals> createState() => _WeeklyGoalsState();
}

class _WeeklyGoalsState extends State<WeeklyGoals> {
  checkWeeklyGoalsExist() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('weekly_goals')
        .where('week', isEqualTo: getCurrentWeekNumber())
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<List<String>> fetchWeeklyGoalOptions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('weekly_goal_options')
        .get();
    return snapshot.docs.map((doc) => doc['title'] as String).toList();
  }

  generateGoals() async {
    checkWeeklyGoalsExist().then((exists) {
      if (!exists) {
        print("No weekly goals found for the current week.");
        fetchWeeklyGoalOptions().then((options) {
          if (options.isNotEmpty) {
            List<String> selectedGoals = [];
            options.shuffle();
            selectedGoals = options.take(3).toList();

            FirebaseFirestore.instance.collection('weekly_goals').add({
              'week': getCurrentWeekNumber(),
              'goals': selectedGoals,
              'created_at': FieldValue.serverTimestamp(),
            });
          }
        });
      }
    });
  }

  createUserWeeklyGoals(String userId) async {
    await FirebaseFirestore.instance.collection('weekly_goal_submissions').add({
      'userId': userId,
      'week': getCurrentWeekNumber(),
      'goals': [false, false, false],
      'last_update': FieldValue.serverTimestamp(),
      'complete': false,
    });
  }

  syncGoalCompletion(goalIndex, isCompleted) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final submissionSnapshot = await FirebaseFirestore.instance
        .collection('weekly_goal_submissions')
        .where('userId', isEqualTo: user.uid)
        .where('week', isEqualTo: getCurrentWeekNumber())
        .get();

    if (submissionSnapshot.docs.isEmpty) {
      createUserWeeklyGoals(user.uid);
    }

    final goals = submissionSnapshot.docs.first['goals'] as List<dynamic>;
    if (submissionSnapshot.docs.isNotEmpty) {
      final docRef = submissionSnapshot.docs.first.reference;
      List<dynamic> updatedGoals = List.from(goals);
      if (goalIndex >= 0 && goalIndex < updatedGoals.length) {
        updatedGoals[goalIndex] = isCompleted;
        // Mark 'complete' as true if all goals are completed, else false
        bool isComplete = updatedGoals.every((g) => g == true);
        await docRef.update({
          'goals': updatedGoals,
          'last_update': FieldValue.serverTimestamp(),
          'complete': isComplete,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade500,
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: double.infinity,
        color: Colors.blue.shade700,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Weekly Goals',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              '(${getDateRangeOfCurrentWeek()})',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Record these as initiative contributions!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('weekly_goals')
                .where('week', isEqualTo: getCurrentWeekNumber())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Generate Goals',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      await generateGoals();
                      setState(() {});
                    });
              }
              final goals = snapshot.data!.docs.first['goals'] as List<dynamic>;
              // Use a single StreamBuilder for the user's weekly_goal_submissions to avoid flicker.
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseAuth.instance.currentUser == null
                    ? null
                    : FirebaseFirestore.instance
                        .collection('weekly_goal_submissions')
                        .where('userId',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .where('week', isEqualTo: getCurrentWeekNumber())
                        .snapshots(),
                builder: (context, submissionSnapshot) {
                  List<dynamic> userGoals = List.filled(goals.length, false);
                  bool isComplete = false;
                  if (submissionSnapshot.hasData &&
                      submissionSnapshot.data!.docs.isNotEmpty) {
                    final data = submissionSnapshot.data!.docs.first;
                    userGoals = data['goals'] as List<dynamic>;
                    isComplete = data['complete'] == true;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isComplete)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.emoji_events, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "All goals complete!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ...goals.asMap().entries.map(
                        (entry) {
                          final goalIdx = entry.key;
                          final goal = entry.value;
                          final isChecked = (goalIdx < userGoals.length)
                              ? userGoals[goalIdx] == true
                              : false;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    activeColor: Colors.white,
                                    checkColor: Colors.blue,
                                    onChanged: (val) async {
                                      await syncGoalCompletion(
                                          goalIdx, val ?? false);
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      goal.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        decoration: isChecked
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
