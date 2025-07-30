import 'package:banpeittarik/Main/dashboard.dart';
import 'package:banpeittarik/Screens/about_page.dart';
import 'package:banpeittarik/Screens/alarm.dart';
import 'package:banpeittarik/Screens/holiday_list.dart';
import 'package:banpeittarik/Screens/home.dart';
import 'package:banpeittarik/Screens/notification.dart';
import 'package:banpeittarik/Screens/setting.dart';
import 'package:banpeittarik/Widget/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ban Peit Tarik',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/splash',
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/splash': (context) => const SplashScreen(),
        '/alarm': (context) => const AlarmScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/about': (context) => const AboutScreen(),
        '/holiday-list': (context) => const HolidaysList(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
