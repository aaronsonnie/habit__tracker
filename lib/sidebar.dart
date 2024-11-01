import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black87, // Dark theme background
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Habit Tracker',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            _createDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            _createDrawerItem(
              icon: Icons.list,
              text: 'Habits',
              onTap: () => Navigator.pushReplacementNamed(context, '/habits'),
            ),
            _createDrawerItem(
              icon: Icons.pie_chart,
              text: 'Analytics',
              onTap: () => Navigator.pushReplacementNamed(context, '/analytics'),
            ),
            _createDrawerItem(
              icon: Icons.calendar_today,
              text: 'Calendar',
              onTap: () => Navigator.pushReplacementNamed(context, '/calendar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    GestureTapCallback? onTap,
  }) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(text, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
