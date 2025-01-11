import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:course_project/login_screen.dart';
import 'package:course_project/signup_screen.dart';
import 'home_screen.dart';
import 'mainScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Arka planda gelen bildirimleri işleyin
  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> requestPermission() async {
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User  granted permission');
  } else {
    print('User  declined or has not accepted permission');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Bildirim izinlerini ve ayarlarını başlat
  await requestPermission();
  await initializeNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GrowthTrack",
      theme: ThemeData(primarySwatch: Colors.indigo, primaryColor: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => _auth.currentUser  != null ? MainScreen() : LoginScreen(),
        '/signup': (context) => SignupScreen(), // Kayıt ekranı
        '/home': (context) => HomeScreen(), // Ana ekran
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginScreen()); // Bilinmeyen rota için varsayılan sayfa
      },
    );
  }
}