import 'package:flutter/material.dart';
import 'package:scrubbrpro/PayoutsPage.dart';
import 'package:scrubbrpro/RatingsScreen.dart';
import 'package:scrubbrpro/SupportPage.dart';

import 'ScrubMapPage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ScrubMapPage(),
    const SupportPage(),
    const PayoutsPage(),
    const RatingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF3A7BD5),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_car_wash), label: 'Scrub'),
          BottomNavigationBarItem(icon: Icon(Icons.headset_mic), label: 'Support'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Payouts'),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Ratings'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
