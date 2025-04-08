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
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        fontFamily: 'Orbitron',
      ),
      home: const FuturisticToggleDemo(),
    );
  }
}

class FuturisticToggleDemo extends StatefulWidget {
  const FuturisticToggleDemo({Key? key}) : super(key: key);

  @override
  State<FuturisticToggleDemo> createState() => _FuturisticToggleDemoState();
}

class _FuturisticToggleDemoState extends State<FuturisticToggleDemo> with TickerProviderStateMixin {
  bool _isOn = false;
  late AnimationController _slideController;
  late AnimationController _glowController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    // Controller for the sliding animation
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Controller for the glow effect
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Controller for the pulse effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Auto-toggle for demo purposes
    Future.delayed(const Duration(seconds: 2), () {
      _toggle();

      // Toggle again after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        _toggle();
      });
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOn = !_isOn;
      if (_isOn) {
        _slideController.forward();
      } else {
        _slideController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E21),
              const Color(0xFF0A0E21).withOpacity(0.8),
              const Color(0xFF0A0E21).withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title with futuristic style
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        const Color(0xFF4A00E0),
                        const Color(0xFF8E2DE2),
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    "FUTURISTIC TOGGLE",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Toggle switch
                GestureDetector(
                  onTap: _toggle,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_slideController, _glowController, _pulseController]),
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background glow effect
                          if (_isOn)
                            Positioned.fill(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _isOn ? 1.0 : 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4A00E0).withOpacity(0.3 + _glowController.value * 0.2),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // Toggle track
                          Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _isOn
                                  ? const Color(0xFF1A1F38)
                                  : const Color(0xFF0A0E21),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: _isOn
                                    ? const Color(0xFF4A00E0)
                                    : Colors.grey.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _isOn
                                      ? const Color(0xFF4A00E0).withOpacity(0.3)
                                      : Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // ON/OFF text
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: _isOn ? 1.0 : 0.0,
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: Text(
                                        "ON",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: _isOn ? 0.0 : 1.0,
                                  child: const Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: Text(
                                        "OFF",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Circuit pattern
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: CustomPaint(
                                      painter: CircuitPatternPainter(
                                        color: _isOn
                                            ? const Color(0xFF4A00E0).withOpacity(0.2 + _glowController.value * 0.1)
                                            : Colors.grey.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Sliding thumb
                          Positioned(
                            left: Tween<double>(begin: 5, end: 55).evaluate(_slideController),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: _isOn
                                      ? [
                                    const Color(0xFF4A00E0),
                                    const Color(0xFF8E2DE2),
                                  ]
                                      : [
                                    Colors.grey.shade400,
                                    Colors.grey.shade600,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _isOn
                                        ? const Color(0xFF4A00E0).withOpacity(0.5)
                                        : Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: _isOn
                                    ? _buildPowerIcon()
                                    : Icon(
                                  Icons.power_settings_new,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          // Glow particles when ON
                          if (_isOn)
                            Positioned(
                              left: Tween<double>(begin: 5, end: 55).evaluate(_slideController),
                              child: Container(
                                width: 40,
                                height: 40,
                                child: CustomPaint(
                                  painter: GlowParticlesPainter(
                                    baseColor: const Color(0xFF8E2DE2),
                                    progress: _pulseController.value,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 60),

                // Status text
                AnimatedBuilder(
                  animation: _slideController,
                  builder: (context, child) {
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: 1.0,
                      child: Text(
                        _isOn ? "SYSTEM ACTIVATED" : "SYSTEM STANDBY",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _isOn ? const Color(0xFF8E2DE2) : Colors.grey,
                          letterSpacing: 1.5,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Power level indicator
                AnimatedBuilder(
                  animation: _slideController,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 200,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: _isOn ? 200 * _slideController.value : 0,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4A00E0),
                                Color(0xFF8E2DE2),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4A00E0).withOpacity(0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 60),

                // Footer text for YouTube
                const Text(
                  "Subscribe for more Flutter tutorials",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPowerIcon() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Icon(
          Icons.power_settings_new,
          color: Colors.white,
          size: 20 + (_glowController.value * 2),
        );
      },
    );
  }
}

class CircuitPatternPainter extends CustomPainter {
  final Color color;

  CircuitPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw circuit-like patterns
    final path = Path();

    // Horizontal lines
    path.moveTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height * 0.3);

    path.moveTo(size.width * 0.1, size.height * 0.5);
    path.lineTo(size.width * 0.9, size.height * 0.5);

    path.moveTo(size.width * 0.2, size.height * 0.7);
    path.lineTo(size.width * 0.8, size.height * 0.7);

    // Vertical connections
    path.moveTo(size.width * 0.3, size.height * 0.3);
    path.lineTo(size.width * 0.3, size.height * 0.5);

    path.moveTo(size.width * 0.7, size.height * 0.5);
    path.lineTo(size.width * 0.7, size.height * 0.7);

    // Small circles at intersections
    canvas.drawPath(path, paint);

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.3),
      2,
      Paint()..color = color,
    );

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.5),
      2,
      Paint()..color = color,
    );

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.5),
      2,
      Paint()..color = color,
    );

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.7),
      2,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(CircuitPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class GlowParticlesPainter extends CustomPainter {
  final Color baseColor;
  final double progress;

  GlowParticlesPainter({
    required this.baseColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw particles emanating from the center
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi + (progress * 2 * math.pi / 4);
      final distance = radius * 0.7 + (radius * 0.5 * math.sin(progress * 2 * math.pi + i));

      final particleRadius = 1.5 + math.sin(progress * 2 * math.pi + i) * 1.0;

      final particlePosition = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      final paint = Paint()
        ..color = baseColor.withOpacity(0.6 - (distance / (radius * 2)))
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(particlePosition, particleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(GlowParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.baseColor != baseColor;
  }
}