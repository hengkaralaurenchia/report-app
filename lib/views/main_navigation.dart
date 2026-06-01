import 'package:flutter/material.dart';
import 'package:report_app/views/home_page.dart';
import 'package:report_app/views/history_page.dart';
import 'package:report_app/views/notification_page.dart';
import 'package:report_app/views/profile_page.dart';
import 'package:report_app/views/add_report_page.dart';
import 'package:report_app/widgets/buttom_navbar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ReportHistoryPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  void _onTap(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddReportPage()),
      );
    } else {
      int pageIndex;
      if (index == 0) pageIndex = 0;
      else if (index == 1) pageIndex = 1;
      else if (index == 3) pageIndex = 2;
      else if (index == 4) pageIndex = 3;
      else return;

      setState(() {
        _currentIndex = pageIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex == 0 ? 0 : (_currentIndex == 1 ? 1 : (_currentIndex == 2 ? 3 : 4)),
        onTap: _onTap,
      ),
    );
  }
}