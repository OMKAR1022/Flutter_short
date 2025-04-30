import 'package:flutter/material.dart';
import 'dart:math' as math;

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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MorphingShapeDemo(),
    );
  }
}

class MorphingShapeDemo extends StatefulWidget {
  const MorphingShapeDemo({Key? key}) : super(key: key);

  @override
  State<MorphingShapeDemo> createState() => _MorphingShapeDemoState();
}

class _MorphingShapeDemoState extends State<MorphingShapeDemo> with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _colorController;
  late AnimationController _pulseController;
  late Animation<double> _morphAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _pulseAnimation;

  bool _isCircle = true;
  int _demoStep = 0;

  // Neon colors
  final List<Color> _neonColors = [
    const Color(0xFF00FFFF), // Cyan
    const Color(0xFFFF00FF), // Magenta
    const Color(0xFF00FF00), // Green
    const Color(0xFFFF2D95), // Pink
    const Color(0xFFFFFF00), // Yellow
  ];

  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();

    // Morph animation controller
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Color animation controller
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Initialize animations
    _morphAnimation = CurvedAnimation(
      parent: _morphController,
      curve: Curves.easeInOut,
    );

    _updateColorAnimation();

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Start demo sequence
    _startDemoSequence();
  }

  void _updateColorAnimation() {
    final nextColorIndex = (_colorIndex + 1) % _neonColors.length;

    _colorAnimation = ColorTween(
      begin: _neonColors[_colorIndex],
      end: _neonColors[nextColorIndex],
    ).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ),
    );

    _colorIndex = nextColorIndex;
  }

  void _startDemoSequence() {
    Future.delayed(const Duration(seconds: 2), () {
      _toggleShape();

      Future.delayed(const Duration(seconds: 4), () {
        _toggleShape();
        setState(() {
          _demoStep = 1; // Show multiple shapes
        });

        Future.delayed(const Duration(seconds: 6), () {
          _toggleShape();

          Future.delayed(const Duration(seconds: 4), () {
            _toggleShape();
            setState(() {
              _demoStep = 2; // Show interactive mode
            });

            Future.delayed(const Duration(seconds: 6), () {
              _toggleShape();

              Future.delayed(const Duration(seconds: 4), () {
                _toggleShape();
                setState(() {
                  _demoStep = 0; // Reset demo
                });

                // Restart demo sequence
                Future.delayed(const Duration(seconds: 4), () {
                  _startDemoSequence();
                });
              });
            });
          });
        });
      });
    });
  }

  void _toggleShape() {
    setState(() {
      _isCircle = !_isCircle;
    });

    if (_isCircle) {
      _morphController.reverse();
    } else {
      _morphController.forward();
    }

    _colorController.reset();
    _updateColorAnimation();
    _colorController.forward();
  }

  @override
  void dispose() {
    _morphController.dispose();
    _colorController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background grid
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'NEON MORPH',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        for (double i = 1; i < 4; i++)
                          Shadow(
                            color: _colorAnimation.value ?? _neonColors[0],
                            blurRadius: 3 * i,
                          ),
                      ],
                    ),
                  ),
                ),

                // Main shape
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: _demoStep == 2 ? _toggleShape : null,
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _morphAnimation,
                          _colorAnimation,
                          _pulseAnimation,
                        ]),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(
                                  100 - (_morphAnimation.value * 100),
                                ),
                                border: Border.all(
                                  color: _colorAnimation.value ?? _neonColors[0],
                                  width: 4,
                                ),
                                boxShadow: [
                                  for (double i = 1; i < 4; i++)
                                    BoxShadow(
                                      color: (_colorAnimation.value ?? _neonColors[0]).withOpacity(0.6 / i),
                                      blurRadius: 15 * i,
                                      spreadRadius: 5 * i,
                                    ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _isCircle ? 'CIRCLE' : 'SQUARE',
                                  style: TextStyle(
                                    color: _colorAnimation.value ?? _neonColors[0],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    shadows: [
                                      for (double i = 1; i < 4; i++)
                                        Shadow(
                                          color: _colorAnimation.value ?? _neonColors[0],
                                          blurRadius: 3 * i,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Multiple shapes in demo step 1
                if (_demoStep == 1)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (index) {
                          final delay = index * 0.33;
                          return AnimatedBuilder(
                            animation: Listenable.merge([
                              _morphAnimation,
                              _colorAnimation,
                              _pulseController,
                            ]),
                            builder: (context, child) {
                              final morphValue = (_morphAnimation.value + delay) % 1.0;
                              final pulseValue = 1.0 + (math.sin(((_pulseController.value * math.pi * 2) + (index * math.pi / 2))) * 0.1);

                              return Transform.scale(
                                scale: pulseValue,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(
                                      40 - (morphValue * 40),
                                    ),
                                    border: Border.all(
                                      color: _neonColors[(index + _colorIndex) % _neonColors.length],
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      for (double i = 1; i < 3; i++)
                                        BoxShadow(
                                          color: _neonColors[(index + _colorIndex) % _neonColors.length].withOpacity(0.5 / i),
                                          blurRadius: 10 * i,
                                          spreadRadius: 3 * i,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  ),

                // Instructions
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedOpacity(
                    opacity: _demoStep == 2 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _colorAnimation.value ?? _neonColors[0],
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_colorAnimation.value ?? _neonColors[0]).withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Text(
                        'TAP THE SHAPE TO MORPH',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw horizontal lines
    for (int i = 0; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Draw vertical lines
    for (int i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}