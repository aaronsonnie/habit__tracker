import 'package:flutter/material.dart';
import '../sidebar.dart';
import '../database_helper.dart';
import '../models/habit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Habit> _todayHabits = [];

  @override
  void initState() {
    super.initState();
    _fetchTodayHabits();
  }

  void _fetchTodayHabits() async {
    final habits = await dbHelper.getHabits();
    final today = DateTime.now();
    setState(() {
      _todayHabits = habits.where((habit) {
        final startDate = DateTime.parse(habit.startDate);
        final endDate = DateTime.parse(habit.endDate);
        return startDate.isBefore(today) && endDate.isAfter(today);
      }).toList();
    });
  }

  void _toggleCompletion(Habit habit) async {
    habit.isCompleted = !habit.isCompleted;
    await dbHelper.updateHabit(habit);
    _fetchTodayHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(title: Text('Home')),
      body: _todayHabits.isEmpty
          ? Center(child: Text('No habits for today!'))
          : ListView.builder(
        itemCount: _todayHabits.length,
        itemBuilder: (context, index) {
          final habit = _todayHabits[index];
          return ListTile(
            title: Text(habit.name),
            subtitle: Text(habit.description),
            trailing: Checkbox(
              value: habit.isCompleted,
              onChanged: (value) {
                _toggleCompletion(habit);
              },
            ),
          );
        },
      ),
    );
  }
}
