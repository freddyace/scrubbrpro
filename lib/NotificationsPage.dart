import 'package:flutter/material.dart';
import 'package:scrubbrpro/NotificationCard.dart';
import 'package:scrubbrpro/utils/InheritedWidget.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Mock notification data
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Payment Received',
      'description': 'You received \$75 for Job #1024.',
      'time': '10:42 AM',
      'isRead': false,
    },
    {
      'title': 'Job Reminder',
      'description': 'Home cleaning scheduled at 1:00 PM today.',
      'time': '8:15 AM',
      'isRead': true,
    },
    {
      'title': 'Support Message',
      'description': '“Let us know if you need anything. If the customer is still reporting an issue, please start a support chat and include your order\'s number and your current progress on the order you\'re working on. Our records indicate that you are no longer within the vicinity of the job you\'ve accepted to work on.”',
      'time': 'Yesterday',
      'isRead': false,
    },
  ];

  final Set<int> _tappedCards = {}; // Tracks tapped state for animations

  @override
  Widget build(BuildContext context) {
    final isDarkMode = InheritedThemeWrapper.of(context).isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Header Row
          Container(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Mark all read', style: TextStyle(fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    Text('Sort by time', style: TextStyle(color: Colors.blue)),
                    Icon(Icons.arrow_drop_down, color: Colors.blue),
                  ],
                ),
              ],
            ),
          ),

          // Notification List
          Expanded(
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final item = _notifications[index];
                final isRead = item['isRead'] as bool;
                final isTapped = _tappedCards.contains(index);

                return NotificationCard(notification: _notifications[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
