import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../sidebar.dart';
import '../database_helper.dart';
import '../models/habit.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final dbHelper = DatabaseHelper.instance;
  Map<DateTime, List<Habit>> _habitEvents = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchHabits();
  }

  void _fetchHabits() async {
    final habits = await dbHelper.getHabits();
    Map<DateTime, List<Habit>> events = {};
    habits.forEach((habit) {
      DateTime startDate = DateTime.parse(habit.startDate);
      DateTime endDate = DateTime.parse(habit.endDate);
      for (DateTime date = startDate;
      date.isBefore(endDate.add(Duration(days: 1)));
      date = date.add(Duration(days: 1))) {
        events.update(
          DateTime(date.year, date.month, date.day),
              (existing) => existing..add(habit),
          ifAbsent: () => [habit],
        );
      }
    });
    setState(() {
      _habitEvents = events;
    });
  }

  List<Habit> _getHabitsForDay(DateTime day) {
    return _habitEvents[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(title: Text('Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getHabitsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          Expanded(
            child: ListView(
              children: _getHabitsForDay(_focusedDay)
                  .map((habit) => ListTile(
                title: Text(habit.name),
                subtitle: Text(habit.description),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
