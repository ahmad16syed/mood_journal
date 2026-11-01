import 'package:flutter/material.dart';
import 'package:mood_journal/edit_journal_screen.dart';

class JournalDetailScreen extends StatelessWidget {
  final String date;
  final String? mood;
  final String? journal;

  const JournalDetailScreen({
    super.key,
    required this.date,
    this.mood,
    this.journal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA6DCEF),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFCDB4DB),
        title: Text('Journal for $date'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mood: $mood'),
            const SizedBox(height: 8),
            Text('Journal: $journal'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditJournalScreen(
                      date: date,
                      mood: mood!,
                      journal: journal!,
                    ),
                  ),
                );
              },
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAlias,
                color: const Color(0xFFFFD166),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
