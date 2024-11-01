import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 30));

  final dbHelper = DatabaseHelper.instance;

  void _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Habit newHabit = Habit(
        name: _name,
        description: _description,
        startDate: _startDate.toIso8601String(),
        endDate: _endDate.toIso8601String(),
        isCompleted: false,
      );
      await dbHelper.insertHabit(newHabit);
      Navigator.pop(context, true); // Return true to indicate a new habit was added
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Habit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Habit Name'),
                validator: (value) => value!.isEmpty ? 'Please enter habit name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
              ),
              ListTile(
                title: Text("Start Date: ${_startDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text("End Date: ${_endDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveHabit,
                child: Text('Save Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
