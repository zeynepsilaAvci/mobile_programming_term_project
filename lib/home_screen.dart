import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addtask_page.dart';
import 'calendar_page.dart';
import 'profile_page.dart';
import 'tasklist_page.dart';
import 'package:course_project/widgets/completed_widget.dart';
import 'package:course_project/widgets/pending_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int buttonIndex = 0; // Pending ve Completed sekmelerinin kontrolü için
  int pendingTasksCount = 0;
  int completedTasksCount = 0;

  final List<Widget> widgets = [
    PendingWidget(),
    CompletedWidget(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchTaskCounts();
  }

  Future<void> _fetchTaskCounts() async {
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final pendingTasks = await FirebaseFirestore.instance
          .collection('todos')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser !.uid)
          .where('completed', isEqualTo: false)
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .where('createdAt', isLessThan: endOfDay)
          .get();

      final completedTasks = await FirebaseFirestore.instance
          .collection('todos')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser !.uid)
          .where('completed', isEqualTo: true)
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .where('createdAt', isLessThan: endOfDay)
          .get();

      // mounted kontrolü ekleniyor
      if (mounted) {
        setState(() {
          pendingTasksCount = pendingTasks.docs.length;
          completedTasksCount = completedTasks.docs.length;
        });
      }
    } catch (e) {
      print("Error fetching task counts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double completionPercentage = (pendingTasksCount + completedTasksCount) > 0
        ? (completedTasksCount / (pendingTasksCount + completedTasksCount)) * 100
        : 0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(
            'Homepage',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white60,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView( // Burada SingleChildScrollView ekleniyor
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Progress Summary
              Container(
                padding: const EdgeInsets.all(50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.purpleAccent, Colors.purple.shade200],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's progress summary",
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$pendingTasksCount tasks',
                      style: const TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.directions_run, color: Colors.white),
                        const SizedBox(width: 4),
                        const Icon(Icons.task_alt_rounded, color: Colors.white),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: LinearProgressIndicator(
                              value: completionPercentage / 100,
                              backgroundColor: Colors.white30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          '${completionPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height : 16),
              // Pending ve Completed Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        buttonIndex = 0;
                      });
                    },
                    child: Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: buttonIndex == 1 ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: buttonIndex == 0
                            ? Colors.purpleAccent
                            : Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        buttonIndex = 1;
                      });
                    },
                    child: Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: buttonIndex == 0 ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: buttonIndex == 1
                            ? Colors.purpleAccent
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              widgets[buttonIndex],
            ],
          ),
        ),
      ),

    );
  }
}