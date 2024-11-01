import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../sidebar.dart';
import '../database_helper.dart';
import '../models/habit.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Habit> _habits = [];
  List<ChartData> _completionData = [];
  List<ChartData> _streakData = [];

  @override
  void initState() {
    super.initState();
    _fetchHabits();
  }

  void _fetchHabits() async {
    final habits = await dbHelper.getHabits();
    setState(() {
      _habits = habits;
      _prepareChartData();
    });
  }

  void _prepareChartData() {
    // Prepare completion data
    _completionData = _habits.map((habit) {
      return ChartData(
        habit.name,
        habit.isCompleted ? 100 : 0,
      );
    }).toList();

    // Prepare streak data (for illustration purposes)
    _streakData = _habits.map((habit) {
      // Assuming we have a method to calculate streaks
      int streak = _calculateHabitStreak(habit);
      return ChartData(
        habit.name,
        streak.toDouble(),
      );
    }).toList();
  }

  int _calculateHabitStreak(Habit habit) {
    // Placeholder implementation
    // Replace this with actual logic to calculate streaks
    return habit.isCompleted ? 5 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(title: Text('Analytics')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Habit Completion Rate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildCompletionChart(),
            SizedBox(height: 20),
            Text(
              'Habit Streaks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildStreakChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionChart() {
    return _completionData.isEmpty
        ? Center(child: Text('No data to display'))
        : SfCircularChart(
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: _completionData,
          xValueMapper: (ChartData data, _) => data.habit,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildStreakChart() {
    return _streakData.isEmpty
        ? Center(child: Text('No data to display'))
        : SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<ChartData, String>(
          dataSource: _streakData,
          xValueMapper: (ChartData data, _) => data.habit,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.habit, this.value);
  final String habit;
  final double value;
}
