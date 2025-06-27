import 'package:flutter/material.dart';

class AnimatedCardFromBottom extends StatefulWidget {
  const AnimatedCardFromBottom({Key? key}) : super(key: key);

  @override
  _AnimatedCardFromBottomState createState() => _AnimatedCardFromBottomState();
}

class _AnimatedCardFromBottomState extends State<AnimatedCardFromBottom> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(_controller);

    // Start the animation when the widget is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Card(
        child: Container(
          height: 200,
          color: Colors.blue,
          child: const Center(
            child: Text('Animated Card'),
          ),
        ),
      ),
    );
  }
}
