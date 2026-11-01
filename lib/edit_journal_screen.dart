import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditJournalScreen extends StatefulWidget {
  final String date;
  final String mood;
  final String journal;

  const EditJournalScreen({
    required this.date,
    required this.mood,
    required this.journal,
    super.key,
  });

  @override
  State<EditJournalScreen> createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends State<EditJournalScreen> {
  String? selectedMood;
  late TextEditingController journalController;
  final _moodJournal = Hive.box('mood_journal');

  @override
  void initState() {
    super.initState();
    selectedMood = widget.mood; // Initialize mood with existing value
    journalController =
        TextEditingController(text: widget.journal); // Set journal text
  }

  @override
  void dispose() {
    journalController.dispose();
    super.dispose();
  }

  Widget _buildMoodButton(String mood, String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
        });
      },
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(
              color: selectedMood == mood ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 8),
              Text(
                mood,
                style: TextStyle(
                  fontSize: 16,
                  color: selectedMood == mood ? Colors.blue : Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void submitEditedEntry() async {
    if (selectedMood == null || journalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a mood and write a journal entry')),
      );
      return;
    }

    try {
      final updatedEntry = {
        'mood': selectedMood,
        'journal': journalController.text
      };

      await _moodJournal.put(
          widget.date, updatedEntry); // Update the existing entry

      log('Updated Mood: $selectedMood, Updated Journal: ${journalController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journal entry updated successfully!')),
      );

      Navigator.of(context).pop(); // Close the screen after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update journal entry!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA6DCEF),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFCDB4DB),
        title: const Text('Edit Journal Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Edit Your Mood Journal Entry',
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildMoodButton('Happiness', '😊'),
                _buildMoodButton('Sadness', '😢'),
                _buildMoodButton('Anger', '😠'),
                _buildMoodButton('Disgust', '🤢'),
                _buildMoodButton('Fear', '😨'),
                _buildMoodButton('Surprise', '😲'),
              ],
            ),
            const SizedBox(height: 16),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                controller: journalController,
                maxLines: 10,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: "Write about your day...",
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: submitEditedEntry,
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
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
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
