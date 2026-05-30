import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/views/add_report_page.dart';
import 'package:report_app/views/boarding_page.dart'; // 👈 IMPORT BOARDING
import 'package:report_app/views/history_page.dart';
import 'package:report_app/views/home_page.dart';
import 'package:report_app/views/notification_page.dart';
import 'package:report_app/views/profile_page.dart';
import 'package:report_app/widgets/buttom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Laporan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const BoardingPage(), // 👈 GANTI JADI BOARDING PAGE
    );
  }
}

// ============ MAIN NAVIGATION ============
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
    const AddReportPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  void _onNavTap(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddReportPage()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}