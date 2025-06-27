import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  void _startLiveChat(BuildContext context) {
    // Placeholder logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Live chat coming soon...')),
    );

    // Later, you can navigate to a chat screen or open an external service.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need Help?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tap the button below to start a live chat with our support team.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Start Live Chat'),
                onPressed: () => _startLiveChat(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
