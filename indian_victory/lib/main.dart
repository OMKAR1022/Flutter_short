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
        brightness: Brightness.light,
        primaryColor: const Color(0xFFFF9933), // Saffron color
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MilitaryCelebrationScreen(),
    );
  }
}

class MilitaryCelebrationScreen extends StatefulWidget {
  const MilitaryCelebrationScreen({Key? key}) : super(key: key);

  @override
  State<MilitaryCelebrationScreen> createState() => _MilitaryCelebrationScreenState();
}

class _MilitaryCelebrationScreenState extends State<MilitaryCelebrationScreen> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _flagWaveController;
  late AnimationController _soldierMarchController;
  late AnimationController _aircraftController;
  late AnimationController _cloudController;
  late AnimationController _smokeTrailController;
  late AnimationController _demoController;

  // Animations
  late Animation<double> _flagWaveAnimation;
  late Animation<double> _soldierMarchAnimation;
  late Animation<double> _aircraftAnimation;
  late Animation<double> _smokeTrailAnimation;

  // Demo step
  int _demoStep = 0;

  // Aircraft positions
  List<AircraftData> _aircraft = [];

  @override
  void initState() {
    super.initState();

    // Initialize aircraft data
    _aircraft = [
      AircraftData(
        initialPosition: const Offset(-0.2, 0.2),
        finalPosition: const Offset(1.2, 0.15),
        scale: 1.0,
        smokeColor: const Color(0xFFFF9933), // Saffron
      ),
      AircraftData(
        initialPosition: const Offset(-0.3, 0.25),
        finalPosition: const Offset(1.3, 0.2),
        scale: 0.9,
        smokeColor: Colors.white,
      ),
      AircraftData(
        initialPosition: const Offset(-0.1, 0.3),
        finalPosition: const Offset(1.1, 0.25),
        scale: 1.1,
        smokeColor: const Color(0xFF138808), // Green
      ),
    ];

    // Flag wave animation
    _flagWaveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _flagWaveAnimation = CurvedAnimation(
      parent: _flagWaveController,
      curve: Curves.easeInOut,
    );

    // Soldier march animation
    _soldierMarchController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _soldierMarchAnimation = Tween<double>(
      begin: -0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _soldierMarchController,
      curve: Curves.easeInOut,
    ));

    // Aircraft animation
    _aircraftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _aircraftAnimation = CurvedAnimation(
      parent: _aircraftController,
      curve: Curves.linear,
    );

    // Cloud animation
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Smoke trail animation
    _smokeTrailController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _smokeTrailAnimation = CurvedAnimation(
      parent: _smokeTrailController,
      curve: Curves.linear,
    );

    // Demo controller for automated demo
    _demoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..forward();

    _demoController.addListener(_handleDemoProgress);
  }

  void _handleDemoProgress() {
    // Demo timeline for a 30-second YouTube short
    final progress = _demoController.value;

    if (progress < 0.1 && _demoStep == 0) {
      // Start flag waving
      _flagWaveController.repeat();
      setState(() {
        _demoStep = 1;
      });
    } else if (progress >= 0.1 && progress < 0.3 && _demoStep == 1) {
      // Start soldiers marching in
      _soldierMarchController.forward();
      setState(() {
        _demoStep = 2;
      });
    } else if (progress >= 0.3 && progress < 0.7 && _demoStep == 2) {
      // Aircraft flyby
      _aircraftController.forward();
      setState(() {
        _demoStep = 3;
      });
    } else if (progress >= 0.9 && _demoStep == 3) {
      // Reset for loop
      _soldierMarchController.reset();
      _aircraftController.reset();
      setState(() {
        _demoStep = 0;
        _demoController.reset();
        _demoController.forward();
      });
    }
  }

  @override
  void dispose() {
    _flagWaveController.dispose();
    _soldierMarchController.dispose();
    _aircraftController.dispose();
    _cloudController.dispose();
    _smokeTrailController.dispose();
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Sky background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.lightBlue.shade300,
                  Colors.lightBlue.shade100,
                ],
              ),
            ),
          ),

          // Clouds
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              return CustomPaint(
                painter: CloudPainter(
                  animation: _cloudController.value,
                ),
                size: Size(size.width, size.height),
              );
            },
          ),

          // Sun
          Positioned(
            top: size.height * 0.1,
            right: size.width * 0.1,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow,
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          // Mountains
          Positioned(
            bottom: size.height * 0.28,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: MountainPainter(),
              size: Size(size.width, size.height * 0.3),
            ),
          ),

          // Ground
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.3,
            child: CustomPaint(
              painter: TerrainPainter(),
              size: Size(size.width, size.height * 0.3),
            ),
          ),

          // Flag pole
          Positioned(
            top: size.height * 0.2,
            left: size.width * 0.1,
            child: Container(
              width: 8,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.brown.shade800,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),

          // Indian Flag
          Positioned(
            top: size.height * 0.2,
            left: size.width * 0.108,
            child: AnimatedBuilder(
              animation: _flagWaveAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: IndianFlagPainter(
                    wavePhase: _flagWaveAnimation.value,
                  ),
                  size: Size(size.width * 0.4, size.height * 0.25),
                );
              },
            ),
          ),

          // Soldiers
          AnimatedBuilder(
            animation: _soldierMarchAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: size.height * 0.05,
                left: size.width * _soldierMarchAnimation.value,
                child: Row(
                  children: [
                    _buildSoldier(0, _soldierMarchAnimation.value),
                    SizedBox(width: size.width * 0.05),
                    _buildSoldier(1, _soldierMarchAnimation.value),
                    SizedBox(width: size.width * 0.05),
                    _buildSoldier(2, _soldierMarchAnimation.value),
                    SizedBox(width: size.width * 0.05),
                    _buildSoldier(3, _soldierMarchAnimation.value),
                    SizedBox(width: size.width * 0.05),
                    _buildSoldier(4, _soldierMarchAnimation.value),
                  ],
                ),
              );
            },
          ),

          // Aircraft
          AnimatedBuilder(
            animation: _aircraftAnimation,
            builder: (context, child) {
              return Stack(
                children: _aircraft.map((aircraft) {
                  final position = Offset.lerp(
                    Offset(
                      size.width * aircraft.initialPosition.dx,
                      size.height * aircraft.initialPosition.dy,
                    ),
                    Offset(
                      size.width * aircraft.finalPosition.dx,
                      size.height * aircraft.finalPosition.dy,
                    ),
                    _aircraftAnimation.value,
                  )!;

                  return Positioned(
                    left: position.dx - 50 * aircraft.scale,
                    top: position.dy - 25 * aircraft.scale,
                    child: Stack(
                      children: [
                        // Smoke trail
                        if (_aircraftAnimation.value > 0.05)
                          Positioned(
                            right: 0,
                            top: 20 * aircraft.scale,
                            child: CustomPaint(
                              painter: SmokeTrailPainter(
                                animation: _smokeTrailAnimation.value,
                                progress: _aircraftAnimation.value,
                                color: aircraft.smokeColor,
                              ),
                              size: Size(size.width * 0.3, 20 * aircraft.scale),
                            ),
                          ),

                        // Aircraft
                        Transform.scale(
                          scale: aircraft.scale,
                          child: CustomPaint(
                            painter: AircraftPainter(),
                            size: const Size(100, 50),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // Jai Hind text
          Positioned(
            bottom: size.height * 0.35,
            right: size.width * 0.1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF138808), // India green
                  width: 2,
                ),
              ),
              child: const Text(
                "जय हिन्द! 🇮🇳",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000080), // Navy blue
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoldier(int index, double marchProgress) {
    final isMiddle = index == 2;
    final marchPhase = (marchProgress * 5 + index * 0.2) % 1.0;

    return Container(
      width: 60,
      height: 120,
      child: CustomPaint(
        painter: SoldierPainter(
          marchPhase: marchPhase,
          holdingFlag: isMiddle,
          index: index,
        ),
      ),
    );
  }
}

class AircraftData {
  final Offset initialPosition;
  final Offset finalPosition;
  final double scale;
  final Color smokeColor;

  AircraftData({
    required this.initialPosition,
    required this.finalPosition,
    required this.scale,
    required this.smokeColor,
  });
}

class IndianFlagPainter extends CustomPainter {
  final double wavePhase;

  IndianFlagPainter({required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final stripeHeight = height / 3;

    // Define colors
    final saffron = const Color(0xFFFF9933);
    final white = Colors.white;
    final green = const Color(0xFF138808);
    final navy = const Color(0xFF000080);

    // Create wave path with more realistic physics
    final path = Path();
    path.moveTo(0, 0);

    for (double x = 0; x < width; x++) {
      // Create wave effect with multiple frequencies for realism
      final waveHeight =
          math.sin((x / width * 4 * math.pi) + (wavePhase * 2 * math.pi)) * 5 +
              math.sin((x / width * 8 * math.pi) + (wavePhase * 3 * math.pi)) * 2;
      path.lineTo(x, waveHeight);
    }

    path.lineTo(width, 0);
    path.lineTo(width, height);

    for (double x = width; x > 0; x--) {
      final waveHeight =
          math.sin((x / width * 4 * math.pi) + (wavePhase * 2 * math.pi)) * 5 +
              math.sin((x / width * 8 * math.pi) + (wavePhase * 3 * math.pi)) * 2 + height;
      path.lineTo(x, waveHeight);
    }

    path.lineTo(0, height);
    path.close();

    // Draw saffron stripe
    final saffronPaint = Paint()..color = saffron;
    final saffronPath = Path()..addPath(path, Offset.zero);
    saffronPath.addRect(Rect.fromLTWH(0, stripeHeight, width, height));
    canvas.drawPath(Path.combine(PathOperation.difference, saffronPath, Path()..addRect(Rect.fromLTWH(0, stripeHeight, width, height))), saffronPaint);

    // Draw white stripe
    final whitePaint = Paint()..color = white;
    final whitePath = Path()..addPath(path, Offset.zero);
    whitePath.addRect(Rect.fromLTWH(0, 0, width, stripeHeight));
    whitePath.addRect(Rect.fromLTWH(0, stripeHeight * 2, width, stripeHeight));
    canvas.drawPath(Path.combine(PathOperation.difference, whitePath, Path()..addRect(Rect.fromLTWH(0, 0, width, stripeHeight))..addRect(Rect.fromLTWH(0, stripeHeight * 2, width, stripeHeight))), whitePaint);

    // Draw green stripe
    final greenPaint = Paint()..color = green;
    final greenPath = Path()..addPath(path, Offset.zero);
    greenPath.addRect(Rect.fromLTWH(0, 0, width, stripeHeight * 2));
    canvas.drawPath(Path.combine(PathOperation.difference, greenPath, Path()..addRect(Rect.fromLTWH(0, 0, width, stripeHeight * 2))), greenPaint);

    // Draw Ashoka Chakra
    final chakraCenter = Offset(width * 0.5, height * 0.5);
    final chakraRadius = stripeHeight * 0.4;

    final chakraPaint = Paint()
      ..color = navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(chakraCenter, chakraRadius, chakraPaint);

    // Draw 24 spokes of the Ashoka Chakra
    for (int i = 0; i < 24; i++) {
      final angle = i * (2 * math.pi / 24);
      final innerPoint = Offset(
        chakraCenter.dx + chakraRadius * 0.7 * math.cos(angle),
        chakraCenter.dy + chakraRadius * 0.7 * math.sin(angle),
      );
      final outerPoint = Offset(
        chakraCenter.dx + chakraRadius * math.cos(angle),
        chakraCenter.dy + chakraRadius * math.sin(angle),
      );

      canvas.drawLine(innerPoint, outerPoint, chakraPaint);
    }
  }

  @override
  bool shouldRepaint(covariant IndianFlagPainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase;
  }
}

class SoldierPainter extends CustomPainter {
  final double marchPhase;
  final bool holdingFlag;
  final int index;

  SoldierPainter({
    required this.marchPhase,
    required this.holdingFlag,
    required this.index,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Define colors
    final uniformColor = const Color(0xFF2D4739); // Olive green for military uniform
    final skinColor = const Color(0xFFE6C7A5); // Skin tone
    final bootColor = Colors.black;
    final beltColor = Colors.brown.shade800;

    final paint = Paint()
      ..color = uniformColor
      ..style = PaintingStyle.fill;

    // Draw head
    final headCenter = Offset(width * 0.5, height * 0.2);
    final headRadius = width * 0.2;
    final headPaint = Paint()..color = skinColor;
    canvas.drawCircle(headCenter, headRadius, headPaint);

    // Draw helmet
    final helmetPath = Path();
    helmetPath.moveTo(width * 0.3, height * 0.2);
    helmetPath.quadraticBezierTo(width * 0.5, height * 0.05, width * 0.7, height * 0.2);
    helmetPath.quadraticBezierTo(width * 0.5, height * 0.25, width * 0.3, height * 0.2);
    canvas.drawPath(helmetPath, paint);

    // Draw face features
    final facePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Eyes
    canvas.drawLine(
      Offset(width * 0.45, height * 0.18),
      Offset(width * 0.45, height * 0.19),
      facePaint,
    );
    canvas.drawLine(
      Offset(width * 0.55, height * 0.18),
      Offset(width * 0.55, height * 0.19),
      facePaint,
    );

    // Mouth
    canvas.drawLine(
      Offset(width * 0.45, height * 0.23),
      Offset(width * 0.55, height * 0.23),
      facePaint,
    );

    // Draw body with marching animation
    final bodyPath = Path();
    bodyPath.moveTo(width * 0.4, height * 0.3);
    bodyPath.lineTo(width * 0.6, height * 0.3);
    bodyPath.lineTo(width * 0.55, height * 0.6);
    bodyPath.lineTo(width * 0.45, height * 0.6);
    bodyPath.close();
    canvas.drawPath(bodyPath, paint);

    // Draw belt
    final beltPath = Path();
    beltPath.moveTo(width * 0.4, height * 0.45);
    beltPath.lineTo(width * 0.6, height * 0.45);
    beltPath.lineTo(width * 0.59, height * 0.48);
    beltPath.lineTo(width * 0.41, height * 0.48);
    beltPath.close();

    final beltPaint = Paint()..color = beltColor;
    canvas.drawPath(beltPath, beltPaint);

    // Draw legs with marching animation
    final legPaint = Paint()..color = uniformColor;

    // Calculate leg positions based on march phase
    final leftLegAngle = math.sin(marchPhase * 2 * math.pi) * 0.2;
    final rightLegAngle = math.sin((marchPhase + 0.5) * 2 * math.pi) * 0.2;

    // Left leg
    final leftLegPath = Path();
    leftLegPath.moveTo(width * 0.45, height * 0.6);

    final leftKneeX = width * 0.45 + math.sin(leftLegAngle) * width * 0.1;
    final leftKneeY = height * 0.75 - math.cos(leftLegAngle).abs() * height * 0.05;

    leftLegPath.lineTo(leftKneeX, leftKneeY);
    leftLegPath.lineTo(leftKneeX + width * 0.05, leftKneeY);
    leftLegPath.lineTo(width * 0.5, height * 0.6);
    leftLegPath.close();
    canvas.drawPath(leftLegPath, legPaint);

    // Left boot
    final leftBootPath = Path();
    leftBootPath.moveTo(leftKneeX, leftKneeY);
    leftBootPath.lineTo(leftKneeX - width * 0.05, height * 0.9);
    leftBootPath.lineTo(leftKneeX + width * 0.1, height * 0.9);
    leftBootPath.lineTo(leftKneeX + width * 0.05, leftKneeY);
    leftBootPath.close();
    canvas.drawPath(leftBootPath, Paint()..color = bootColor);

    // Right leg
    final rightLegPath = Path();
    rightLegPath.moveTo(width * 0.5, height * 0.6);

    final rightKneeX = width * 0.55 + math.sin(rightLegAngle) * width * 0.1;
    final rightKneeY = height * 0.75 - math.cos(rightLegAngle).abs() * height * 0.05;

    rightLegPath.lineTo(rightKneeX, rightKneeY);
    rightLegPath.lineTo(rightKneeX + width * 0.05, rightKneeY);
    rightLegPath.lineTo(width * 0.55, height * 0.6);
    rightLegPath.close();
    canvas.drawPath(rightLegPath, legPaint);

    // Right boot
    final rightBootPath = Path();
    rightBootPath.moveTo(rightKneeX, rightKneeY);
    rightBootPath.lineTo(rightKneeX - width * 0.05, height * 0.9);
    rightBootPath.lineTo(rightKneeX + width * 0.1, height * 0.9);
    rightBootPath.lineTo(rightKneeX + width * 0.05, rightKneeY);
    rightBootPath.close();
    canvas.drawPath(rightBootPath, Paint()..color = bootColor);

    // Draw arms based on marching and flag holding
    final armPaint = Paint()..color = uniformColor;

    // Left arm with swing animation
    final leftArmSwing = math.sin((marchPhase + 0.5) * 2 * math.pi) * 0.3;
    final leftArmPath = Path();
    leftArmPath.moveTo(width * 0.4, height * 0.3);

    final leftElbowX = width * 0.3 + math.sin(leftArmSwing) * width * 0.1;
    final leftElbowY = height * 0.4 - math.cos(leftArmSwing).abs() * height * 0.05;

    leftArmPath.lineTo(leftElbowX, leftElbowY);
    leftArmPath.lineTo(leftElbowX + width * 0.05, leftElbowY + height * 0.05);
    leftArmPath.lineTo(width * 0.45, height * 0.35);
    leftArmPath.close();
    canvas.drawPath(leftArmPath, armPaint);

    // Right arm with swing animation or flag holding
    if (holdingFlag) {
      // Holding flag position - right arm up
      final rightArmUpPath = Path();
      rightArmUpPath.moveTo(width * 0.6, height * 0.3);
      rightArmUpPath.lineTo(width * 0.7, height * 0.2);
      rightArmUpPath.lineTo(width * 0.65, height * 0.15);
      rightArmUpPath.lineTo(width * 0.55, height * 0.25);
      rightArmUpPath.close();
      canvas.drawPath(rightArmUpPath, armPaint);

      // Draw small flag
      final flagPaint = Paint()..color = const Color(0xFFFF9933); // Saffron
      final flagPath = Path();
      flagPath.moveTo(width * 0.7, height * 0.2);
      flagPath.lineTo(width * 0.9, height * 0.15);
      flagPath.lineTo(width * 0.9, height * 0.25);
      flagPath.lineTo(width * 0.7, height * 0.3);
      flagPath.close();
      canvas.drawPath(flagPath, flagPaint);
    } else {
      // Normal marching arm swing
      final rightArmSwing = math.sin(marchPhase * 2 * math.pi) * 0.3;
      final rightArmPath = Path();
      rightArmPath.moveTo(width * 0.6, height * 0.3);

      final rightElbowX = width * 0.7 + math.sin(rightArmSwing) * width * 0.1;
      final rightElbowY = height * 0.4 - math.cos(rightArmSwing).abs() * height * 0.05;

      rightArmPath.lineTo(rightElbowX, rightElbowY);
      rightArmPath.lineTo(rightElbowX - width * 0.05, rightElbowY + height * 0.05);
      rightArmPath.lineTo(width * 0.55, height * 0.35);
      rightArmPath.close();
      canvas.drawPath(rightArmPath, armPaint);
    }

    // Draw rifle for soldiers not holding flag
    if (!holdingFlag && index % 2 == 0) {
      final riflePaint = Paint()..color = Colors.brown.shade900;

      final rifleAngle = leftArmSwing * 0.5;
      final rifleStartX = leftElbowX;
      final rifleStartY = leftElbowY;
      final rifleEndX = rifleStartX - math.cos(rifleAngle) * width * 0.4;
      final rifleEndY = rifleStartY + math.sin(rifleAngle) * width * 0.4;

      // Rifle body
      canvas.drawLine(
        Offset(rifleStartX, rifleStartY),
        Offset(rifleEndX, rifleEndY),
        riflePaint..strokeWidth = 3,
      );

      // Rifle stock
      final stockPath = Path();
      stockPath.moveTo(rifleStartX, rifleStartY);
      stockPath.lineTo(rifleStartX + width * 0.05, rifleStartY - height * 0.02);
      stockPath.lineTo(rifleStartX + width * 0.08, rifleStartY + height * 0.05);
      stockPath.lineTo(rifleStartX, rifleStartY + height * 0.03);
      stockPath.close();
      canvas.drawPath(stockPath, riflePaint);
    }
  }

  @override
  bool shouldRepaint(covariant SoldierPainter oldDelegate) {
    return oldDelegate.marchPhase != marchPhase ||
        oldDelegate.holdingFlag != holdingFlag ||
        oldDelegate.index != index;
  }
}

class AircraftPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Define colors
    final bodyColor = const Color(0xFF4A4A4A); // Aircraft body color
    final cockpitColor = Colors.lightBlueAccent.withOpacity(0.7); // Cockpit glass
    final wingColor = const Color(0xFF5A5A5A); // Wing color

    // Body paint
    final bodyPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    // Cockpit paint
    final cockpitPaint = Paint()
      ..color = cockpitColor
      ..style = PaintingStyle.fill;

    // Wing paint
    final wingPaint = Paint()
      ..color = wingColor
      ..style = PaintingStyle.fill;

    // Draw aircraft body
    final bodyPath = Path();
    bodyPath.moveTo(width * 0.1, height * 0.5);
    bodyPath.quadraticBezierTo(width * 0.2, height * 0.3, width * 0.5, height * 0.3);
    bodyPath.quadraticBezierTo(width * 0.8, height * 0.3, width * 0.9, height * 0.4);
    bodyPath.quadraticBezierTo(width * 0.8, height * 0.7, width * 0.5, height * 0.7);
    bodyPath.quadraticBezierTo(width * 0.2, height * 0.7, width * 0.1, height * 0.5);
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Draw cockpit
    final cockpitPath = Path();
    cockpitPath.moveTo(width * 0.7, height * 0.4);
    cockpitPath.quadraticBezierTo(width * 0.8, height * 0.3, width * 0.85, height * 0.4);
    cockpitPath.quadraticBezierTo(width * 0.8, height * 0.5, width * 0.7, height * 0.4);
    cockpitPath.close();
    canvas.drawPath(cockpitPath, cockpitPaint);

    // Draw wings
    final wingPath = Path();
    wingPath.moveTo(width * 0.4, height * 0.4);
    wingPath.lineTo(width * 0.2, height * 0.1);
    wingPath.lineTo(width * 0.5, height * 0.1);
    wingPath.lineTo(width * 0.6, height * 0.4);
    wingPath.close();
    canvas.drawPath(wingPath, wingPaint);

    // Draw tail wings
    final tailWingPath = Path();
    tailWingPath.moveTo(width * 0.2, height * 0.5);
    tailWingPath.lineTo(width * 0.1, height * 0.2);
    tailWingPath.lineTo(width * 0.3, height * 0.3);
    tailWingPath.lineTo(width * 0.3, height * 0.5);
    tailWingPath.close();
    canvas.drawPath(tailWingPath, wingPaint);

    // Draw vertical stabilizer
    final verticalStabilizerPath = Path();
    verticalStabilizerPath.moveTo(width * 0.2, height * 0.5);
    verticalStabilizerPath.lineTo(width * 0.1, height * 0.1);
    verticalStabilizerPath.lineTo(width * 0.3, height * 0.3);
    verticalStabilizerPath.close();
    canvas.drawPath(verticalStabilizerPath, wingPaint);

    // Draw details - engine
    final enginePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(width * 0.3, height * 0.6),
      width * 0.05,
      enginePaint,
    );

    // Draw Indian Air Force markings
    final markingPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(width * 0.5, height * 0.5),
      width * 0.05,
      markingPaint,
    );

    final innerCirclePaint = Paint()
      ..color = const Color(0xFF138808) // Green
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(width * 0.5, height * 0.5),
      width * 0.03,
      innerCirclePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SmokeTrailPainter extends CustomPainter {
  final double animation;
  final double progress;
  final Color color;

  SmokeTrailPainter({
    required this.animation,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Calculate trail length based on aircraft progress
    final trailLength = width * math.min(progress, 0.5);

    // Create gradient for smoke trail
    final smokePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(0.8),
          color.withOpacity(0.5),
          color.withOpacity(0.2),
          color.withOpacity(0.0),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, trailLength, height));

    // Create path for smoke trail
    final path = Path();
    path.moveTo(0, height / 2);

    // Add wavy pattern to smoke trail
    for (double x = 0; x < trailLength; x += 5) {
      final waveHeight = math.sin((x / 20) + (animation * 10)) * (height / 4);
      final y = (height / 2) + waveHeight;
      path.lineTo(x, y);
    }

    // Complete the path
    path.lineTo(trailLength, height / 2);

    // Draw the smoke trail
    canvas.drawPath(path, smokePaint);
  }

  @override
  bool shouldRepaint(covariant SmokeTrailPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}

class CloudPainter extends CustomPainter {
  final double animation;

  CloudPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Draw multiple clouds at different positions
    _drawCloud(canvas, Offset(width * (0.1 + animation * 0.1) % 1.1 - 0.1, height * 0.15), width * 0.2, cloudPaint);
    _drawCloud(canvas, Offset(width * (0.5 + animation * 0.05) % 1.1 - 0.1, height * 0.1), width * 0.25, cloudPaint);
    _drawCloud(canvas, Offset(width * (0.8 + animation * 0.08) % 1.1 - 0.1, height * 0.2), width * 0.18, cloudPaint);
    _drawCloud(canvas, Offset(width * (0.3 + animation * 0.07) % 1.1 - 0.1, height * 0.25), width * 0.15, cloudPaint);
  }

  void _drawCloud(Canvas canvas, Offset position, double size, Paint paint) {
    canvas.drawCircle(position, size * 0.5, paint);
    canvas.drawCircle(Offset(position.dx + size * 0.4, position.dy), size * 0.4, paint);
    canvas.drawCircle(Offset(position.dx + size * 0.8, position.dy + size * 0.1), size * 0.45, paint);
    canvas.drawCircle(Offset(position.dx + size * 0.4, position.dy + size * 0.2), size * 0.35, paint);
    canvas.drawCircle(Offset(position.dx + size * 0.1, position.dy + size * 0.15), size * 0.3, paint);
  }

  @override
  bool shouldRepaint(covariant CloudPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Create mountain ranges with different shades
    _drawMountainRange(canvas, size, 0.0, Colors.grey.shade800);
    _drawMountainRange(canvas, size, 0.1, Colors.grey.shade700);
    _drawMountainRange(canvas, size, 0.2, Colors.grey.shade600);
  }

  void _drawMountainRange(Canvas canvas, Size size, double offset, Color color) {
    final width = size.width;
    final height = size.height;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start at bottom left
    path.moveTo(0, height);

    // Create a series of mountain peaks
    double x = 0;
    while (x < width) {
      final peakHeight = height * (0.3 + math.Random(42 + x.toInt()).nextDouble() * 0.7);
      final peakWidth = width * (0.1 + math.Random(142 + x.toInt()).nextDouble() * 0.1);

      path.lineTo(x + peakWidth / 2, height - peakHeight);
      path.lineTo(x + peakWidth, height - peakHeight * 0.7);

      x += peakWidth;
    }

    // Ensure we reach the right edge
    path.lineTo(width, height - height * 0.2);
    path.lineTo(width, height);
    path.close();

    canvas.drawPath(path, paint);

    // Add snow caps to the mountains
    final snowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final random = math.Random(42);

    for (int i = 0; i < 5; i++) {
      final snowX = width * random.nextDouble();
      final snowY = height * (0.2 + random.nextDouble() * 0.3);
      final snowWidth = width * (0.05 + random.nextDouble() * 0.05);

      final snowPath = Path();
      snowPath.moveTo(snowX, height - snowY);
      snowPath.lineTo(snowX + snowWidth / 2, height - snowY - snowWidth * 0.3);
      snowPath.lineTo(snowX + snowWidth, height - snowY);
      snowPath.close();

      canvas.drawPath(snowPath, snowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TerrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Base terrain
    final terrainPaint = Paint()
      ..color = Colors.green.shade800
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), terrainPaint);

    // Add terrain details - grass patches
    final grassPaint = Paint()
      ..color = Colors.green.shade600
      ..style = PaintingStyle.fill;

    final random = math.Random(42);

    for (int i = 0; i < 30; i++) {
      final x = width * random.nextDouble();
      final y = height * random.nextDouble();
      final size = width * (0.05 + random.nextDouble() * 0.05);

      canvas.drawCircle(Offset(x, y), size, grassPaint);
    }

    // Add terrain details - small rocks
    final rockPaint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 15; i++) {
      final x = width * random.nextDouble();
      final y = height * random.nextDouble();
      final size = width * (0.01 + random.nextDouble() * 0.02);

      canvas.drawCircle(Offset(x, y), size, rockPaint);
    }

    // Add a road or path
    final roadPaint = Paint()
      ..color = Colors.brown.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.02;

    final roadPath = Path();
    roadPath.moveTo(width * 0.1, height * 0.8);
    roadPath.quadraticBezierTo(width * 0.3, height * 0.7, width * 0.5, height * 0.8);
    roadPath.quadraticBezierTo(width * 0.7, height * 0.9, width * 0.9, height * 0.7);

    canvas.drawPath(roadPath, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}