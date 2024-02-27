import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/screens/apple_watch_screen.dart';
import 'package:flutter_animations_masterclass/screens/container_transform_screen.dart';
import 'package:flutter_animations_masterclass/screens/explicit_animations_screen.dart';
import 'package:flutter_animations_masterclass/screens/implicit_animations_screen.dart';
import 'package:flutter_animations_masterclass/screens/music_player_screen.dart';
import 'package:flutter_animations_masterclass/screens/rive_screen.dart';
import 'package:flutter_animations_masterclass/screens/shared_axis_screen.dart';
import 'package:flutter_animations_masterclass/screens/swiping_cards_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  Widget _menuButton(
    BuildContext context,
    Widget screen,
    String text,
  ) {
    return ElevatedButton(
      onPressed: () {
        _goToPage(
          context,
          screen,
        );
      },
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animations'),
      ),
      body: Center(
        child: Column(
          children: [
            _menuButton(
              context,
              const ImplicitAnimationsScreen(),
              'Implicit Animations',
            ),
            _menuButton(
              context,
              const ExplicitAnimationsScreen(),
              'Explicit Animations',
            ),
            _menuButton(
              context,
              const AppleWatchScreen(),
              'Apple Watch',
            ),
            _menuButton(
              context,
              const SwipingCardsScreen(),
              'Swipping Cards',
            ),
            _menuButton(
              context,
              const MusicPlayerScreen(),
              'Music Player',
            ),
            _menuButton(
              context,
              const RiveScreen(),
              'Rive',
            ),
            _menuButton(
              context,
              const ContainerTransformScreen(),
              'Container Transform',
            ),
            _menuButton(
              context,
              const SharedAxisScreen(),
              'Shared Axis',
            ),
          ],
        ),
      ),
    );
  }
}
