import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  late final bound = size.width - 200;
  late final dropZone = size.width + 100;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1,
  );

  late final Tween<double> _buttonOpacity = Tween(
    begin: 0,
    end: 0.55,
  );

  late final Tween<double> _buttonScale = Tween(
    begin: 1,
    end: 1.1,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_position.value.abs() >= bound) {
      final factor = _position.value.sign;
      _throwCard(factor.toInt());
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  void _throwCard(int factor) {
    _position
        .animateTo(
          (dropZone) * factor,
          curve: Curves.easeOut,
        )
        .whenComplete(_whenComplete);
  }

  void _onCloseTap() {
    if (_position.isAnimating) return;
    _throwCard(-1);
  }

  void _onCheckTap() {
    if (_position.isAnimating) return;
    _throwCard(1);
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swiping Cards'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation
                  .transform((_position.value + size.width / 2) / size.width) *
              pi /
              180;

          final scale = min(
            _scale.transform(
              _position.value.abs() / size.width,
            ),
            1.0,
          );

          final buttonOpacity = _buttonOpacity
              .transform(
                _position.value.abs() / size.width,
              )
              .clamp(0.0, 1.0);

          final buttonScale = _buttonScale.transform(
            _position.value.abs() / size.width,
          );

          final isCheck = _position.value > 0;

          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: scale,
                  child: Cards(
                    index: _index == 5 ? 1 : _index + 1,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Cards(
                        index: _index,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                child: Row(
                  children: [
                    ActionButton(
                      icon: Icons.close,
                      color: Colors.red,
                      onTap: _onCloseTap,
                      opacity: isCheck ? 0 : buttonOpacity,
                      scale: isCheck ? 1 : buttonScale,
                    ),
                    const SizedBox(width: 30),
                    ActionButton(
                      icon: Icons.check,
                      color: Colors.green,
                      onTap: _onCheckTap,
                      opacity: isCheck ? buttonOpacity : 0,
                      scale: isCheck ? buttonScale : 1,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Cards extends StatelessWidget {
  final int index;

  const Cards({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Image.asset(
          "assets/covers/$index.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double opacity;
  final double scale;

  const ActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.opacity,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: scale,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 7),
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 3,
              )
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withOpacity(opacity),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              size: 50,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
