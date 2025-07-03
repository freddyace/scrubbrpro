import 'package:flutter/material.dart';

class PayoutsPage extends StatelessWidget {
  const PayoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/temp/avatar.jpg'),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Juliana Silva", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Scrubbr", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_none),
                  const SizedBox(width: 12),
                  const Icon(Icons.menu),
                ],
              ),
            ),

            // Balance card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("\$1,050.00",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 4),
                        Text("Balance", style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 8),
                        Text("****\n123-456-7890", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    const Spacer(),
                    const Column(
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 30),
                        SizedBox(height: 8),
                        Text("Weekly\nEarnings",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Transfer and Request buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(
                    children: [
                      Icon(Icons.attach_money, size: 32, color: Colors.black),
                      SizedBox(height: 4),
                      Text("Transfer")
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.request_page, size: 32, color: Colors.black),
                      SizedBox(height: 4),
                      Text("Request")
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Job section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("May 1st - May 7th", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Sort by Latest", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildJobItem("Premium Car Cleaning", "May 4th, 2024", 160, icon: Icons.directions_car),
                  _buildJobItem("Premium Car Cleaning", "May 3rd, 2024", 250, icon: Icons.directions_car),
                  _buildJobItem("Standard Home Cleaning", "May 2nd, 2024", 420, icon: Icons.home),
                  _buildJobItem("Standard Car Cleaning", "May 1st, 2024", 90, icon: Icons.directions_car),
                  _buildJobItem("Standard Car Cleaning", "May 1st, 2024", 130, icon: Icons.directions_car),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildJobItem(String title, String date, int amount, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text("\$$amount", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
