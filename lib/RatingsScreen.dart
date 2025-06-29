import 'package:flutter/material.dart';
import 'package:scrubbrpro/AccountPage.dart';

class RatingsPage extends StatelessWidget {
  const RatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final overallRating = 4.79;
    final ratingsCount = [446, 31, 8, 0, 1]; // 5 to 1 star
    final hasRatings = ratingsCount.any((r) => r > 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => AccountPage(),
                          transitionsBuilder: (_, animation, __, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            final tween = Tween(begin: begin, end: end);
                            final offsetAnimation = animation.drive(tween);
                            return SlideTransition(position: offsetAnimation, child: child, textDirection: TextDirection.rtl);
                          },
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Juliana Silva', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Scrubbr', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_none),
                  const SizedBox(width: 10),
                  const Icon(Icons.more_vert),
                ],
              ),
            ),
            if (hasRatings) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text('Your Ratings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(overallRating.toStringAsFixed(2), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (index) => Icon(
                        index < overallRating.floor() ? Icons.star : Icons.star_border,
                        color: Colors.blue,
                      )),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(5, (index) {
                    final star = 5 - index;
                    final count = ratingsCount[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text('$star Stars'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: count / ratingsCount.reduce((a, b) => a > b ? a : b),
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('$count'),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: List.generate(3, (index) => _buildReviewCard(index + 1)),
                ),
              ),
            ] else ...[
              const Spacer(),
              const Center(
                child: Text('No Ratings Yet!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(int jobNumber) {
    return Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    child: Image.asset(
    'assets/sample_home.jpg', // placeholder image
    height: 120,
    width: double.infinity,
    fit: BoxFit.cover,
    ),
    ),
    const SizedBox(height: 12),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Text('Job #$jobNumber', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    ),
    const Padding(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: Text('Juliana was spot on and fast. I\'m really impressed!'),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: Row(
    children: List.generate(5, (i) => const Icon(Icons.star, color: Colors.blue, size: 18)),
    ),
    ),
    const Padding(
    padding: EdgeInsets.symmetric(horizontal: 12),
    child: Text('5 Stars', style: TextStyle(fontWeight: FontWeight.w500)),
    ),
    const SizedBox(height: 12),
    ],
    ),
    );
  }
}
