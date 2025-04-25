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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Roboto',
      ),
      home: const MetallicCubeDemo(),
    );
  }
}

class MetallicCubeDemo extends StatefulWidget {
  const MetallicCubeDemo({Key? key}) : super(key: key);

  @override
  State<MetallicCubeDemo> createState() => _MetallicCubeDemoState();
}

class _MetallicCubeDemoState extends State<MetallicCubeDemo> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late AnimationController _scaleController;

  // Animations
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  late Animation<double> _zAnimation;
  late Animation<double> _scaleAnimation;

  // Cube state
  double _cubeSize = 150.0;
  bool _isAnimating = false;
  int _demoStep = 0;
  int _tapCount = 0;

  // Demo timer
  Timer? _demoTimer;

  // Metallic colors
  final List<List<Color>> _metallicGradients = [
    [const Color(0xFFE8E8E8), const Color(0xFFBDBDBD), const Color(0xFF9E9E9E)], // Silver
    [const Color(0xFFFFD700), const Color(0xFFFFC107), const Color(0xFFFFB300)], // Gold
    [const Color(0xFFB71C1C), const Color(0xFFC62828), const Color(0xFFD32F2F)], // Ruby
    [const Color(0xFF0D47A1), const Color(0xFF1565C0), const Color(0xFF1976D2)], // Sapphire
    [const Color(0xFF1B5E20), const Color(0xFF2E7D32), const Color(0xFF388E3C)], // Emerald
  ];
  int _currentColorIndex = 0;

  // Light source position for reflection effect
  Offset _lightPosition = const Offset(100, 100);

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _yController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _zController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Initialize animations
    _xAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
        CurvedAnimation(parent: _xController, curve: Curves.easeInOutCubic)
    );

    _yAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
        CurvedAnimation(parent: _yController, curve: Curves.easeInOutCubic)
    );

    _zAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
        CurvedAnimation(parent: _zController, curve: Curves.easeInOutCubic)
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 1,
      ),
    ]).animate(_scaleController);

    // Add listeners
    _xController.addStatusListener(_onAnimationStatusChanged);
    _yController.addStatusListener(_onAnimationStatusChanged);
    _zController.addStatusListener(_onAnimationStatusChanged);

    // Start demo sequence
    _startDemoSequence();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _isAnimating = false;
      });
    }
  }

  void _startDemoSequence() {
    _demoTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      // Demo timeline for a 30-second YouTube short
      switch (timer.tick) {
        case 2: // Initial X rotation
          _rotateX();
          break;
        case 6: // Y rotation
          _rotateY();
          break;
        case 10: // Z rotation
          _rotateZ();
          break;
        case 14: // Change color and rotate X+Y
          _changeColor();
          _rotateXY();
          break;
        case 18: // Change color and rotate Y+Z
          _changeColor();
          _rotateYZ();
          break;
        case 22: // Change color and rotate X+Z
          _changeColor();
          _rotateXZ();
          break;
        case 26: // Final rotation on all axes
          _changeColor();
          _rotateXYZ();
          break;
        case 30: // Reset demo
          _resetDemo();
          break;
      }
    });
  }

  void _rotateX() {
    setState(() {
      _isAnimating = true;
      _demoStep = 1;
    });
    _xController.forward(from: 0);
  }

  void _rotateY() {
    setState(() {
      _isAnimating = true;
      _demoStep = 2;
    });
    _yController.forward(from: 0);
  }

  void _rotateZ() {
    setState(() {
      _isAnimating = true;
      _demoStep = 3;
    });
    _zController.forward(from: 0);
  }

  void _rotateXY() {
    setState(() {
      _isAnimating = true;
      _demoStep = 4;
    });
    _xController.forward(from: 0);
    _yController.forward(from: 0);
  }

  void _rotateYZ() {
    setState(() {
      _isAnimating = true;
      _demoStep = 5;
    });
    _yController.forward(from: 0);
    _zController.forward(from: 0);
  }

  void _rotateXZ() {
    setState(() {
      _isAnimating = true;
      _demoStep = 6;
    });
    _xController.forward(from: 0);
    _zController.forward(from: 0);
  }

  void _rotateXYZ() {
    setState(() {
      _isAnimating = true;
      _demoStep = 7;
    });
    _xController.forward(from: 0);
    _yController.forward(from: 0);
    _zController.forward(from: 0);
  }

  void _changeColor() {
    setState(() {
      _currentColorIndex = (_currentColorIndex + 1) % _metallicGradients.length;
    });
    _scaleController.forward(from: 0);
  }

  void _resetDemo() {
    setState(() {
      _isAnimating = false;
      _demoStep = 0;
      _currentColorIndex = 0;
    });
    _xController.reset();
    _yController.reset();
    _zController.reset();
  }

  void _handleTap() {
    if (_isAnimating) return;

    _tapCount++;
    _scaleController.forward(from: 0);

    switch (_tapCount % 7) {
      case 0:
        _rotateX();
        break;
      case 1:
        _rotateY();
        break;
      case 2:
        _rotateZ();
        break;
      case 3:
        _rotateXY();
        break;
      case 4:
        _rotateYZ();
        break;
      case 5:
        _rotateXZ();
        break;
      case 6:
        _rotateXYZ();
        _changeColor();
        break;
    }
  }

  void _updateLightPosition(Offset position) {
    setState(() {
      _lightPosition = position;
    });
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    _scaleController.dispose();
    _demoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '3D Metallic Cube',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: MouseRegion(
        onHover: (event) => _updateLightPosition(event.position),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A1A1A),
                const Color(0xFF0A0A0A),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3D Cube
                GestureDetector(
                  onTap: _handleTap,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _xController,
                      _yController,
                      _zController,
                      _scaleController,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // Perspective
                            ..rotateX(_xAnimation.value)
                            ..rotateY(_yAnimation.value)
                            ..rotateZ(_zAnimation.value),
                          child: SizedBox(
                            width: _cubeSize,
                            height: _cubeSize,
                            child: _buildCube(),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Instructions
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getInstructionText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInstructionText() {
    if (_demoStep == 0) {
      return "Tap the cube to interact";
    } else if (_demoStep <= 3) {
      return "Rotating on ${_demoStep == 1 ? 'X' : _demoStep == 2 ? 'Y' : 'Z'} axis";
    } else if (_demoStep <= 6) {
      String axes = _demoStep == 4 ? "X and Y" : _demoStep == 5 ? "Y and Z" : "X and Z";
      return "Rotating on $axes axes";
    } else {
      return "Rotating on all axes";
    }
  }

  Widget _buildCube() {
    return Stack(
      children: [
        // Front face
        _buildFace(
          rotationX: 0,
          rotationY: 0,
          translationZ: _cubeSize / 2,
          gradient: _metallicGradients[_currentColorIndex],
          faceText: "1",
        ),

        // Back face
        _buildFace(
          rotationX: 0,
          rotationY: math.pi,
          translationZ: _cubeSize / 2,
          gradient: _metallicGradients[_currentColorIndex],
          faceText: "6",
        ),

        // Right face
        _buildFace(
          rotationY: math.pi / 2,
          translationZ: _cubeSize / 2,
          gradient: _metallicGradients[_currentColorIndex],
          faceText: "2",
        ),

        // Left face
        _buildFace(
          rotationY: -math.pi / 2,
          translationZ: _cubeSize / 2,
          gradient: _metallicGradients[_currentColorIndex],
          faceText: "5",
        ),

        // Top face
        _buildFace(
          rotationX: -math.pi / 2,
          translationZ: _cubeSize / 2,
          gradient: _metallicGradients[_currentColorIndex],
          faceText: "3",
        ),

        // Bottom face
        _buildFace(
          rotationX: math.pi / 2,
          translationZ: _cubeSize / 2,
          gradient: _metallicGradients[_currentColorIndex],
          faceText: "4",
        ),
      ],
    );
  }

  Widget _buildFace({
    double rotationX = 0,
    double rotationY = 0,
    double translationZ = 0,
    required List<Color> gradient,
    required String faceText,
  }) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateX(rotationX)
        ..rotateY(rotationY)
        ..translate(0.0, 0.0, translationZ),
      child: Container(
        width: _cubeSize,
        height: _cubeSize,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: CustomPaint(
          painter: MetallicFacePainter(
            gradient: gradient,
            lightPosition: _lightPosition,
          ),
          child: Center(
            child: Text(
              faceText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 32,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MetallicFacePainter extends CustomPainter {
  final List<Color> gradient;
  final Offset lightPosition;

  MetallicFacePainter({
    required this.gradient,
    required this.lightPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Base metallic gradient
    final baseGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: gradient,
      stops: const [0.0, 0.5, 1.0],
    );

    // Draw base gradient
    final baseGradientPaint = Paint()..shader = baseGradient.createShader(rect);
    canvas.drawRect(rect, baseGradientPaint);

    // Calculate light reflection
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double maxDistance = math.sqrt(centerX * centerX + centerY * centerY);

    // Create radial gradient for light reflection
    final reflectionGradient = RadialGradient(
      center: Alignment(
        (lightPosition.dx - centerX) / centerX,
        (lightPosition.dy - centerY) / centerY,
      ),
      radius: 0.7,
      colors: [
        Colors.white.withOpacity(0.7),
        Colors.white.withOpacity(0.0),
      ],
      stops: const [0.0, 1.0],
    );

    // Draw light reflection
    final reflectionPaint = Paint()
      ..shader = reflectionGradient.createShader(rect)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(rect, reflectionPaint);

    // Add edge highlight
    final edgePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(rect.deflate(1), edgePaint);

    // Add subtle texture
    final random = math.Random(42);
    final texturePaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..strokeWidth = 0.5;

    for (int i = 0; i < 20; i++) {
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final x2 = random.nextDouble() * size.width;
      final y2 = random.nextDouble() * size.height;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), texturePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MetallicFacePainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
        oldDelegate.lightPosition != lightPosition;
  }
}