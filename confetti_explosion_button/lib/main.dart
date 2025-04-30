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
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      ),
      home: const ConfettiDemo(),
    );
  }
}

class ConfettiDemo extends StatefulWidget {
  const ConfettiDemo({Key? key}) : super(key: key);

  @override
  State<ConfettiDemo> createState() => _ConfettiDemoState();
}

class _ConfettiDemoState extends State<ConfettiDemo> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _confettiController;
  late AnimationController _buttonScaleController;
  late AnimationController _messageScaleController;

  // Animations
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _messageScaleAnimation;

  // Confetti state
  bool _showConfetti = false;
  int _confettiType = 0;
  String _message = "Press the button!";
  int _buttonPressCount = 0;

  // Demo timer
  Timer? _demoTimer;

  // Confetti colors
  final List<List<Color>> _confettiColorSets = [
    [
      const Color(0xFFF43F5E), // Pink
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFFFCA28), // Yellow
      const Color(0xFF22C55E), // Green
      const Color(0xFFA855F7), // Purple
    ],
    [
      const Color(0xFFEC4899), // Pink
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF14B8A6), // Teal
      const Color(0xFFF59E0B), // Amber
    ],
    [
      const Color(0xFFEF4444), // Red
      const Color(0xFFF97316), // Orange
      const Color(0xFF84CC16), // Lime
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF8B5CF6), // Purple
    ],
  ];

  // Button colors
  final List<Color> _buttonColors = [
    const Color(0xFF6366F1), // Indigo
    const Color(0xFFEC4899), // Pink
    const Color(0xFF14B8A6), // Teal
    const Color(0xFFF59E0B), // Amber
  ];
  int _currentButtonColorIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _buttonScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _messageScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize animations
    _buttonScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2,
      ),
    ]).animate(_buttonScaleController);

    _messageScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 2,
      ),
    ]).animate(_messageScaleController);

    // Add listeners
    _confettiController.addStatusListener(_onConfettiStatusChanged);

    // Start demo sequence
    _startDemoSequence();
  }

  void _startDemoSequence() {
    _demoTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      // Demo timeline for a 30-second YouTube short
      switch (timer.tick) {
        case 2: // First confetti explosion
          _triggerConfetti();
          break;
        case 6: // Change message
          _updateMessage("Tap again for more!");
          break;
        case 8: // Second confetti explosion with different type
          _triggerConfetti(type: 1);
          break;
        case 12: // Change message
          _updateMessage("Try a different style!");
          break;
        case 14: // Third confetti explosion with different type
          _triggerConfetti(type: 2);
          break;
        case 18: // Change message
          _updateMessage("One more time!");
          break;
        case 20: // Fourth confetti explosion with different type
          _triggerConfetti(type: 0, intense: true);
          break;
        case 24: // Change message
          _updateMessage("Congratulations!");
          break;
        case 27: // Reset demo
          _resetDemo();
          break;
      }
    });
  }

  void _onConfettiStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _showConfetti = false;
      });
    }
  }

  void _triggerConfetti({int type = 0, bool intense = false}) {
    // Reset controller if it's still running
    if (_confettiController.isAnimating) {
      _confettiController.reset();
    }

    setState(() {
      _showConfetti = true;
      _confettiType = type;
      _buttonPressCount++;
      _currentButtonColorIndex = (_currentButtonColorIndex + 1) % _buttonColors.length;
    });

    // Animate button press
    _buttonScaleController.forward(from: 0);

    // Start confetti animation
    _confettiController.forward(from: 0);

    // Update message based on button press count
    if (!intense) {
      switch (_buttonPressCount % 4) {
        case 1:
          _updateMessage("Awesome!");
          break;
        case 2:
          _updateMessage("Great job!");
          break;
        case 3:
          _updateMessage("Fantastic!");
          break;
        case 0:
          _updateMessage("Amazing!");
          break;
      }
    } else {
      _updateMessage("SPECTACULAR!!!");
    }
  }

  void _updateMessage(String message) {
    _messageScaleController.forward(from: 0);

    // Update message halfway through the animation (when it's scaled to 0)
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _message = message;
      });
    });
  }

  void _resetDemo() {
    setState(() {
      _showConfetti = false;
      _confettiType = 0;
      _message = "Press the button!";
      _buttonPressCount = 0;
      _currentButtonColorIndex = 0;
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _buttonScaleController.dispose();
    _messageScaleController.dispose();
    _demoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: ConfettiBackgroundPainter(),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Message
                AnimatedBuilder(
                  animation: _messageScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _messageScaleAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _message,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _buttonColors[_currentButtonColorIndex],
                      ),
                    ),
                  ),
                ),

                // Button
                AnimatedBuilder(
                  animation: _buttonScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _buttonScaleAnimation.value,
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    onTap: () => _triggerConfetti(
                      type: _buttonPressCount % 3,
                      intense: _buttonPressCount % 4 == 3,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: _buttonColors[_currentButtonColorIndex],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _buttonColors[_currentButtonColorIndex].withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.celebration,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                    ),
                  ),
                ),

                // Instructions
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Tap the button to celebrate!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Confetti layer
          if (_showConfetti)
            Positioned.fill(
              child: ConfettiOverlay(
                controller: _confettiController,
                colors: _confettiColorSets[_confettiType % _confettiColorSets.length],
                confettiType: _confettiType,
                intense: _buttonPressCount % 4 == 3,
              ),
            ),
        ],
      ),
    );
  }
}

