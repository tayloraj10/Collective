import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardDialog extends StatelessWidget {
  const LeaderboardDialog({Key? key}) : super(key: key);

  getGoalSubmissionsStream() {
    final oneMonthAgo = DateTime.now().subtract(const Duration(days: 30));
    return FirebaseFirestore.instance
        .collection('goal_submissions')
        .where('userId', isNotEqualTo: null)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(oneMonthAgo))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getGoalSubmissionsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AlertDialog(
            title: Text('Leaderboard'),
            content: SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          return AlertDialog(
            title: const Text('Leaderboard'),
            content: Text('Error: ${snapshot.error}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        }
        final submissions = (snapshot.data ?? []) as List;
        if (submissions.isEmpty) {
          return AlertDialog(
            title: const Text('Leaderboard'),
            content: const Text('No submissions in the last month.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        }

        // Group by userName and count
        final Map<String, int> userCounts = {};
        for (var sub in submissions) {
          final userName = sub['userName'] ?? 'Unknown';
          userCounts[userName] = (userCounts[userName] ?? 0) + 1;
        }
        final sorted = userCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final top10 = sorted.take(10).toList();

        return AlertDialog(
          backgroundColor: const Color(0xFFFFF6EB),
          title: const Center(
            child: Text(
              'Leaderboard (Last 30 Days)',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          content: Card(
            color: const Color(0xFFE3F2FD),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(top10.length, (index) {
                    final entry = top10[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: index == top10.length - 1 ? 0 : 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${index + 1}.',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            '${entry.value}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
