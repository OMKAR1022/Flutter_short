import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

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
        fontFamily: 'Montserrat',
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0277BD),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0277BD),
          brightness: Brightness.light,
        ),
      ),
      home: const OceanWaveDemo(),
    );
  }
}

class OceanWaveDemo extends StatefulWidget {
  const OceanWaveDemo({Key? key}) : super(key: key);

  @override
  State<OceanWaveDemo> createState() => _OceanWaveDemoState();
}

class _OceanWaveDemoState extends State<OceanWaveDemo> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _waveController;
  late AnimationController _heightController;
  late AnimationController _colorController;

  // Animations
  Animation<double>? _heightAnimation;
  Animation<Color?>? _primaryColorAnimation;
  Animation<Color?>? _secondaryColorAnimation;
  Animation<Color?>? _tertiaryColorAnimation;

  // Wave properties
  double _waveHeight = 60.0;
  double _headerHeight = 220.0;
  int _demoPhase = 0;

  // Ocean colors
  final List<Color> _oceanColors = [
    const Color(0xFF01579B), // Deep ocean blue
    const Color(0xFF039BE5), // Medium blue
    const Color(0xFF03A9F4), // Light blue
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF26C6DA), // Light cyan
  ];

  // Current colors
  late Color _primaryColor;
  late Color _secondaryColor;
  late Color _tertiaryColor;

  @override
  void initState() {
    super.initState();

    // Initialize colors
    _primaryColor = _oceanColors[0];
    _secondaryColor = _oceanColors[1];
    _tertiaryColor = _oceanColors[2];

    // Wave animation controller
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Header height animation controller
    _heightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Color animation controller
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Add status listeners
    _heightController.addStatusListener(_onHeightAnimationStatusChanged);
    _colorController.addStatusListener(_onColorAnimationStatusChanged);

    // Start demo sequence
    _startDemoSequence();
  }

  void _onHeightAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _heightAnimation?.removeListener(_updateHeaderHeight);
    }
  }

  void _onColorAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _primaryColorAnimation?.removeListener(_updateColors);
    }
  }

  void _updateHeaderHeight() {
    setState(() {
      _headerHeight = _heightAnimation!.value;
    });
  }

  void _updateColors() {
    setState(() {
      _primaryColor = _primaryColorAnimation!.value!;
      _secondaryColor = _secondaryColorAnimation!.value!;
      _tertiaryColor = _tertiaryColorAnimation!.value!;
    });
  }

  void _startDemoSequence() {
    Future.delayed(const Duration(seconds: 3), () {
      _animateHeaderHeight(300.0);
      _updateDemoPhase(1);
    });

    Future.delayed(const Duration(seconds: 7), () {
      _animateHeaderHeight(180.0);
      _animateColors(1);
      _updateDemoPhase(2);
    });

    Future.delayed(const Duration(seconds: 11), () {
      _animateHeaderHeight(250.0);
      _animateColors(2);
      _updateDemoPhase(3);
    });

    Future.delayed(const Duration(seconds: 15), () {
      _animateHeaderHeight(200.0);
      _animateColors(3);
      _updateDemoPhase(4);
    });

    Future.delayed(const Duration(seconds: 19), () {
      _animateHeaderHeight(280.0);
      _animateColors(4);
      _updateDemoPhase(5);
    });

    Future.delayed(const Duration(seconds: 23), () {
      _animateHeaderHeight(220.0);
      _animateColors(0);
      _updateDemoPhase(0);
    });

    // Loop the demo
    Future.delayed(const Duration(seconds: 28), () {
      _startDemoSequence();
    });
  }

  void _animateHeaderHeight(double height) {
    // Reset controller
    _heightController.reset();

    // Create new animation
    _heightAnimation = Tween<double>(
      begin: _headerHeight,
      end: height,
    ).animate(
      CurvedAnimation(
        parent: _heightController,
        curve: Curves.easeInOut,
      ),
    );

    // Add listener
    _heightAnimation!.addListener(_updateHeaderHeight);

    // Start animation
    _heightController.forward();
  }

  void _animateColors(int colorIndex) {
    // Reset controller
    _colorController.reset();

    final nextPrimaryIndex = colorIndex % _oceanColors.length;
    final nextSecondaryIndex = (colorIndex + 1) % _oceanColors.length;
    final nextTertiaryIndex = (colorIndex + 2) % _oceanColors.length;

    final Color nextPrimary = _oceanColors[nextPrimaryIndex];
    final Color nextSecondary = _oceanColors[nextSecondaryIndex];
    final Color nextTertiary = _oceanColors[nextTertiaryIndex];

    // Create new animations
    _primaryColorAnimation = ColorTween(
      begin: _primaryColor,
      end: nextPrimary,
    ).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ),
    );

    _secondaryColorAnimation = ColorTween(
      begin: _secondaryColor,
      end: nextSecondary,
    ).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ),
    );

    _tertiaryColorAnimation = ColorTween(
      begin: _tertiaryColor,
      end: nextTertiary,
    ).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ),
    );

    // Add listener
    _primaryColorAnimation!.addListener(_updateColors);

    // Start animation
    _colorController.forward();
  }

  void _updateDemoPhase(int phase) {
    setState(() {
      _demoPhase = phase;
    });
  }

  @override
  void dispose() {
    // Clean up animations
    _heightAnimation?.removeListener(_updateHeaderHeight);
    _primaryColorAnimation?.removeListener(_updateColors);

    // Dispose controllers
    _waveController.dispose();
    _heightController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Wave header
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return Stack(
                children: [
                  // Container with waves
                  Container(
                    height: _headerHeight,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: WavePainter(
                        animationValue: _waveController.value,
                        waveHeight: _waveHeight,
                        primaryColor: _primaryColor,
                        secondaryColor: _secondaryColor,
                        tertiaryColor: _tertiaryColor,
                        // Adjust wave position to be lower in the container
                        wavePosition: 0.7,
                      ),
                    ),
                  ),

                  // Content on top of waves
                  Container(
                    height: _headerHeight,
                    width: double.infinity,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Ocean Waves",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.waves, color: Colors.white),
                                  onPressed: () {
                                    // Trigger a wave height change on tap
                                    setState(() {
                                      _waveHeight = _waveHeight == 60.0 ? 80.0 : 60.0;
                                    });
                                  },
                                ),
                              ],
                            ),

                            // Text positioned above the waves
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 50.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 8.0
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _getHeaderText(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
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
                ],
              );
            },
          ),

          // Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.water_drop,
                      size: 60,
                      color: Color(0xFF0277BD),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Tap the wave icon to change wave height",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildWaveInfoCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getHeaderText() {
    switch (_demoPhase) {
      case 0:
        return "Beautiful wave animations with CustomPainter";
      case 1:
        return "Watch as the header height changes smoothly";
      case 2:
        return "Colors transition between ocean shades";
      case 3:
        return "Perfect for app headers and backgrounds";
      case 4:
        return "Easily customizable wave parameters";
      case 5:
        return "Create stunning UI effects with waves";
      default:
        return "Beautiful wave animations with CustomPainter";
    }
  }

  Widget _buildWaveInfoCard() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Wave Animation Demo",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem("Waves", "3"),
              _buildInfoItem("Animation", "Continuous"),
              _buildInfoItem("Colors", "Dynamic"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final double waveHeight;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final double wavePosition; // New parameter to control wave position

  WavePainter({
    required this.animationValue,
    required this.waveHeight,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    this.wavePosition = 0.9, // Default position at 90% from top
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background gradient
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryColor,
        primaryColor.withOpacity(0.8),
      ],
    );

    final backgroundPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    // Calculate wave positions based on wavePosition parameter
    final firstWaveYOffset = size.height * wavePosition;
    final secondWaveYOffset = size.height * (wavePosition + 0.05);
    final thirdWaveYOffset = size.height * (wavePosition + 0.1);

    // First wave (back)
    _drawWave(
      canvas,
      size,
      waveHeight: waveHeight * 0.8,
      frequency: 0.5,
      phase: animationValue * 2 * math.pi,
      color: tertiaryColor.withOpacity(0.3),
      yOffset: firstWaveYOffset,
    );

    // Second wave (middle)
    _drawWave(
      canvas,
      size,
      waveHeight: waveHeight,
      frequency: 0.7,
      phase: animationValue * 2 * math.pi * 1.2,
      color: secondaryColor.withOpacity(0.5),
      yOffset: secondWaveYOffset,
    );

    // Third wave (front)
    _drawWave(
      canvas,
      size,
      waveHeight: waveHeight * 1.2,
      frequency: 1.0,
      phase: animationValue * 2 * math.pi * 0.8,
      color: primaryColor.withOpacity(0.7),
      yOffset: thirdWaveYOffset,
    );
  }

  void _drawWave(
      Canvas canvas,
      Size size, {
        required double waveHeight,
        required double frequency,
        required double phase,
        required Color color,
        required double yOffset,
      }) {
    final path = Path();
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    path.moveTo(0, yOffset);

    for (double x = 0; x <= size.width; x++) {
      final y = math.sin((x * frequency / size.width) * 2 * math.pi + phase) *
          waveHeight + yOffset;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.waveHeight != waveHeight ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.tertiaryColor != tertiaryColor ||
        oldDelegate.wavePosition != wavePosition;
  }
}