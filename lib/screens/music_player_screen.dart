import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/screens/music_player_detail_screen.dart';

List<Map<String, dynamic>> songs = [
  {
    "title": "EASY",
    "artist": "LE SSERAFIM",
    "album": "EASY",
    "year": "2024",
    "duration": const Duration(minutes: 2, seconds: 45),
  },
  {
    "title": "ETA",
    "artist": "NewJeans",
    "album": "NewJeans 2nd EP 'Get Up'",
    "year": "2023",
    "duration": const Duration(minutes: 2, seconds: 32),
  },
  {
    "title": "Pop Virus",
    "artist": "Gen Hoshino",
    "album": "POP VIRUS",
    "year": "2018",
    "duration": const Duration(minutes: 3, seconds: 2),
  },
  {
    "title": "홀씨",
    "artist": "아이유",
    "album": "The Winning",
    "year": "2024",
    "duration": const Duration(minutes: 3, seconds: 11),
  },
  {
    "title": "EARFQUAKE",
    "artist": "Tyler, The Creator",
    "album": "IGOR",
    "year": "2019",
    "duration": const Duration(minutes: 3, seconds: 11),
  },
];

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
  );

  int _currentPage = 0;

  final ValueNotifier<double> _scroll = ValueNotifier<double>(0.0);

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page == null) return;
      _scroll.value = _pageController.page!;
    });
  }

  void _onTap(int imageIndex) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
              opacity: animation,
              child: MusicPlayerDetailScreen(
                index: imageIndex + 1,
                title: songs[imageIndex]["title"],
                artist: songs[imageIndex]["artist"],
                album: songs[imageIndex]["album"],
                year: songs[imageIndex]["year"],
                duration: songs[imageIndex]["duration"],
              ));
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: UniqueKey(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/covers/${_currentPage + 1}.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20,
                  sigmaY: 20,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          PageView.builder(
            onPageChanged: _onPageChanged,
            controller: _pageController,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _scroll,
                    builder: (context, scroll, child) {
                      final difference = (scroll - index).abs();
                      final scale = 1 - (difference * 0.1);
                      return GestureDetector(
                        onTap: () => _onTap(index),
                        child: Hero(
                          tag: "${index + 1}",
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              height: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/covers/${index + 1}.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  Text(
                    songs[index]["title"],
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    songs[index]["artist"],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
