import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;
  final duration = const Duration(
    minutes: 0,
    seconds: 60,
  );
  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  late final AnimationController _marqueeController =
      AnimationController(vsync: this, duration: const Duration(seconds: 20))
        ..repeat(reverse: true);

  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 500,
    ),
  );

  late final AnimationController _menuController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 5,
    ),
  );

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.1, 0),
    end: const Offset(-0.6, 0),
  ).animate(_marqueeController);

  void _onPlayPauseTap() {
    if (_playPauseController.isCompleted) {
      _playPauseController.reverse();
    } else {
      _playPauseController.forward();
    }
  }

  bool _dragging = false;

  void _toggleDragging() {
    setState(() {
      _dragging = !_dragging;
    });
  }

  final ValueNotifier<double> _volume = ValueNotifier<double>(0.0);

  late final size = MediaQuery.of(context).size;

  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volume.value += details.delta.dx;

    _volume.value = _volume.value.clamp(
      0.0,
      size.width - 80,
    );
  }

  void _openMenu() {
    _menuController.forward();
  }

  void _closeMenu() {
    _menuController.reverse();
  }

  final List<Map<String, dynamic>> _menus = [
    {
      "icon": Icons.person,
      "title": "Profile",
    },
    {
      "icon": Icons.notifications,
      "title": "Notifications",
    },
    {
      "icon": Icons.settings,
      "title": "Settings",
    },
  ];

  @override
  void dispose() {
    _progressController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: _closeMenu,
              icon: const Icon(Icons.close),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                for (var menu in _menus) ...[
                  Row(
                    children: [
                      Icon(
                        menu["icon"],
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        menu["title"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
                const Spacer(),
                const Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Song Name',
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: _openMenu,
                icon: const Icon(Icons.menu),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: "${widget.index}",
                  child: Container(
                    height: 350,
                    width: 350,
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
                        image: AssetImage("assets/covers/${widget.index}.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(size.width - 80, 5),
                    painter: ProgressBar(
                      progressValue: _progressController.value,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    final currentDuration =
                        widget.duration * _progressController.value;
                    final leftDuration = widget.duration -
                        currentDuration +
                        const Duration(seconds: 1);

                    return Row(
                      children: [
                        Text(
                          formatDuration(currentDuration),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatDuration(leftDuration),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Song Name",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SlideTransition(
                position: _marqueeTween,
                child: const Text(
                  "Album Name - Artist Name - Year",
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _onPlayPauseTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedIcon(
                      icon: AnimatedIcons.pause_play,
                      progress: _playPauseController,
                      size: 60,
                    ),
                    // LottieBuilder.asset(
                    //   "assets/animations/play-lottie.json",
                    //   controller: _playPauseController,
                    //   onLoaded: (composition) {
                    //     _playPauseController.duration = composition.duration;
                    //   },
                    //   width: 200,
                    //   height: 200,
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onHorizontalDragUpdate: _onVolumeDragUpdate,
                onHorizontalDragStart: (_) => _toggleDragging(),
                onHorizontalDragEnd: (_) => _toggleDragging(),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceOut,
                  scale: _dragging ? 1.1 : 1,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _volume,
                      builder: (context, value, child) {
                        return CustomPaint(
                          size: Size(size.width - 80, 50),
                          painter: VolumePainter(
                            volume: value,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;
  ProgressBar({required this.progressValue});

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;
    //track

    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(trackRRect, trackPaint);

    //progress
    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);

    // thumb

    canvas.drawCircle(
      Offset(
        progress,
        size.height / 2,
      ),
      10,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}

class VolumePainter extends CustomPainter {
  final double volume;

  VolumePainter({required this.volume});
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.grey.shade300;

    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(bgRect, bgPaint);

    final volumePaint = Paint()..color = Colors.grey.shade500;

    final volumeRect = Rect.fromLTWH(
      0,
      0,
      volume,
      size.height,
    );

    canvas.drawRect(volumeRect, volumePaint);
  }

  @override
  bool shouldRepaint(covariant VolumePainter oldDelegate) {
    return oldDelegate.volume != volume;
  }
}

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return "$minutes:$seconds";
}
