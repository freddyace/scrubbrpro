import 'package:flutter/material.dart';

class GigTypeSelectionPage extends StatefulWidget {
  const GigTypeSelectionPage({super.key});

  @override
  State<GigTypeSelectionPage> createState() => _GigTypeSelectionPageState();
}

class _GigTypeSelectionPageState extends State<GigTypeSelectionPage> {
  String selectedType = '';
  bool agreedToTerms = false;

  Widget _buildGigButton(String label, Color color, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = label;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        height: 50,
        decoration: BoxDecoration(
          color: selected
              ? color
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected && label != 'Auto' ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _start() {
    if (selectedType.isNotEmpty && agreedToTerms) {
      // Proceed to next step (navigate or activate)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected gig: $selectedType")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(60)),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 60,
                  left: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Choose',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              color: Colors.white)),
                      Text('Gig',
                          style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text('Type',
                          style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Image.asset(
                    'assets/images/bubbles.PNG',
                    width: 120,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          _buildGigButton('Home', const Color(0xFF4FACFE), selectedType == 'Home'),
          _buildGigButton('Auto', const Color(0xFFAaf8db), selectedType == 'Auto'),
          _buildGigButton('Both', const Color(0xFF4FACFE), selectedType == 'Both'),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(
              children: [
                Checkbox(
                  value: agreedToTerms,
                  onChanged: (val) => setState(() => agreedToTerms = val ?? false),
                ),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'I agree to the ',
                      style: TextStyle(fontSize: 13),
                      children: [
                        TextSpan(
                          text: 'Terms & Policies',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: GestureDetector(
              onTap: _start,
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFFAaf8db)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
