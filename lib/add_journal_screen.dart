import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({super.key});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  String? selectedMood;
  String? journalText;
  final _moodJournal = Hive.box('mood_journal');

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
          ),
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

  void submitEntry() async {
    if (selectedMood == null || journalText == null || journalText!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a mood and write a journal entry')),
      );
      return;
    }

    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final entry = {'mood': selectedMood, 'journal': journalText};
    if (_moodJournal.containsKey(dateKey)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already added an entry for today')),
      );
      Navigator.of(context).pop();
      return;
    }
    try {
      await _moodJournal.put(dateKey, entry);
      log('Mood: $selectedMood, Journal: $journalText');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Mood Journal entry submitted successfully!')),
      );
      setState(() {
        selectedMood = null;
        journalText = null;
      });
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood Journal entry submission failed!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA6DCEF),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFCDB4DB),
        title: const Text('Mood Journal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Hi! How are you feeling today?',
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
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                child: TextField(
                  maxLines: 10,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: "Write about your day...",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  onChanged: (value) {
                    setState(() {
                      journalText = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: submitEntry,
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
                      'Submit',
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
      ),
    );
  }
}
