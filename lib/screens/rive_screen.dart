import 'package:flutter/material.dart';

class RiveScreen extends StatefulWidget {
  const RiveScreen({super.key});

  @override
  State<RiveScreen> createState() => _RiveScreenState();
}

class _RiveScreenState extends State<RiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 400,
              width: double.infinity,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Go!'),
            )
          ],
        ),
      ),
    );
  }
}