class ConfettiOverlay extends StatelessWidget {
  final AnimationController controller;
  final List<Color> colors;
  final int confettiType;
  final bool intense;

  const ConfettiOverlay({
    Key? key,
    required this.controller,
    required this.colors,
    this.confettiType = 0,
    this.intense = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(
            progress: controller.value,
            colors: colors,
            confettiType: confettiType,
            intense: intense,
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final int confettiType;
  final bool intense;

  final List<ConfettiParticle> _particles = [];

  ConfettiPainter({
    required this.progress,
    required this.colors,
    required this.confettiType,
    required this.intense,
  }) {
    if (_particles.isEmpty) {
      _initializeParticles();
    }
  }

  void _initializeParticles() {
    final random = math.Random();
    final particleCount = intense ? 150 : 80;

    for (int i = 0; i < particleCount; i++) {
      final color = colors[random.nextInt(colors.length)];
      final shape = random.nextInt(3); // 0: rectangle, 1: circle, 2: triangle
      final size = 5.0 + random.nextDouble() * 10.0;

      // Velocity and angle
      final speed = 300.0 + random.nextDouble() * 200.0;
      final angle = random.nextDouble() * 2 * math.pi;

      // For spiral effect
      final spiralRadius = random.nextDouble() * 100.0;
      final spiralAngleSpeed = 2.0 + random.nextDouble() * 3.0;

      // For zigzag effect
      final zigzagFrequency = 3.0 + random.nextDouble() * 5.0;
      final zigzagAmplitude = 10.0 + random.nextDouble() * 20.0;

      _particles.add(
        ConfettiParticle(
          color: color,
          shape: shape,
          size: size,
          speed: speed,
          angle: angle,
          rotationSpeed: (random.nextDouble() - 0.5) * 5.0,
          spiralRadius: spiralRadius,
          spiralAngleSpeed: spiralAngleSpeed,
          zigzagFrequency: zigzagFrequency,
          zigzagAmplitude: zigzagAmplitude,
          gravity: 300.0 + random.nextDouble() * 200.0,
          drag: 0.05 + random.nextDouble() * 0.05,
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (final particle in _particles) {
      // Calculate position based on progress and particle properties
      double x, y;

      if (confettiType == 0) {
        // Standard explosion
        x = centerX + particle.speed * progress * math.cos(particle.angle);
        y = centerY + particle.speed * progress * math.sin(particle.angle) +
            0.5 * particle.gravity * progress * progress;
      } else if (confettiType == 1) {
        // Spiral effect
        final spiralAngle = particle.angle + progress * particle.spiralAngleSpeed;
        final distanceFromCenter = particle.spiralRadius * progress;
        x = centerX + distanceFromCenter * math.cos(spiralAngle);
        y = centerY + distanceFromCenter * math.sin(spiralAngle) +
            0.5 * particle.gravity * progress * progress;
      } else {
        // Zigzag effect
        x = centerX + particle.speed * progress * math.cos(particle.angle) +
            particle.zigzagAmplitude * math.sin(progress * particle.zigzagFrequency);
        y = centerY + particle.speed * progress * math.sin(particle.angle) +
            0.5 * particle.gravity * progress * progress;
      }

      // Apply rotation
      final rotation = progress * particle.rotationSpeed;

      // Draw particle
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final paint = Paint()..color = particle.color;

      switch (particle.shape) {
        case 0: // Rectangle
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.5,
            ),
            paint,
          );
          break;
        case 1: // Circle
          canvas.drawCircle(
            Offset.zero,
            particle.size / 2,
            paint,
          );
          break;
        case 2: // Triangle
          final path = Path();
          path.moveTo(0, -particle.size / 2);
          path.lineTo(particle.size / 2, particle.size / 2);
          path.lineTo(-particle.size / 2, particle.size / 2);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class ConfettiParticle {
  final Color color;
  final int shape;
  final double size;
  final double speed;
  final double angle;
  final double rotationSpeed;
  final double spiralRadius;
  final double spiralAngleSpeed;
  final double zigzagFrequency;
  final double zigzagAmplitude;
  final double gravity;
  final double drag;

  ConfettiParticle({
    required this.color,
    required this.shape,
    required this.size,
    required this.speed,
    required this.angle,
    required this.rotationSpeed,
    required this.spiralRadius,
    required this.spiralAngleSpeed,
    required this.zigzagFrequency,
    required this.zigzagAmplitude,
    required this.gravity,
    required this.drag,
  });
}

class ConfettiBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern

    // Draw circles
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 5 + random.nextDouble() * 20;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}