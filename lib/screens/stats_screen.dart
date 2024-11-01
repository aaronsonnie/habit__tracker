import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../sidebar.dart';
import '../database_helper.dart';
import '../models/habit.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Habit> _habits = [];
  List<ChartData> _chartData = [];

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
    Map<String, int> weeklyCounts = {};

    for (var habit in _habits) {
      DateTime startDate = DateTime.parse(habit.startDate);
      DateTime endDate = DateTime.parse(habit.endDate);

      DateTime current = startDate;
      while (current.isBefore(endDate.add(Duration(days: 1)))) {
        String weekLabel = 'Week ${weekNumber(current)}';
        weeklyCounts.update(
          weekLabel,
              (value) => value + 1,
          ifAbsent: () => 1,
        );
        current = current.add(Duration(days: 1));
      }
    }

    _chartData = weeklyCounts.entries
        .map((entry) => ChartData(entry.key, entry.value.toDouble()))
        .toList();
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(title: Text('Stats')),
      body: _chartData.isEmpty
          ? Center(child: Text('No data to display'))
          : SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Weekly Habit Stats'),
        legend: Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries>[
          ColumnSeries<ChartData, String>(
            dataSource: _chartData,
            xValueMapper: (ChartData data, _) => data.habit,
            yValueMapper: (ChartData data, _) => data.completionRate,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.habit, this.completionRate);
  final String habit;
  final double completionRate;
}
