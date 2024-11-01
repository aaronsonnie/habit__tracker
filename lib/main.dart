import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/habits_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/calendar_screen.dart';

void main() {
  runApp(HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData.dark(), // Apply dark theme
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/habits': (context) => HabitsScreen(),
        '/analytics': (context) => AnalyticsScreen(),
        '/calendar': (context) => CalendarScreen(),
      },
    );
  }
}
