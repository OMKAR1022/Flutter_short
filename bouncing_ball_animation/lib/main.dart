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
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A5AE0),
          brightness: Brightness.light,
        ),
      ),
      home: const BouncingBallDemo(),
    );
  }
}

class BouncingBallDemo extends StatefulWidget {
  const BouncingBallDemo({Key? key}) : super(key: key);

  @override
  State<BouncingBallDemo> createState() => _BouncingBallDemoState();
}

class _BouncingBallDemoState extends State<BouncingBallDemo> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _mainController;
  late AnimationController _squashController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _horizontalAnimation;
  late Animation<double> _squashAnimation;
  late Animation<double> _stretchAnimation;

  // Ball properties
  double _ballSize = 50;
  Color _ballColor = const Color(0xFFFF6B6B);

  // Cloud properties
  final List<CloudData> _clouds = [];

  // Demo state
  int _demoPhase = 0;
  bool _isCelebrating = false;

  // Colors
  final List<Color> _ballColors = [
    const Color(0xFFFF6B6B), // Red
    const Color(0xFF4ECDC4), // Teal
    const Color(0xFFFFBE0B), // Yellow
    const Color(0xFF7209B7), // Purple
    const Color(0xFF06D6A0), // Green
  ];

  @override
  void initState() {
    super.initState();

    // Initialize clouds
    _initClouds();

    // Main animation controller - controls the entire 30 second sequence
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    // Squash controller for cartoon effect
    _squashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Bounce animation - vertical movement
    _bounceAnimation = TweenSequence<double>([
      // Initial bounce
      TweenSequenceItem(
        tween: Tween<double>(begin: 100, end: 300)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 300, end: 150)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 10,
      ),
      // Second bounce
      TweenSequenceItem(
        tween: Tween<double>(begin: 150, end: 300)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 300, end: 180)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 10,
      ),
      // Third bounce - higher
      TweenSequenceItem(
        tween: Tween<double>(begin: 180, end: 300)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 300, end: 100)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 10,
      ),
      // Multiple small bounces
      TweenSequenceItem(
        tween: Tween<double>(begin: 100, end: 300)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 300, end: 200)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 200, end: 300)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 300, end: 250)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 5,
      ),
      // Final super bounce
      TweenSequenceItem(
        tween: Tween<double>(begin: 250, end: 300)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 300, end: 50)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 10,
      ),
    ]).animate(_mainController);

    // Horizontal animation
    _horizontalAnimation = TweenSequence<double>([
      // Stay in place for first bounces
      TweenSequenceItem(
        tween: ConstantTween<double>(100),
        weight: 30,
      ),
      // Move right
      TweenSequenceItem(
        tween: Tween<double>(begin: 100, end: 250)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      // Move left
      TweenSequenceItem(
        tween: Tween<double>(begin: 250, end: 50)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      // Move center for finale
      TweenSequenceItem(
        tween: Tween<double>(begin: 50, end: 150)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      // Stay center for finale
      TweenSequenceItem(
        tween: ConstantTween<double>(150),
        weight: 40,
      ),
    ]).animate(_mainController);

    // Squash and stretch animations
    _squashAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(_squashController);
    _stretchAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(_squashController);

    // Add listeners to trigger effects at specific points
    _mainController.addListener(_onAnimationChanged);

    // Start the animation
    _mainController.repeat();
  }

  void _initClouds() {
    final random = math.Random();
    for (int i = 0; i < 5; i++) {
      _clouds.add(
        CloudData(
          x: random.nextDouble() * 300,
          y: 50.0 + random.nextDouble() * 150,
          scale: 0.5 + random.nextDouble() * 0.5,
          speed: 0.5 + random.nextDouble() * 1.0,
        ),
      );
    }
  }

  void _onAnimationChanged() {
    // Trigger squash effect when ball hits bottom
    if (_bounceAnimation.value >= 295 && _bounceAnimation.value <= 300) {
      if (!_squashController.isAnimating) {
        _squashController.forward().then((_) {
          _squashController.reverse();
        });
      }
    }

    // Update demo phase for text and color changes
    double progress = _mainController.value;

    if (progress < 0.2) {
      _updateDemoPhase(0);
    } else if (progress < 0.4) {
      _updateDemoPhase(1);
    } else if (progress < 0.6) {
      _updateDemoPhase(2);
    } else if (progress < 0.8) {
      _updateDemoPhase(3);
    } else {
      _updateDemoPhase(4);
      if (progress > 0.85 && progress < 0.95) {
        _isCelebrating = true;
      } else {
        _isCelebrating = false;
      }
    }
  }

  void _updateDemoPhase(int phase) {
    if (_demoPhase != phase) {
      setState(() {
        _demoPhase = phase;
        _ballColor = _ballColors[phase % _ballColors.length];
      });
    }
  }

  void _updateClouds() {
    for (var cloud in _clouds) {
      cloud.x += cloud.speed;
      if (cloud.x > MediaQuery.of(context).size.width + 50) {
        cloud.x = -100;
        cloud.y = 50.0 + math.Random().nextDouble() * 150;
      }
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _squashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update cloud positions
    _updateClouds();

    return Scaffold(
      backgroundColor: const Color(0xFF97DEFF),
      appBar: AppBar(
        title: const Text(
          'Bouncy Ball',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _squashController]),
        builder: (context, child) {
          // Calculate squash and stretch effect
          double squashFactor = _bounceAnimation.value > 250 ? _squashAnimation.value : 1.0;
          double stretchFactor = _bounceAnimation.value > 250 ? _stretchAnimation.value : 1.0;

          // Calculate ball size based on demo phase
          double currentBallSize = _demoPhase == 4 ? _ballSize * 1.5 : _ballSize;

          return Stack(
            children: [
              // Background elements
              ..._buildClouds(),

              // Ground
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7DCE13),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: CustomPaint(
                    painter: GrassPainter(),
                    size: Size(MediaQuery.of(context).size.width, 100),
                  ),
                ),
              ),

              // Bouncing ball
              Positioned(
                left: _horizontalAnimation.value,
                top: _bounceAnimation.value,
                child: Container(
                  width: currentBallSize * stretchFactor,
                  height: currentBallSize * squashFactor,
                  decoration: BoxDecoration(
                    color: _ballColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: currentBallSize * 0.4 * stretchFactor,
                      height: currentBallSize * 0.4 * squashFactor,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              // Shadow
              Positioned(
                left: _horizontalAnimation.value + 5,
                bottom: 90,
                child: Container(
                  width: currentBallSize * 0.8,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Celebration effects
              if (_isCelebrating)
                ..._buildCelebrationEffects(),

              // Instructions
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getInstructionText(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getInstructionText() {
    switch (_demoPhase) {
      case 0:
        return "Watch the ball bounce!";
      case 1:
        return "Bouncing around!";
      case 2:
        return "Look at it go!";
      case 3:
        return "Bouncing everywhere!";
      case 4:
        return "Woohoo! Super bounce!";
      default:
        return "Watch the ball bounce!";
    }
  }

  List<Widget> _buildClouds() {
    return _clouds.map((cloud) {
      return Positioned(
        left: cloud.x,
        top: cloud.y,
        child: Transform.scale(
          scale: cloud.scale,
          child: const CloudWidget(),
        ),
      );
    }).toList();
  }

  List<Widget> _buildCelebrationEffects() {
    final random = math.Random();
    List<Widget> effects = [];

    for (int i = 0; i < 10; i++) {
      effects.add(
        Positioned(
          left: random.nextDouble() * MediaQuery.of(context).size.width,
          top: random.nextDouble() * 300,
          child: Text(
            "✨",
            style: TextStyle(
              fontSize: 20 + random.nextInt(20).toDouble(),
            ),
          ),
        ),
      );
    }

    return effects;
  }
}

class CloudData {
  double x;
  double y;
  double scale;
  double speed;

  CloudData({
    required this.x,
    required this.y,
    required this.scale,
    required this.speed,
  });
}

class CloudWidget extends StatelessWidget {
  const CloudWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 10,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 50,
            top: 15,
            child: Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GrassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5BB318)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < size.width; i += 5) {
      final height = 5 + random.nextDouble() * 15;
      final path = Path();
      path.moveTo(i.toDouble(), 0);
      path.lineTo(i + 2.5, -height);
      path.lineTo(i + 5, 0);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}