import 'package:flutter/material.dart';
import 'package:scrubbrpro/PayoutsPage.dart';
import 'package:scrubbrpro/RatingsScreen.dart';
import 'package:scrubbrpro/SupportPage.dart';
import 'package:scrubbrpro/utils/InheritedWidget.dart';
import 'ScrubMapPage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool isDarkMode = false;

  final List<Widget> _pages = [
    const ScrubMapPage(),
    const SupportPage(),
    const PayoutsPage(),
    const RatingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    isDarkMode = InheritedThemeWrapper.of(context).isDarkMode;

    return Theme(
      data: Theme.of(context).copyWith(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          selectedItemColor: isDarkMode ? Colors.lightBlueAccent : const Color(0xFF3A7BD5),
          unselectedItemColor: isDarkMode ? Colors.grey[400] : Colors.grey,
        ),
      ),
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.bubble_chart), label: 'Scrub'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Support'),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money_outlined), label: 'Payouts'),
            BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Ratings'),
          ],
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
