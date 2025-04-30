import 'package:flutter/material.dart';
import 'dart:async';
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
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A80F0),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFF),
      ),
      home: const HeartbeatAnimationDemo(),
    );
  }
}

class HeartbeatAnimationDemo extends StatefulWidget {
  const HeartbeatAnimationDemo({Key? key}) : super(key: key);

  @override
  State<HeartbeatAnimationDemo> createState() => _HeartbeatAnimationDemoState();
}

class _HeartbeatAnimationDemoState extends State<HeartbeatAnimationDemo> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _heartbeatController;
  late AnimationController _pulseRingController;

  // Animations
  late Animation<double> _heartbeatAnimation;
  late Animation<double> _pulseRingAnimation;

  // Health metrics
  int _heartRate = 75;
  int _steps = 6428;
  double _calories = 348.5;
  String _status = "Normal";

  // Demo state
  int _demoPhase = 0;
  bool _isResting = true;

  // Demo timer
  Timer? _demoTimer;

  // Colors
  final Color _primaryColor = const Color(0xFF4A80F0);
  final Color _accentColor = const Color(0xFFFF647C);
  final Color _secondaryColor = const Color(0xFF7EAEF2);
  final Color _tertiaryColor = const Color(0xFF42CF87);

  @override
  void initState() {
    super.initState();

    // Initialize heartbeat animation controller
    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Initialize pulse ring animation controller
    _pulseRingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Create heartbeat animation
    _heartbeatAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.85)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 50,
      ),
    ]).animate(_heartbeatController);

    // Create pulse ring animation
    _pulseRingAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _pulseRingController,
        curve: Curves.easeOut,
      ),
    );

    // Start animations
    _startHeartbeatAnimation();

    // Start demo sequence
    _startDemoSequence();
  }

  void _startHeartbeatAnimation() {
    // Repeat the heartbeat animation
    _heartbeatController.repeat();

    // Repeat the pulse ring animation
    _pulseRingController.repeat();
  }

  void _startDemoSequence() {
    _demoTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      // Demo timeline for a 30-second YouTube short
      switch (timer.tick) {
        case 3: // Show resting heart rate
          _updateHeartRate(75, "Resting");
          break;
        case 7: // Transition to light activity
          _updateHeartRate(95, "Light Activity");
          break;
        case 11: // Transition to moderate activity
          _updateHeartRate(120, "Moderate Activity");
          break;
        case 15: // Transition to intense activity
          _updateHeartRate(150, "Intense Activity");
          break;
        case 19: // Start recovery
          _updateHeartRate(130, "Recovery");
          break;
        case 23: // Continue recovery
          _updateHeartRate(100, "Recovery");
          break;
        case 27: // Back to resting
          _updateHeartRate(75, "Resting");
          break;
        case 30: // Reset demo
          _resetDemo();
          break;
      }
    });
  }

  void _updateHeartRate(int rate, String status) {
    setState(() {
      _heartRate = rate;
      _status = status;
      _isResting = status == "Resting";

      // Update animation speed based on heart rate
      double speedFactor = rate / 75.0;
      _heartbeatController.duration = Duration(milliseconds: (800 / speedFactor).round());
      _heartbeatController.repeat();

      // Update demo phase
      if (status == "Resting") {
        _demoPhase = 0;
      } else if (status == "Light Activity") {
        _demoPhase = 1;
      } else if (status == "Moderate Activity") {
        _demoPhase = 2;
      } else if (status == "Intense Activity") {
        _demoPhase = 3;
      } else {
        _demoPhase = 4;
      }

      // Update other metrics
      if (status == "Light Activity") {
        _steps += 500;
        _calories += 25.5;
      } else if (status == "Moderate Activity") {
        _steps += 1000;
        _calories += 50.0;
      } else if (status == "Intense Activity") {
        _steps += 1500;
        _calories += 75.0;
      }
    });
  }

  void _resetDemo() {
    setState(() {
      _heartRate = 75;
      _steps = 6428;
      _calories = 348.5;
      _status = "Normal";
      _isResting = true;
      _demoPhase = 0;
    });
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    _pulseRingController.dispose();
    _demoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Heart Monitor',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF2D3142)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Heart rate card
          Expanded(
            flex: 4,
            child: _buildHeartRateCard(),
          ),

          // Health metrics
          Expanded(
            flex: 2,
            child: _buildHealthMetrics(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeartRateCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _isResting ? _primaryColor : _accentColor,
            _isResting ? _secondaryColor : const Color(0xFFFF8A9B),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (_isResting ? _primaryColor : _accentColor).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pulse circles
          ..._buildPulseCircles(),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Heart icon and BPM
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated heart icon
                      AnimatedBuilder(
                        animation: _heartbeatAnimation,
                        builder: (context, child) {
                          return ScaleTransition(
                            scale: _heartbeatAnimation,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.favorite,
                                  color: _isResting ? _primaryColor : _accentColor,
                                  size: 40,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // BPM display
                      Text(
                        '$_heartRate',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 64,
                        ),
                      ),

                      const Text(
                        'BPM',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Heart rate graph
                SizedBox(
                  height: 60,
                  child: CustomPaint(
                    painter: HeartRatePainter(
                      heartRate: _heartRate,
                      color: Colors.white,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPulseCircles() {
    return List.generate(3, (index) {
      return Center(
        child: AnimatedBuilder(
          animation: _pulseRingAnimation,
          builder: (context, child) {
            final delay = index * 0.4;
            final animationProgress = (_pulseRingController.value - delay) % 1.0;
            final isVisible = animationProgress > 0 && animationProgress < 0.7;

            if (!isVisible) {
              return const SizedBox.shrink();
            }

            return Opacity(
              opacity: (1 - animationProgress).clamp(0.0, 0.5),
              child: Transform.scale(
                scale: 1.0 + animationProgress,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildHealthMetrics() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Activity',
            style: TextStyle(
              color: Color(0xFF2D3142),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Row(
              children: [
                // Steps card
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.directions_walk,
                    value: _steps.toString(),
                    label: 'Steps',
                    color: _primaryColor,
                  ),
                ),

                const SizedBox(width: 16),

                // Calories card
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.local_fire_department,
                    value: _calories.toStringAsFixed(1),
                    label: 'Calories',
                    color: _tertiaryColor,
                  ),
                ),

                const SizedBox(width: 16),

                // Time card
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.timer,
                    value: '45',
                    label: 'Minutes',
                    color: _accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', isSelected: false),
              _buildNavItem(Icons.favorite, 'Heart', isSelected: true),
              _buildNavItem(Icons.bar_chart, 'Activity', isSelected: false),
              _buildNavItem(Icons.person, 'Profile', isSelected: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {required bool isSelected}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? _primaryColor : Colors.grey[400],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? _primaryColor : Colors.grey[400],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class HeartRatePainter extends CustomPainter {
  final int heartRate;
  final Color color;

  HeartRatePainter({
    required this.heartRate,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Calculate wave frequency based on heart rate
    final frequency = heartRate / 60.0;
    final amplitude = size.height * 0.3;
    final midY = size.height / 2;

    path.moveTo(0, midY);

    for (int i = 0; i < size.width; i++) {
      final normalizedX = i / size.width;
      final x = i.toDouble();

      // Create a heartbeat-like pattern
      final progress = (normalizedX * 10 * frequency) % 1.0;
      double y;

      if (progress < 0.1) {
        // First small bump
        y = midY - amplitude * 0.3 * math.sin(progress * math.pi / 0.1);
      } else if (progress < 0.2) {
        // Return to baseline
        y = midY;
      } else if (progress < 0.3) {
        // Main spike up
        y = midY - amplitude * (progress - 0.2) * 10;
      } else if (progress < 0.35) {
        // Main spike down
        y = midY - amplitude + amplitude * 2 * (progress - 0.3) * 20;
      } else if (progress < 0.4) {
        // Dip below baseline
        y = midY + amplitude * 0.5 * (0.4 - progress) * 20;
      } else if (progress < 0.5) {
        // Small recovery bump
        y = midY + amplitude * 0.2 * math.sin((progress - 0.4) * math.pi / 0.1);
      } else {
        // Flat line
        y = midY;
      }

      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HeartRatePainter oldDelegate) {
    return oldDelegate.heartRate != heartRate || oldDelegate.color != color;
  }
}