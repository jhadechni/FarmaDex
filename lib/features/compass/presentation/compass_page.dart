import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> with SingleTickerProviderStateMixin {
  static const platform = MethodChannel('com.pokedex.compass');
  double _currentAzimuth = 0.0;
  double _displayedAzimuth = 0.0;

  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  Timer? _sensorTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _displayedAzimuth = _rotationAnimation.value;
        });
      });

    _startCompassUpdates();
  }

  void _startCompassUpdates() {
    _sensorTimer = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      try {
        final double? newAzimuth = await platform.invokeMethod('getAzimuth');
        if (newAzimuth != null) {
          _animateToAzimuth(newAzimuth);
        }
      } on PlatformException catch (e) {
        debugPrint('Error reading compass: ${e.message}');
      }
    });
  }

  void _animateToAzimuth(double newAzimuth) {
    double start = _displayedAzimuth;
    double end = newAzimuth;

    // Normalizar ambos ángulos en [0, 360)
    start = start % 360;
    end = end % 360;

    // Calcular la diferencia mínima entre ángulos
    double delta = end - start;

    if (delta.abs() > 180) {
      if (delta > 0) {
        delta -= 360;
      } else {
        delta += 360;
      }
    }

    double target = start + delta;

    _rotationAnimation = Tween<double>(
      begin: start,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _sensorTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final compassSize = screenWidth * 0.95;

    return Scaffold(
      appBar: AppBar(title: const Text('Compass')),
      body: Center(
        child: Transform.rotate(
          angle: -_displayedAzimuth * (math.pi / 180),
          child: Image.asset(
            'lib/core/assets/images/pokeball_compass.png',
            width: compassSize,
          ),
        ),
      ),
    );
  }
}
