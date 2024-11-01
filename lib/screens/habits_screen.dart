import 'package:flutter/material.dart';
import '../sidebar.dart';
import '../database_helper.dart';
import '../models/habit.dart';
import 'add_habit_screen.dart';

class HabitsScreen extends StatefulWidget {
  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _fetchHabits();
  }

  void _fetchHabits() async {
    final habits = await dbHelper.getHabits();
    setState(() {
      _habits = habits;
    });
  }

  void _deleteHabit(int id) async {
    await dbHelper.deleteHabit(id);
    _fetchHabits();
  }

  Future<void> _navigateToAddHabit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddHabitScreen()),
    );
    if (result == true) {
      _fetchHabits();
    }
  }

  void _toggleCompletion(Habit habit) async {
    habit.isCompleted = !habit.isCompleted;
    await dbHelper.updateHabit(habit);
    _fetchHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(title: Text('Habits')),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          return ListTile(
            title: Text(habit.name),
            subtitle: Text('From ${habit.startDate.split('T')[0]} to ${habit.endDate.split('T')[0]}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: habit.isCompleted,
                  onChanged: (value) {
                    _toggleCompletion(habit);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteHabit(habit.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHabit,
        child: Icon(Icons.add),
      ),
    );
  }
}
