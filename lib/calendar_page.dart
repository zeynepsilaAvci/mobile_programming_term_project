import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<String>> _events;
  late List<String> _selectedEvents;
  late DateTime _focusedDay;
  late DateTime? _selectedDay;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _fetchEvents();
    _checkForEventsAndNotify();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _fetchEvents() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('events')
        .get();

    _events = {};
    for (var doc in snapshot.docs) {
      DateTime eventDate = (doc['date'] as Timestamp).toDate();
      DateTime normalizedDate = DateTime(eventDate.year, eventDate.month, eventDate.day);
      String eventName = doc['name'];
      if (_events[normalizedDate] != null) {
        _events[normalizedDate]!.add(eventName);
      } else {
        _events[normalizedDate] = [eventName];
      }
    }

    setState(() {
      DateTime? normalizedSelectedDay = _selectedDay != null
          ? DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
          : null;
      _selectedEvents = _events[normalizedSelectedDay] ?? [];
    });

    print("Fetched events: $_events");
  }

  Future<void> _checkForEventsAndNotify() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    DateTime normalizedTomorrow = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('events')
        .where('date', isEqualTo: Timestamp.fromDate(normalizedTomorrow))
        .get();

    if (snapshot.docs.isNotEmpty) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Yarın için etkinlikleriniz var!',
        'Etkinliklerinizi kontrol etmeyi unutmayın.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;

      DateTime normalizedSelectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      _selectedEvents = _events[normalizedSelectedDay] ?? [];
    });

    print("Selected day: $_selectedDay");
    print("Selected events: $_selectedEvents");
  }

  void _addEvent() {
    if (_selectedDay == null) return;

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController eventController = TextEditingController();
        return AlertDialog(
          title: Text('Add Event'),
          content: TextField(
            controller: eventController,
            decoration: InputDecoration(hintText: 'Event Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (eventController.text.isNotEmpty) {
                  User? user = _auth.currentUser;
                  if (user != null) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('events')
                        .add({
                      'name': eventController.text,
                      'date': Timestamp.fromDate(_selectedDay!),
                    }).then((_) {
                      print("Event added!");
                      _fetchEvents(); // Veri çek ve güncelle
                    }).catchError((error) {
                      print("Error adding event: $error");
                    });
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Calendar'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addEvent,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: (day) {
              DateTime normalizedDay = DateTime(day.year, day.month, day.day);
              return _events[normalizedDay] ?? [];
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.purple.shade200,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
              defaultTextStyle: TextStyle(color: Colors.black),
              weekendTextStyle: TextStyle(color: Colors.grey),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: _selectedEvents.isNotEmpty
                        ? ListView.builder(
                      itemCount: _selectedEvents.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(_selectedEvents[index]),
                            leading: Icon(Icons.event, color: Colors.purpleAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                    )
                        : Center(
                      child: Text(
                        'No events for this day',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
