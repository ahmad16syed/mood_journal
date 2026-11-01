import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mood_journal/add_journal_screen.dart';
import 'package:mood_journal/journal_detail_screen.dart';

class JournalOverviewScreen extends StatelessWidget {
  const JournalOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA6DCEF),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFCDB4DB),
        title: const Text('My Journals'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('mood_journal').listenable(),
        builder: (context, box, _) {
          final entriesMap = box.toMap();
          final entries = entriesMap.entries.toList();
          log('Entries: $entries');

          if (entries.isEmpty) {
            return const Center(child: Text('No entries yet.'));
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final reversedEntries =
                  entries.reversed.toList(); // Reverse the list
              final date = reversedEntries[index].key;
              final entry = reversedEntries[index].value;
              return ListTile(
                title: Text(date),
                subtitle: Text(
                  '${entry['mood']} - ${entry['journal'].length > 80 ? entry['journal'].substring(0, 80) + '...' : entry['journal']}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JournalDetailScreen(
                        date: date,
                        mood: entry['mood'],
                        journal: entry['journal'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFFFFD166),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddJournalScreen(),
            ),
          ),
          label: const Text('Add New Journal'),
        ),
      ),
    );
  }
}
