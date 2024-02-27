import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisScreen extends StatefulWidget {
  const SharedAxisScreen({super.key});

  @override
  State<SharedAxisScreen> createState() => _SharedAxisScreenState();
}

class _SharedAxisScreenState extends State<SharedAxisScreen> {
  int _currentImage = 1;

  @override
  Widget build(BuildContext context) {
    void goToImage(int newImage) {
      setState(() {
        _currentImage = newImage;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Axis'),
      ),
      body: Column(
        children: [
          PageTransitionSwitcher(
            duration: const Duration(seconds: 5),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
              child: child,
            ),
            child: Container(
              key: ValueKey<int>(_currentImage),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/covers/$_currentImage.jpg"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var btn in [1, 2, 3, 4, 5])
                ElevatedButton(
                  onPressed: () => goToImage(btn),
                  child: Text("$btn"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
