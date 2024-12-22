import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int buttonIndex = 0; // Pending ve Completed sekmelerinin kontrolü için
  int selectedIndex = 0; // BottomNavigationBar kontrolü için
  final widgets = [
    Container(
      child: Center(child: Text("Pending Tasks")),
    ),
    Container(
      child: Center(child: Text("Completed Tasks")),
    ),
  ];

  // Alt menü simgelerine karşılık gelen ekranlar
  final List<Widget> _pages = [
    Center(child: Text("Home Page")),
    Center(child: Text("Calendar Page")),
    Center(child: Text("Add Task")),
    Center(child: Text("Task List Page")),
    Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {
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
      body: selectedIndex == 0 // Home için içerik gösterimi
          ? Padding(
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
                    '15 tasks',
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
                            value: 0.3,
                            backgroundColor: Colors.white30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        '30%',
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
            widgets[buttonIndex],

            // Task List
            Expanded(
              child: ListView(
                children: [
                  TaskItem(title: 'Task1', time: '09:00-12:00'),
                  TaskItem(title: 'Task2', time: '09:00-12:00'),
                  TaskItem(title: 'Task3', time: '09:00-13:00'),
                ],
              ),
            ),
          ],
        ),
      )
          : _pages[selectedIndex], // Diğer ekranlar için içerik gösterimi
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
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

class TaskItem extends StatelessWidget {
  final String title;
  final String time;

  TaskItem({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: Colors.black),
        title: Text(title),
        subtitle: Text(time),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
