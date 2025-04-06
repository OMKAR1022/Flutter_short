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
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Poppins',
      ),
      home: const FitnessProgressDemo(),
    );
  }
}

class FitnessProgressDemo extends StatefulWidget {
  const FitnessProgressDemo({Key? key}) : super(key: key);

  @override
  State<FitnessProgressDemo> createState() => _FitnessProgressDemoState();
}

class _FitnessProgressDemoState extends State<FitnessProgressDemo> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _colorController;

  late Animation<double> _progressAnimation;

  // Fitness metrics
  final int stepsGoal = 10000;
  final int currentSteps = 7568;
  final double caloriesBurned = 352;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Create progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: currentSteps / stepsGoal,
    ).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start the animation
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App title with animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, -20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: const Text(
                "FITNESS TRACKER",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Animated progress circle
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background glow
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, _) {
                        return Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.transparent,
                                _getAnimatedColor(0.3),
                                Colors.transparent,
                              ],
                              stops: const [0.7, 0.8, 1.0],
                            ),
                          ),
                        );
                      },
                    ),

                    // Background circle with pulse
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, _) {
                        return Transform.scale(
                          scale: 1.0 + (_pulseController.value * 0.05),
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF304FFE).withOpacity(0.1 + (_pulseController.value * 0.1)),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Progress circle with entrance animation
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: CustomPaint(
                          painter: GradientCircularProgressPainter(
                            progress: _progressAnimation.value,
                            strokeWidth: 15,
                            gradientColors: [
                              _getAnimatedColor(1.0),
                              _getAnimatedColor(0.8, offset: 60),
                              _getAnimatedColor(0.9, offset: 120),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Inner content with counter animation
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Steps count with counter animation
                        TweenAnimationBuilder<int>(
                          tween: IntTween(
                            begin: 0,
                            end: currentSteps,
                          ),
                          duration: const Duration(milliseconds: 1500),
                          builder: (context, value, child) {
                            return AnimatedBuilder(
                              animation: _colorController,
                              builder: (context, _) {
                                return Text(
                                  value.toString(),
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: _getAnimatedColor(0.8),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        // Steps label with glow
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Text(
                              "STEPS",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.white.withOpacity(0.3 + (_pulseController.value * 0.3)),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        // Goal text
                        Text(
                          "GOAL: $stepsGoal",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white38,
                          ),
                        ),

                        // Percentage indicator
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            final percentage = (_progressAnimation.value * 100).toInt();
                            return AnimatedBuilder(
                              animation: _colorController,
                              builder: (context, _) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    "$percentage%",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _getAnimatedColor(1.0),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    // Initial pulse effect
                    if (_progressController.value < 0.3)
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1000),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: (1 - value) * 0.4,
                            child: Transform.scale(
                              scale: 0.8 + (value * 0.3),
                              child: AnimatedBuilder(
                                animation: _colorController,
                                builder: (context, _) {
                                  return Container(
                                    width: 250,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _getAnimatedColor(1.0),
                                        width: 15 * (1 - value),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),

                    // Shimmer effect along the progress
                    if (_progressAnimation.value > 0.05)
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, _) {
                          final endAngle = -math.pi / 2 + (2 * math.pi * _progressAnimation.value);
                          return Positioned(
                            left: 125 + 110 * math.cos(endAngle),
                            top: 125 + 110 * math.sin(endAngle),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    _getAnimatedColor(1.0, offset: 180),
                                    _getAnimatedColor(0.5, offset: 180),
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getAnimatedColor(0.7, offset: 180),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            // Additional metrics with staggered animations
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedMetricCard(
                  icon: Icons.local_fire_department,
                  value: caloriesBurned.toStringAsFixed(0),
                  label: "CALORIES",
                  color: const Color(0xFFFF6E40),
                  delay: 0,
                ),
                const SizedBox(width: 20),
                _buildAnimatedMetricCard(
                  icon: Icons.timer,
                  value: "32",
                  label: "MINUTES",
                  color: const Color(0xFF00E5FF),
                  delay: 200,
                ),
                const SizedBox(width: 20),
                _buildAnimatedMetricCard(
                  icon: Icons.straighten,
                  value: "5.2",
                  label: "KM",
                  color: const Color(0xFF304FFE),
                  delay: 400,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Footer text for YouTube with fade-in
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
             // delay: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: const Text(
                "Subscribe for more Flutter tutorials",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get animated colors
  Color _getAnimatedColor(double opacity, {double offset = 0}) {
    return HSVColor.fromAHSV(
      opacity,
      ((_colorController.value * 360) + offset) % 360,
      0.7,
      0.9,
    ).toColor();
  }

  Widget _buildAnimatedMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
     // delay: Duration(milliseconds: delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          // Add a little bounce animation when tapped
          _pulseController.reset();
          _pulseController.forward();
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            // Create a subtle color shift based on the main animation
            final animatedColor = HSLColor.fromColor(color)
                .withLightness(0.5 + (_pulseController.value * 0.2))
                .toColor();

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: animatedColor.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: animatedColor.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: animatedColor,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> gradientColors;

  GradientCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Create gradient
    final gradient = SweepGradient(
      colors: gradientColors,
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      tileMode: TileMode.clamp,
    );

    // Create paint for progress arc
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(
        center: center,
        radius: radius,
      ))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background track with reduced opacity
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth / 2,
    );

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Arc angle based on progress
      false,
      paint,
    );

    // Draw small circles at the start and end of the progress arc
    if (progress > 0) {
      // Start point
      canvas.drawCircle(
        Offset(
          center.dx,
          center.dy - radius,
        ),
        strokeWidth / 2,
        Paint()..color = gradientColors.first,
      );

      // End point
      if (progress < 1.0) {
        final endAngle = -math.pi / 2 + (2 * math.pi * progress);
        canvas.drawCircle(
          Offset(
            center.dx + radius * math.cos(endAngle),
            center.dy + radius * math.sin(endAngle),
          ),
          strokeWidth / 2,
          Paint()..color = gradientColors.last,
        );
      }

      // Draw glow at the end point
      if (progress > 0.05) {
        final endAngle = -math.pi / 2 + (2 * math.pi * progress);
        canvas.drawCircle(
          Offset(
            center.dx + radius * math.cos(endAngle),
            center.dy + radius * math.sin(endAngle),
          ),
          strokeWidth,
          Paint()
            ..color = gradientColors.last.withOpacity(0.5)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }
    }
  }

  @override
  bool shouldRepaint(GradientCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.gradientColors != gradientColors;
  }
}