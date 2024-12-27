import 'package:course_project/widgets/completed_widget.dart';
import 'package:course_project/widgets/pending_widget.dart';
import 'package:flutter/material.dart';
import 'package:course_project/profile_page.dart';
import 'package:course_project/tasklist_page.dart';
import 'package:course_project/services/database_services.dart'; // DatabaseService'i içe aktar
import 'addtask_page.dart';
import 'calendar_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int buttonIndex = 0; // Pending ve Completed sekmelerinin kontrolü için
  final DatabaseService _databaseService = DatabaseService();
  int pendingTasksCount = 0;
  int completedTasksCount = 0;

  // widgets listesini burada tanımlayın
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
    // Bugünün tarihini al
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    // Pending görev sayısını al
    final pendingTasks = await _databaseService.todoCollection
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('completed', isEqualTo: false)
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        .where('createdAt', isLessThan: endOfDay)
        .get();

    // Completed görev sayısını al
    final completedTasks = await _databaseService.todoCollection
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('completed', isEqualTo: true)
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        .where(' createdAt', isLessThan: endOfDay)
        .get();

    setState(() {
      pendingTasksCount = pendingTasks.docs.length;
      completedTasksCount = completedTasks.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    double completionPercentage = (pendingTasksCount + completedTasksCount) > 0
        ? (completedTasksCount / (pendingTasksCount + completedTasksCount)) * 100
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Homepage',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white60,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () async {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Progress Summary
            Container(
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.purple.shade200],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's progress summary",
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$pendingTasksCount tasks', // Pending task sayısı
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.directions_run, color: Colors.white),
                      SizedBox(width: 4),
                      Icon(Icons.task_alt_rounded, color: Colors.white),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                          child: LinearProgressIndicator(
                            value: completionPercentage / 100, // Yüzdeyi ayarla
                            backgroundColor: Colors.white30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        '${completionPercentage.toStringAsFixed(0)}%', // Tamamlanan görev yüzdesi
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 20),
            widgets[buttonIndex], // Burada hata olmamalı

            // Task List
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // "Home" her zaman aktif kalır.
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CalendarPage()));
              break;
            case 2:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()));
              break;
            case 3:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TaskListPage()));
              break;
            case 4:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
              break;
            default:
              break; // Home için işlem yapılmaz.
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: ' Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 40),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
