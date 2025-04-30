import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Playfair Display',
        brightness: Brightness.light,
      ),
      home: const PendulumClockDemo(),
    );
  }
}

class PendulumClockDemo extends StatefulWidget {
  const PendulumClockDemo({Key? key}) : super(key: key);

  @override
  State<PendulumClockDemo> createState() => _PendulumClockDemoState();
}

class _PendulumClockDemoState extends State<PendulumClockDemo> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _pendulumController;
  late AnimationController _hourHandController;
  late AnimationController _minuteHandController;
  late AnimationController _secondHandController;

  // Animations
  late Animation<double> _pendulumAnimation;

  // Clock state
  bool _isRunning = false;
  int _demoStep = 0;
  double _pendulumLength = 150.0;

  // Demo timer
  Timer? _demoTimer;

  // Time
  DateTime _currentTime = DateTime.now();
  Timer? _timeTimer;

  @override
  void initState() {
    super.initState();

    // Initialize pendulum animation controller
    _pendulumController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Initialize clock hands controllers
    _hourHandController = AnimationController(
      vsync: this,
      duration: const Duration(hours: 12),
    );

    _minuteHandController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 60),
    );

    _secondHandController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    // Initialize pendulum animation
    _pendulumAnimation = Tween<double>(
      begin: -0.3,
      end: 0.3,
    ).animate(
      CurvedAnimation(
        parent: _pendulumController,
        curve: Curves.easeInOut,
      ),
    );

    // Set up pendulum oscillation
    _pendulumController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pendulumController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _pendulumController.forward();
      }
    });

    // Set up time update
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();

        // Update clock hand controllers
        final hour = _currentTime.hour % 12 / 12;
        final minute = _currentTime.minute / 60;
        final second = _currentTime.second / 60;

        _hourHandController.value = hour;
        _minuteHandController.value = minute;
        _secondHandController.value = second;
      });
    });

    // Start demo sequence
    _startDemoSequence();
  }

  void _startDemoSequence() {
    _demoTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      // Demo timeline for a 30-second YouTube short
      switch (timer.tick) {
        case 2: // Start pendulum
          _startPendulum();
          break;
        case 6: // Highlight clock face
          setState(() {
            _demoStep = 1;
          });
          break;
        case 10: // Highlight pendulum
          setState(() {
            _demoStep = 2;
          });
          break;
        case 14: // Speed up pendulum
          _changePendulumSpeed(700);
          break;
        case 18: // Slow down pendulum
          _changePendulumSpeed(1300);
          break;
        case 22: // Normal speed
          _changePendulumSpeed(1000);
          break;
        case 26: // Reset demo
          _resetDemo();
          break;
      }
    });
  }

  void _startPendulum() {
    setState(() {
      _isRunning = true;
    });
    _pendulumController.forward();
  }

  void _stopPendulum() {
    setState(() {
      _isRunning = false;
    });
    _pendulumController.stop();
  }

  void _changePendulumSpeed(int durationMs) {
    // Remember the current position
    final value = _pendulumController.value;
    final status = _pendulumController.status;

    // Recreate the controller with new duration
    _pendulumController.dispose();
    _pendulumController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
      value: value,
    );

    // Recreate the animation
    _pendulumAnimation = Tween<double>(
      begin: -0.3,
      end: 0.3,
    ).animate(
      CurvedAnimation(
        parent: _pendulumController,
        curve: Curves.easeInOut,
      ),
    );

    // Set up pendulum oscillation again
    _pendulumController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pendulumController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _pendulumController.forward();
      }
    });

    // Resume from where we left off
    if (_isRunning) {
      if (status == AnimationStatus.forward) {
        _pendulumController.forward();
      } else {
        _pendulumController.reverse();
      }
    }
  }

  void _resetDemo() {
    setState(() {
      _demoStep = 0;
    });
    _changePendulumSpeed(1000);
  }

  @override
  void dispose() {
    _pendulumController.dispose();
    _hourHandController.dispose();
    _minuteHandController.dispose();
    _secondHandController.dispose();
    _demoTimer?.cancel();
    _timeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Vintage Pendulum Clock',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // Clock
            SizedBox(
              height: 500,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Clock body
                  Container(
                    width: 300,
                    height: 500,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B4513),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF8B4513),
                          Color(0xFF6B3311),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Wood grain pattern
                        CustomPaint(
                          size: const Size(300, 500),
                          painter: WoodGrainPainter(),
                        ),

                        // Clock face
                        Positioned(
                          top: 50,
                          left: 50,
                          right: 50,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFD4AF37),
                                width: 5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Clock face details
                                CustomPaint(
                                  size: const Size(200, 200),
                                  painter: ClockFacePainter(
                                    highlight: _demoStep == 1,
                                  ),
                                ),

                                // Hour hand
                                Center(
                                  child: RotationTransition(
                                    turns: _hourHandController,
                                    child: Transform.translate(
                                      offset: const Offset(0, -30),
                                      child: Container(
                                        width: 6,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Minute hand
                                Center(
                                  child: RotationTransition(
                                    turns: _minuteHandController,
                                    child: Transform.translate(
                                      offset: const Offset(0, -40),
                                      child: Container(
                                        width: 4,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Second hand
                                Center(
                                  child: RotationTransition(
                                    turns: _secondHandController,
                                    child: Transform.translate(
                                      offset: const Offset(0, -45),
                                      child: Container(
                                        width: 2,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Center cap
                                Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD4AF37),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Pendulum anchor
                        Positioned(
                          top: 250,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 20,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),

                        // Pendulum
                        Positioned(
                          top: 255,
                          left: 0,
                          right: 0,
                          child: AnimatedBuilder(
                            animation: _pendulumAnimation,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.topCenter,
                                transform: Matrix4.identity()
                                  ..rotateZ(_pendulumAnimation.value),
                                child: child,
                              );
                            },
                            child: Container(
                              width: 4,
                              height: _pendulumLength,
                              decoration: BoxDecoration(
                                color: _demoStep == 2
                                    ? const Color(0xFFFFD700)
                                    : const Color(0xFFD4AF37),
                                boxShadow: _demoStep == 2
                                    ? [
                                  BoxShadow(
                                    color: const Color(0xFFFFD700).withOpacity(0.5),
                                    blurRadius: 10,
                                  ),
                                ]
                                    : null,
                              ),
                              child: Stack(
                                children: [
                                  // Pendulum bob
                                  Positioned(
                                    bottom: 0,
                                    left: -18,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: _demoStep == 2
                                            ? const Color(0xFFFFD700)
                                            : const Color(0xFFD4AF37),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: _demoStep == 2
                                                ? const Color(0xFFFFD700)
                                                : const Color(0xFFD4AF37),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.brown.withOpacity(0.3),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Clock base
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B3311),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Start/Stop button
                  ElevatedButton(
                    onPressed: _isRunning ? _stopPendulum : _startPendulum,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning ? Colors.red[800] : Colors.green[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isRunning ? 'Stop Pendulum' : 'Start Pendulum',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Speed control
                  ElevatedButton(
                    onPressed: () {
                      if (_pendulumController.duration!.inMilliseconds == 1000) {
                        _changePendulumSpeed(700); // Faster
                      } else if (_pendulumController.duration!.inMilliseconds == 700) {
                        _changePendulumSpeed(1300); // Slower
                      } else {
                        _changePendulumSpeed(1000); // Normal
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _pendulumController.duration!.inMilliseconds == 1000
                          ? 'Change Speed'
                          : _pendulumController.duration!.inMilliseconds == 700
                          ? 'Slow Down'
                          : 'Speed Up',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Time display
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                  fontFamily: 'Courier New',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClockFacePainter extends CustomPainter {
  final bool highlight;

  ClockFacePainter({this.highlight = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw hour markers
    final hourMarkerPaint = Paint()
      ..color = highlight ? const Color(0xFFD4AF37) : Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = highlight ? 3 : 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final outerPoint = Offset(
        center.dx + (radius - 10) * math.cos(angle),
        center.dy + (radius - 10) * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 20) * math.cos(angle),
        center.dy + (radius - 20) * math.sin(angle),
      );

      canvas.drawLine(innerPoint, outerPoint, hourMarkerPaint);
    }

    // Draw minute markers
    final minuteMarkerPaint = Paint()
      ..color = highlight ? const Color(0xFFD4AF37).withOpacity(0.7) : Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = highlight ? 1.5 : 1
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 60; i++) {
      // Skip positions where hour markers are
      if (i % 5 == 0) continue;

      final angle = (i * 6) * math.pi / 180;
      final outerPoint = Offset(
        center.dx + (radius - 10) * math.cos(angle),
        center.dy + (radius - 10) * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 15) * math.cos(angle),
        center.dy + (radius - 15) * math.sin(angle),
      );

      canvas.drawLine(innerPoint, outerPoint, minuteMarkerPaint);
    }

    // Draw hour numbers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 1; i <= 12; i++) {
      final angle = ((i * 30) - 90) * math.pi / 180;
      final offset = Offset(
        center.dx + (radius - 35) * math.cos(angle),
        center.dy + (radius - 35) * math.sin(angle),
      );

      textPainter.text = TextSpan(
        text: i.toString(),
        style: TextStyle(
          color: highlight ? const Color(0xFFD4AF37) : Colors.black,
          fontSize: highlight ? 18 : 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Times New Roman',
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          offset.dx - textPainter.width / 2,
          offset.dy - textPainter.height / 2,
        ),
      );
    }

    // Draw vintage brand name
    textPainter.text = TextSpan(
      text: 'CHRONOS',
      style: TextStyle(
        color: highlight ? const Color(0xFFD4AF37) : Colors.black.withOpacity(0.7),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: 'Times New Roman',
        letterSpacing: 1,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy + 30,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant ClockFacePainter oldDelegate) {
    return oldDelegate.highlight != highlight;
  }
}

class WoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final random = math.Random(42); // Fixed seed for consistent pattern

    // Draw wood grain lines
    for (int i = 0; i < 100; i++) {
      final y = random.nextDouble() * size.height;
      final path = Path();

      path.moveTo(0, y);

      double x = 0;
      while (x < size.width) {
        final controlPoint1 = Offset(
          x + random.nextDouble() * 50 + 20,
          y + (random.nextDouble() * 20 - 10),
        );

        final controlPoint2 = Offset(
          controlPoint1.dx + random.nextDouble() * 50 + 20,
          y + (random.nextDouble() * 20 - 10),
        );

        final endPoint = Offset(
          controlPoint2.dx + random.nextDouble() * 50 + 20,
          y + (random.nextDouble() * 10 - 5),
        );

        path.cubicTo(
          controlPoint1.dx, controlPoint1.dy,
          controlPoint2.dx, controlPoint2.dy,
          endPoint.dx, endPoint.dy,
        );

        x = endPoint.dx;
      }

      canvas.drawPath(path, paint);
    }

    // Draw wood knots
    final knotPaint = Paint()
      ..color = Colors.brown.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 5 + random.nextDouble() * 10;

      canvas.drawCircle(Offset(x, y), radius, knotPaint);

      // Draw rings around knot
      for (int j = 1; j <= 3; j++) {
        final ringPaint = Paint()
          ..color = Colors.brown.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(Offset(x, y), radius + j * 3, ringPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}