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
        primaryColor: Colors.purple,
        fontFamily: 'Schoolbell',
      ),
      home: const StoryScreen(),
    );
  }
}

class StoryScreen extends StatefulWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _storyProgressController;
  late AnimationController _ghostController;
  late AnimationController _childController;
  late AnimationController _treeController;
  late AnimationController _moonController;
  late AnimationController _batController;
  late AnimationController _owlController;
  late AnimationController _fogController;

  // Story state
  int _currentScene = 0;
  bool _isPlaying = false;
  bool _storyComplete = false;

  // Story text for each scene
  final List<String> _storyTexts = [
    "Once upon a time, there was a little child named Tim who got lost in the spooky forest...",
    "The trees seemed to watch him as he walked deeper into the darkness...",
    "Suddenly, a friendly ghost named Casper appeared! \"Don't be afraid,\" said Casper.",
    "\"I'll help you find your way home,\" Casper promised with a smile.",
    "They encountered strange creatures in the forest, but Casper kept Tim safe.",
    "The moon guided their path through the misty woods...",
    "Finally, they saw the lights of Tim's house in the distance!",
    "Tim thanked his new friend Casper, who waved goodbye before disappearing into the night.",
    "And Tim learned that sometimes, what seems scary at first can turn out to be a good friend!",
  ];

  @override
  void initState() {
    super.initState();

    // Main story progress controller (30-45 seconds total)
    _storyProgressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );

    _storyProgressController.addListener(_handleStoryProgress);

    // Character and element animations
    _ghostController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _childController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _treeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _moonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _batController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();

    _owlController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fogController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  void _handleStoryProgress() {
    // Update scene based on story progress
    final progress = _storyProgressController.value;

    int newScene = (progress * _storyTexts.length).floor();
    if (newScene >= _storyTexts.length) {
      newScene = _storyTexts.length - 1;
    }

    if (newScene != _currentScene) {
      setState(() {
        _currentScene = newScene;
      });
    }

    if (progress >= 1.0 && !_storyComplete) {
      setState(() {
        _storyComplete = true;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;

      if (_isPlaying) {
        _storyProgressController.forward();
      } else {
        _storyProgressController.stop();
      }
    });
  }

  void _restartStory() {
    setState(() {
      _currentScene = 0;
      _storyComplete = false;
      _storyProgressController.reset();

      if (_isPlaying) {
        _storyProgressController.forward();
      }
    });
  }

  @override
  void dispose() {
    _storyProgressController.dispose();
    _ghostController.dispose();
    _childController.dispose();
    _treeController.dispose();
    _moonController.dispose();
    _batController.dispose();
    _owlController.dispose();
    _fogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          _buildBackground(),

          // Story elements based on current scene
          _buildSceneElements(),

          // Story text overlay
          _buildStoryText(),

          // Controls
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _fogController,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(
            fogAnimation: _fogController.value,
            moonAnimation: _moonController.value,
            scene: _currentScene,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildSceneElements() {
    return AnimatedBuilder(
      animation: _storyProgressController,
      builder: (context, child) {
        return Stack(
          children: [
            // Trees
            ..._buildTrees(),

            // Characters and elements based on scene
            if (_currentScene >= 0) _buildChild(),
            if (_currentScene >= 2) _buildGhost(),
            if (_currentScene >= 4) _buildForestCreatures(),
            if (_currentScene >= 6) _buildHouseLights(),
          ],
        );
      },
    );
  }

  List<Widget> _buildTrees() {
    return List.generate(
      5,
          (index) => Positioned(
        left: 50.0 + index * 80.0,
        bottom: 100.0,
        child: AnimatedBuilder(
          animation: _treeController,
          builder: (context, child) {
            final swayOffset = math.sin((_treeController.value * 2 * math.pi) + index) * 5.0;

            return Transform.translate(
              offset: Offset(swayOffset, 0),
              child: CustomPaint(
                painter: TreePainter(
                  darkness: 0.5 + (index * 0.1),
                  hasEyes: _currentScene >= 1 && index % 2 == 0,
                ),
                size: Size(60, 200 - index * 20),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChild() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      left: _currentScene < 6 ? 100.0 : 300.0,
      bottom: 50.0,
      child: AnimatedBuilder(
        animation: _childController,
        builder: (context, child) {
          final bounceOffset = math.sin(_childController.value * 2 * math.pi) * 5.0;

          return Transform.translate(
            offset: Offset(0, bounceOffset),
            child: CustomPaint(
              painter: ChildPainter(
                scared: _currentScene < 3,
                happy: _currentScene >= 6,
              ),
              size: const Size(80, 120),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGhost() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      left: _currentScene < 6 ? 200.0 : 380.0,
      bottom: 70.0,
      child: AnimatedBuilder(
        animation: _ghostController,
        builder: (context, child) {
          final floatOffset = math.sin(_ghostController.value * 2 * math.pi) * 10.0;

          return Transform.translate(
            offset: Offset(0, floatOffset),
            child: CustomPaint(
              painter: GhostPainter(
                friendly: true,
                waving: _currentScene >= 7,
              ),
              size: const Size(100, 120),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForestCreatures() {
    return Stack(
      children: [
        // Bats
        Positioned(
          top: 150,
          right: 100,
          child: AnimatedBuilder(
            animation: _batController,
            builder: (context, child) {
              return CustomPaint(
                painter: BatPainter(
                  wingPosition: _batController.value,
                ),
                size: const Size(40, 20),
              );
            },
          ),
        ),

        // Owl
        Positioned(
          top: 120,
          left: 80,
          child: AnimatedBuilder(
            animation: _owlController,
            builder: (context, child) {
              final eyeSize = 0.5 + (_owlController.value * 0.5);

              return CustomPaint(
                painter: OwlPainter(
                  eyeSize: eyeSize,
                ),
                size: const Size(50, 70),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHouseLights() {
    return Positioned(
      right: 50,
      bottom: 80,
      child: Container(
        width: 120,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.brown.shade800,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // House structure
            Positioned.fill(
              child: CustomPaint(
                painter: HousePainter(),
              ),
            ),

            // Flickering lights
            Positioned(
              left: 20,
              top: 40,
              width: 20,
              height: 20,
              child: _buildFlickeringLight(Colors.yellow),
            ),
            Positioned(
              right: 20,
              top: 40,
              width: 20,
              height: 20,
              child: _buildFlickeringLight(Colors.yellow),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlickeringLight(Color color) {
    return AnimatedBuilder(
      animation: _ghostController, // Reuse ghost animation for flickering
      builder: (context, child) {
        final brightness = 0.7 + (_ghostController.value * 0.3);

        return Container(
          decoration: BoxDecoration(
            color: color.withOpacity(brightness),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(brightness * 0.5),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoryText() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
              Colors.black,
            ],
          ),
        ),
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _storyTexts[_currentScene],
                key: ValueKey<int>(_currentScene),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'Schoolbell',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _storyProgressController.value,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      top: 40,
      right: 20,
      child: Row(
        children: [
          FloatingActionButton(
            heroTag: 'restart',
            mini: true,
            backgroundColor: Colors.purple.shade700,
            child: const Icon(Icons.replay),
            onPressed: _restartStory,
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'playPause',
            backgroundColor: Colors.purple,
            child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlayPause,
          ),
        ],
      ),
    );
  }
}

// Painters

class BackgroundPainter extends CustomPainter {
  final double fogAnimation;
  final double moonAnimation;
  final int scene;

  BackgroundPainter({
    required this.fogAnimation,
    required this.moonAnimation,
    required this.scene,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Night sky gradient
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0E1A40), // Dark blue
          const Color(0xFF222E50), // Slightly lighter blue
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    // Stars
    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.7;
      final radius = random.nextDouble() * 1.5 + 0.5;

      // Twinkle effect
      final twinkle = 0.5 + (math.sin(moonAnimation * 2 * math.pi + i) * 0.5);

      // Create a new paint with the adjusted opacity
      final twinklePaint = Paint()
        ..color = Colors.white.withOpacity(twinkle)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        radius * twinkle,
        twinklePaint,
      );
    }

    // Moon
    final moonX = size.width * 0.8;
    final moonY = size.height * 0.2;
    final moonRadius = 40.0;

    // Moon glow
    final moonGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.yellow.withOpacity(0.3),
          Colors.yellow.withOpacity(0.1),
          Colors.yellow.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(
        moonX - moonRadius * 3,
        moonY - moonRadius * 3,
        moonRadius * 6,
        moonRadius * 6,
      ));

    canvas.drawCircle(
      Offset(moonX, moonY),
      moonRadius * 3,
      moonGlowPaint,
    );

    // Moon body
    final moonPaint = Paint()
      ..color = Colors.yellow.shade100;

    canvas.drawCircle(
      Offset(moonX, moonY),
      moonRadius,
      moonPaint,
    );

    // Moon craters
    final craterPaint = Paint()
      ..color = Colors.yellow.shade300
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(moonX - 15, moonY - 10), 5, craterPaint);
    canvas.drawCircle(Offset(moonX + 10, moonY + 15), 7, craterPaint);
    canvas.drawCircle(Offset(moonX + 5, moonY - 15), 4, craterPaint);

    // Ground
    final groundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.green.shade900,
          Colors.green.shade800,
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3));

    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3), groundPaint);

    // Fog
    if (scene >= 1) {
      final fogPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.3));

      // Create fog path with wave effect
      final fogPath = Path();
      fogPath.moveTo(0, size.height * 0.75);

      for (double x = 0; x < size.width; x += 20) {
        final xOffset = x + (fogAnimation * 100) % 20;
        final y = size.height * 0.75 + math.sin((xOffset / 50) + fogAnimation * 2 * math.pi) * 10;
        fogPath.lineTo(xOffset, y);
      }

      fogPath.lineTo(size.width, size.height * 0.75);
      fogPath.lineTo(size.width, size.height * 0.9);
      fogPath.lineTo(0, size.height * 0.9);
      fogPath.close();

      canvas.drawPath(fogPath, fogPaint);
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return oldDelegate.fogAnimation != fogAnimation ||
        oldDelegate.moonAnimation != moonAnimation ||
        oldDelegate.scene != scene;
  }
}

class TreePainter extends CustomPainter {
  final double darkness;
  final bool hasEyes;

  TreePainter({
    required this.darkness,
    required this.hasEyes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Tree trunk
    final trunkPaint = Paint()
      ..color = Colors.brown.shade900.withOpacity(darkness)
      ..style = PaintingStyle.fill;

    final trunkPath = Path();
    trunkPath.moveTo(size.width * 0.4, size.height);
    trunkPath.lineTo(size.width * 0.6, size.height);
    trunkPath.lineTo(size.width * 0.55, size.height * 0.3);
    trunkPath.lineTo(size.width * 0.45, size.height * 0.3);
    trunkPath.close();

    canvas.drawPath(trunkPath, trunkPaint);

    // Tree foliage
    final foliagePaint = Paint()
      ..color = Colors.green.shade900.withOpacity(darkness)
      ..style = PaintingStyle.fill;

    final foliagePath = Path();

    // Bottom layer
    foliagePath.moveTo(size.width * 0.2, size.height * 0.5);
    foliagePath.lineTo(size.width * 0.8, size.height * 0.5);
    foliagePath.lineTo(size.width * 0.5, size.height * 0.2);
    foliagePath.close();

    // Middle layer
    foliagePath.moveTo(size.width * 0.25, size.height * 0.35);
    foliagePath.lineTo(size.width * 0.75, size.height * 0.35);
    foliagePath.lineTo(size.width * 0.5, size.height * 0.1);
    foliagePath.close();

    // Top layer
    foliagePath.moveTo(size.width * 0.3, size.height * 0.2);
    foliagePath.lineTo(size.width * 0.7, size.height * 0.2);
    foliagePath.lineTo(size.width * 0.5, size.height * 0.0);
    foliagePath.close();

    canvas.drawPath(foliagePath, foliagePaint);

    // Eyes (if tree is "watching")
    if (hasEyes) {
      final eyePaint = Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width * 0.4, size.height * 0.4),
        size.width * 0.05,
        eyePaint,
      );

      canvas.drawCircle(
        Offset(size.width * 0.6, size.height * 0.4),
        size.width * 0.05,
        eyePaint,
      );

      // Pupils
      final pupilPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width * 0.4, size.height * 0.4),
        size.width * 0.02,
        pupilPaint,
      );

      canvas.drawCircle(
        Offset(size.width * 0.6, size.height * 0.4),
        size.width * 0.02,
        pupilPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TreePainter oldDelegate) {
    return oldDelegate.darkness != darkness ||
        oldDelegate.hasEyes != hasEyes;
  }
}

class ChildPainter extends CustomPainter {
  final bool scared;
  final bool happy;

  ChildPainter({
    required this.scared,
    required this.happy,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Body
    final bodyPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.3, size.height * 0.4);
    bodyPath.lineTo(size.width * 0.7, size.height * 0.4);
    bodyPath.lineTo(size.width * 0.6, size.height);
    bodyPath.lineTo(size.width * 0.4, size.height);
    bodyPath.close();

    canvas.drawPath(bodyPath, bodyPaint);

    // Head
    final headPaint = Paint()
      ..color = const Color(0xFFFFD3B5) // Skin tone
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.25),
      size.width * 0.25,
      headPaint,
    );

    // Hair
    final hairPaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    final hairPath = Path();
    hairPath.moveTo(size.width * 0.25, size.height * 0.25);
    hairPath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.05,
      size.width * 0.75, size.height * 0.25,
    );
    hairPath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.15,
      size.width * 0.25, size.height * 0.25,
    );

    canvas.drawPath(hairPath, hairPaint);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.2),
      size.width * 0.06,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.2),
      size.width * 0.06,
      eyePaint,
    );

    // Pupils
    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Adjust pupils based on emotion
    double pupilOffsetX = 0;
    if (scared) {
      pupilOffsetX = -0.01;
    } else if (happy) {
      pupilOffsetX = 0.01;
    }

    canvas.drawCircle(
      Offset(size.width * (0.4 + pupilOffsetX), size.height * 0.2),
      size.width * 0.03,
      pupilPaint,
    );

    canvas.drawCircle(
      Offset(size.width * (0.6 + pupilOffsetX), size.height * 0.2),
      size.width * 0.03,
      pupilPaint,
    );

    // Mouth based on emotion
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (scared) {
      // Scared mouth (open O)
      canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.3),
        size.width * 0.06,
        mouthPaint,
      );
    } else if (happy) {
      // Happy mouth (smile)
      final mouthPath = Path();
      mouthPath.moveTo(size.width * 0.35, size.height * 0.3);
      mouthPath.quadraticBezierTo(
        size.width * 0.5, size.height * 0.4,
        size.width * 0.65, size.height * 0.3,
      );

      canvas.drawPath(mouthPath, mouthPaint);
    } else {
      // Neutral mouth (straight line)
      canvas.drawLine(
        Offset(size.width * 0.4, size.height * 0.3),
        Offset(size.width * 0.6, size.height * 0.3),
        mouthPaint,
      );
    }

    // Arms
    final armPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Left arm
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.45),
      Offset(size.width * 0.15, size.height * 0.6),
      armPaint,
    );

    // Right arm
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.45),
      Offset(size.width * 0.85, size.height * 0.6),
      armPaint,
    );

    // Legs
    final legPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Left leg
    final leftLegPath = Path();
    leftLegPath.moveTo(size.width * 0.4, size.height);
    leftLegPath.lineTo(size.width * 0.35, size.height);
    leftLegPath.lineTo(size.width * 0.3, size.height * 1.1);
    leftLegPath.lineTo(size.width * 0.4, size.height * 1.1);
    leftLegPath.close();

    // Right leg
    final rightLegPath = Path();
    rightLegPath.moveTo(size.width * 0.6, size.height);
    rightLegPath.lineTo(size.width * 0.65, size.height);
    rightLegPath.lineTo(size.width * 0.7, size.height * 1.1);
    rightLegPath.lineTo(size.width * 0.6, size.height * 1.1);
    rightLegPath.close();

    canvas.drawPath(leftLegPath, legPaint);
    canvas.drawPath(rightLegPath, legPaint);
  }

  @override
  bool shouldRepaint(covariant ChildPainter oldDelegate) {
    return oldDelegate.scared != scared ||
        oldDelegate.happy != happy;
  }
}

class GhostPainter extends CustomPainter {
  final bool friendly;
  final bool waving;

  GhostPainter({
    required this.friendly,
    required this.waving,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Ghost body
    final bodyPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final bodyPath = Path();

    // Head/upper body
    bodyPath.addOval(Rect.fromLTWH(
      size.width * 0.2,
      0,
      size.width * 0.6,
      size.height * 0.6,
    ));

    // Lower body with wavy bottom
    bodyPath.moveTo(size.width * 0.2, size.height * 0.3);
    bodyPath.lineTo(size.width * 0.2, size.height * 0.7);

    // Wavy bottom
    for (int i = 0; i < 5; i++) {
      final x1 = size.width * (0.2 + (i * 0.15));
      final x2 = size.width * (0.2 + ((i + 1) * 0.15));
      final y1 = size.height * (0.7 + (i % 2 == 0 ? 0.1 : 0));
      final y2 = size.height * (0.7 + (i % 2 == 0 ? 0 : 0.1));

      bodyPath.quadraticBezierTo(
        (x1 + x2) / 2, y1,
        x2, y2,
      );
    }

    bodyPath.lineTo(size.width * 0.8, size.height * 0.3);
    bodyPath.close();

    // Add glow effect
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(bodyPath, glowPaint);
    canvas.drawPath(bodyPath, bodyPaint);

    // Eyes
    final eyePaint = Paint()
      ..color = friendly ? Colors.blue : Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.3),
      size.width * 0.08,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.3),
      size.width * 0.08,
      eyePaint,
    );

    // Mouth
    final mouthPaint = Paint()
      ..color = friendly ? Colors.black : Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    if (friendly) {
      // Friendly smile
      final mouthPath = Path();
      mouthPath.moveTo(size.width * 0.3, size.height * 0.4);
      mouthPath.quadraticBezierTo(
        size.width * 0.5, size.height * 0.5,
        size.width * 0.7, size.height * 0.4,
      );

      canvas.drawPath(mouthPath, mouthPaint);
    } else {
      // Scary mouth
      final mouthPath = Path();
      mouthPath.moveTo(size.width * 0.3, size.height * 0.45);
      mouthPath.quadraticBezierTo(
        size.width * 0.5, size.height * 0.35,
        size.width * 0.7, size.height * 0.45,
      );

      canvas.drawPath(mouthPath, mouthPaint);
    }

    // Arms (only if waving)
    if (waving) {
      final armPaint = Paint()
        ..color = Colors.white.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;

      final armPath = Path();
      armPath.moveTo(size.width * 0.2, size.height * 0.4);
      armPath.quadraticBezierTo(
        size.width * 0.1, size.height * 0.3,
        size.width * 0.05, size.height * 0.2,
      );

      canvas.drawPath(armPath, armPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GhostPainter oldDelegate) {
    return oldDelegate.friendly != friendly ||
        oldDelegate.waving != waving;
  }
}

class BatPainter extends CustomPainter {
  final double wingPosition;

  BatPainter({
    required this.wingPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Body
    final bodyPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.15,
      bodyPaint,
    );

    // Wings
    final wingPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Calculate wing angle based on animation
    final wingAngle = math.pi * wingPosition;

    // Left wing
    final leftWingPath = Path();
    leftWingPath.moveTo(size.width * 0.4, size.height * 0.5);
    leftWingPath.quadraticBezierTo(
      size.width * (0.2 - 0.2 * math.sin(wingAngle)),
      size.height * (0.3 + 0.2 * math.cos(wingAngle)),
      size.width * 0.1,
      size.height * 0.6,
    );
    leftWingPath.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.7,
      size.width * 0.4,
      size.height * 0.6,
    );
    leftWingPath.close();

    // Right wing
    final rightWingPath = Path();
    rightWingPath.moveTo(size.width * 0.6, size.height * 0.5);
    rightWingPath.quadraticBezierTo(
      size.width * (0.8 + 0.2 * math.sin(wingAngle)),
      size.height * (0.3 + 0.2 * math.cos(wingAngle)),
      size.width * 0.9,
      size.height * 0.6,
    );
    rightWingPath.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.7,
      size.width * 0.6,
      size.height * 0.6,
    );
    rightWingPath.close();

    canvas.drawPath(leftWingPath, wingPaint);
    canvas.drawPath(rightWingPath, wingPaint);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.45, size.height * 0.45),
      size.width * 0.03,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.45),
      size.width * 0.03,
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant BatPainter oldDelegate) {
    return oldDelegate.wingPosition != wingPosition;
  }
}

class OwlPainter extends CustomPainter {
  final double eyeSize;

  OwlPainter({
    required this.eyeSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Body
    final bodyPaint = Paint()
      ..color = Colors.brown.shade700
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.3,
        size.width * 0.6,
        size.height * 0.6,
      ),
      bodyPaint,
    );

    // Head
    final headPaint = Paint()
      ..color = Colors.brown.shade600
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.3),
      size.width * 0.3,
      headPaint,
    );

    // Eyes
    final eyeBackgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final eyeRadius = size.width * 0.12 * eyeSize;

    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.25),
      eyeRadius,
      eyeBackgroundPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.25),
      eyeRadius,
      eyeBackgroundPaint,
    );

    // Pupils
    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.25),
      eyeRadius * 0.6,
      pupilPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.25),
      eyeRadius * 0.6,
      pupilPaint,
    );

    // Beak
    final beakPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final beakPath = Path();
    beakPath.moveTo(size.width * 0.4, size.height * 0.35);
    beakPath.lineTo(size.width * 0.6, size.height * 0.35);
    beakPath.lineTo(size.width * 0.5, size.height * 0.45);
    beakPath.close();

    canvas.drawPath(beakPath, beakPaint);

    // Wings
    final wingPaint = Paint()
      ..color = Colors.brown.shade800
      ..style = PaintingStyle.fill;

    // Left wing
    final leftWingPath = Path();
    leftWingPath.moveTo(size.width * 0.2, size.height * 0.5);
    leftWingPath.lineTo(size.width * 0.1, size.height * 0.7);
    leftWingPath.lineTo(size.width * 0.3, size.height * 0.8);
    leftWingPath.lineTo(size.width * 0.4, size.height * 0.6);
    leftWingPath.close();

    // Right wing
    final rightWingPath = Path();
    rightWingPath.moveTo(size.width * 0.8, size.height * 0.5);
    rightWingPath.lineTo(size.width * 0.9, size.height * 0.7);
    rightWingPath.lineTo(size.width * 0.7, size.height * 0.8);
    rightWingPath.lineTo(size.width * 0.6, size.height * 0.6);
    rightWingPath.close();

    canvas.drawPath(leftWingPath, wingPaint);
    canvas.drawPath(rightWingPath, wingPaint);
  }

  @override
  bool shouldRepaint(covariant OwlPainter oldDelegate) {
    return oldDelegate.eyeSize != eyeSize;
  }
}

class HousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // House body
    final housePaint = Paint()
      ..color = Colors.brown.shade800
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.3, size.width, size.height * 0.7),
      housePaint,
    );

    // Roof
    final roofPaint = Paint()
      ..color = Colors.brown.shade900
      ..style = PaintingStyle.fill;

    final roofPath = Path();
    roofPath.moveTo(0, size.height * 0.3);
    roofPath.lineTo(size.width, size.height * 0.3);
    roofPath.lineTo(size.width * 0.5, 0);
    roofPath.close();

    canvas.drawPath(roofPath, roofPaint);

    // Door
    final doorPaint = Paint()
      ..color = Colors.brown.shade600
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.4,
        size.height * 0.6,
        size.width * 0.2,
        size.height * 0.4,
      ),
      doorPaint,
    );

    // Door knob
    final knobPaint = Paint()
      ..color = Colors.yellow.shade700
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.75),
      size.width * 0.02,
      knobPaint,
    );

    // Windows
    final windowPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Left window
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.4,
        size.width * 0.15,
        size.height * 0.15,
      ),
      windowPaint,
    );

    // Right window
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.65,
        size.height * 0.4,
        size.width * 0.15,
        size.height * 0.15,
      ),
      windowPaint,
    );

    // Window frames
    final framePaint = Paint()
      ..color = Colors.brown.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Left window frame
    canvas.drawLine(
      Offset(size.width * 0.275, size.height * 0.4),
      Offset(size.width * 0.275, size.height * 0.55),
      framePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.475),
      Offset(size.width * 0.35, size.height * 0.475),
      framePaint,
    );

    // Right window frame
    canvas.drawLine(
      Offset(size.width * 0.725, size.height * 0.4),
      Offset(size.width * 0.725, size.height * 0.55),
      framePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.475),
      Offset(size.width * 0.8, size.height * 0.475),
      framePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}