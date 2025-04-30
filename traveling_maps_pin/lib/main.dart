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
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const TravelMapDemo(),
    );
  }
}

class TravelMapDemo extends StatefulWidget {
  const TravelMapDemo({Key? key}) : super(key: key);

  @override
  State<TravelMapDemo> createState() => _TravelMapDemoState();
}

class _TravelMapDemoState extends State<TravelMapDemo> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _rippleController;
  late AnimationController _pinScaleController;
  late AnimationController _infoScaleController;

  // Animations
  late Animation<double> _rippleAnimation;
  late Animation<double> _pinScaleAnimation;
  late Animation<double> _infoScaleAnimation;

  // Map state
  int _selectedPinIndex = -1;
  bool _showInfo = false;
  int _demoStep = 0;

  // Demo timer
  Timer? _demoTimer;

  // Travel destinations
  final List<Destination> _destinations = [
    Destination(
      name: 'Paris',
      country: 'France',
      position: const Offset(0.4, 0.3),
      color: const Color(0xFFEF4444),
      rating: 4.8,
    ),
    Destination(
      name: 'Tokyo',
      country: 'Japan',
      position: const Offset(0.8, 0.4),
      color: const Color(0xFF3B82F6),
      rating: 4.9,
    ),
    Destination(
      name: 'New York',
      country: 'USA',
      position: const Offset(0.25, 0.4),
      color: const Color(0xFF10B981),
      rating: 4.7,
    ),
    Destination(
      name: 'Sydney',
      country: 'Australia',
      position: const Offset(0.85, 0.7),
      color: const Color(0xFFF59E0B),
      rating: 4.6,
    ),
    Destination(
      name: 'Cairo',
      country: 'Egypt',
      position: const Offset(0.55, 0.45),
      color: const Color(0xFF8B5CF6),
      rating: 4.5,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pinScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _infoScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize animations
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: Curves.easeOut,
      ),
    );

    _pinScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
    ]).animate(_pinScaleController);

    _infoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 1,
      ),
    ]).animate(_infoScaleController);

    // Add listeners
    _rippleController.addStatusListener(_onRippleStatusChanged);

    // Start demo sequence
    _startDemoSequence();
  }

  void _startDemoSequence() {
    _demoTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      // Demo timeline for a 30-second YouTube short
      switch (timer.tick) {
        case 2: // Select first pin
          _selectPin(0);
          break;
        case 6: // Show info card
          _showDestinationInfo();
          break;
        case 10: // Hide info and select another pin
          _hideDestinationInfo();
          Future.delayed(const Duration(milliseconds: 500), () {
            _selectPin(1);
          });
          break;
        case 14: // Show info card
          _showDestinationInfo();
          break;
        case 18: // Hide info and select another pin
          _hideDestinationInfo();
          Future.delayed(const Duration(milliseconds: 500), () {
            _selectPin(3);
          });
          break;
        case 22: // Show info card
          _showDestinationInfo();
          break;
        case 26: // Reset demo
          _hideDestinationInfo();
          Future.delayed(const Duration(milliseconds: 500), () {
            _resetDemo();
          });
          break;
      }
    });
  }

  void _onRippleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _rippleController.reset();
      if (_selectedPinIndex != -1) {
        _rippleController.forward();
      }
    }
  }

  void _selectPin(int index) {
    setState(() {
      _selectedPinIndex = index;
      _demoStep = 1;
    });

    _pinScaleController.forward(from: 0);
    _rippleController.forward(from: 0);
  }

  void _showDestinationInfo() {
    setState(() {
      _showInfo = true;
      _demoStep = 2;
    });

    _infoScaleController.forward(from: 0);
  }

  void _hideDestinationInfo() {
    setState(() {
      _showInfo = false;
      _demoStep = 1;
    });
  }

  void _resetDemo() {
    setState(() {
      _selectedPinIndex = -1;
      _showInfo = false;
      _demoStep = 0;
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _pinScaleController.dispose();
    _infoScaleController.dispose();
    _demoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map background with custom painter
          Positioned.fill(
            child: CustomPaint(
              painter: MapBackgroundPainter(),
            ),
          ),

          // App bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {},
                    ),
                    const Expanded(
                      child: Text(
                        'Explore Destinations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Map pins
          ..._buildMapPins(),

          // Selected destination info card
          if (_showInfo && _selectedPinIndex != -1)
            _buildDestinationInfoCard(),

          // Bottom navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.explore, 'Explore', isSelected: true),
                  _buildNavItem(Icons.favorite_border, 'Saved'),
                  _buildNavItem(Icons.notifications_none, 'Alerts'),
                  _buildNavItem(Icons.person_outline, 'Profile'),
                ],
              ),
            ),
          ),

          // Instructions
          if (_demoStep == 0)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Tap on a destination pin to explore',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildMapPins() {
    List<Widget> pins = [];

    for (int i = 0; i < _destinations.length; i++) {
      final destination = _destinations[i];
      final isSelected = _selectedPinIndex == i;

      // Add ripple effect for selected pin
      if (isSelected) {
        pins.add(
          Positioned(
            left: destination.position.dx * MediaQuery.of(context).size.width - 50,
            top: destination.position.dy * MediaQuery.of(context).size.height - 50,
            child: AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: RipplePainter(
                    color: destination.color,
                    progress: _rippleAnimation.value,
                  ),
                  size: const Size(100, 100),
                );
              },
            ),
          ),
        );
      }

      // Add pin
      pins.add(
        Positioned(
          left: destination.position.dx * MediaQuery.of(context).size.width - 15,
          top: destination.position.dy * MediaQuery.of(context).size.height - 30,
          child: GestureDetector(
            onTap: () {
              if (_selectedPinIndex == i) {
                if (_showInfo) {
                  _hideDestinationInfo();
                } else {
                  _showDestinationInfo();
                }
              } else {
                _hideDestinationInfo();
                _selectPin(i);
              }
            },
            child: AnimatedBuilder(
              animation: _pinScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isSelected ? _pinScaleAnimation.value : 1.0,
                  child: child,
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: destination.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: destination.color.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        destination.name,
                        style: TextStyle(
                          color: destination.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return pins;
  }

  Widget _buildDestinationInfoCard() {
    final destination = _destinations[_selectedPinIndex];

    return Positioned(
      bottom: 100,
      left: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _infoScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _infoScaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Destination image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: destination.color.withOpacity(0.2),
                      child: CustomPaint(
                        painter: DestinationImagePainter(
                          name: destination.name,
                          color: destination.color,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFC107),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            destination.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Destination details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  destination.country,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: destination.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: destination.color,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Quick info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(Icons.wb_sunny_outlined, 'Weather', '24°C'),
                        _buildInfoItem(Icons.access_time, 'Time', 'GMT+1'),
                        _buildInfoItem(Icons.language, 'Language', 'Local'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: destination.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Explore Destination',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[600],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[600],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class RipplePainter extends CustomPainter {
  final Color color;
  final double progress;

  RipplePainter({
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw multiple ripple circles
    for (int i = 0; i < 3; i++) {
      final rippleProgress = (progress - (i * 0.2)).clamp(0.0, 1.0);
      if (rippleProgress <= 0) continue;

      final radius = rippleProgress * size.width / 2;
      final opacity = (1 - rippleProgress) * 0.4;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);

    // Draw continents
    final continentPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.fill;

    // North America
    final northAmerica = Path()
      ..moveTo(size.width * 0.1, size.height * 0.2)
      ..lineTo(size.width * 0.3, size.height * 0.2)
      ..lineTo(size.width * 0.35, size.height * 0.4)
      ..lineTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.1, size.height * 0.3)
      ..close();

    // South America
    final southAmerica = Path()
      ..moveTo(size.width * 0.25, size.height * 0.5)
      ..lineTo(size.width * 0.3, size.height * 0.5)
      ..lineTo(size.width * 0.3, size.height * 0.7)
      ..lineTo(size.width * 0.2, size.height * 0.7)
      ..close();

    // Europe
    final europe = Path()
      ..moveTo(size.width * 0.45, size.height * 0.2)
      ..lineTo(size.width * 0.55, size.height * 0.2)
      ..lineTo(size.width * 0.55, size.height * 0.35)
      ..lineTo(size.width * 0.45, size.height * 0.35)
      ..close();

    // Africa
    final africa = Path()
      ..moveTo(size.width * 0.45, size.height * 0.35)
      ..lineTo(size.width * 0.6, size.height * 0.35)
      ..lineTo(size.width * 0.55, size.height * 0.6)
      ..lineTo(size.width * 0.4, size.height * 0.6)
      ..close();

    // Asia
    final asia = Path()
      ..moveTo(size.width * 0.55, size.height * 0.2)
      ..lineTo(size.width * 0.85, size.height * 0.2)
      ..lineTo(size.width * 0.85, size.height * 0.5)
      ..lineTo(size.width * 0.6, size.height * 0.5)
      ..lineTo(size.width * 0.55, size.height * 0.35)
      ..close();

    // Australia
    final australia = Path()
      ..moveTo(size.width * 0.75, size.height * 0.55)
      ..lineTo(size.width * 0.9, size.height * 0.55)
      ..lineTo(size.width * 0.9, size.height * 0.7)
      ..lineTo(size.width * 0.75, size.height * 0.7)
      ..close();

    canvas.drawPath(northAmerica, continentPaint);
    canvas.drawPath(southAmerica, continentPaint);
    canvas.drawPath(europe, continentPaint);
    canvas.drawPath(africa, continentPaint);
    canvas.drawPath(asia, continentPaint);
    canvas.drawPath(australia, continentPaint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Horizontal grid lines
    for (int i = 0; i < 10; i++) {
      final y = size.height * i / 10;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Vertical grid lines
    for (int i = 0; i < 10; i++) {
      final x = size.width * i / 10;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DestinationImagePainter extends CustomPainter {
  final String name;
  final Color color;

  DestinationImagePainter({
    required this.name,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final bgPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, bgPaint);

    // Draw destination name
    final textPainter = TextPainter(
      text: TextSpan(
        text: name,
        style: TextStyle(
          color: color,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    // Draw decorative elements based on destination
    final decorPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final random = math.Random(name.hashCode);

    for (int i = 0; i < 5; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 5 + random.nextDouble() * 15;

      canvas.drawCircle(Offset(x, y), radius, decorPaint);
    }

    // Draw icon based on destination
    IconData icon;
    switch (name) {
      case 'Paris':
        icon = Icons.architecture;
        break;
      case 'Tokyo':
        icon = Icons.temple_buddhist;
        break;
      case 'New York':
        icon = Icons.location_city;
        break;
      case 'Sydney':
        icon = Icons.waves;
        break;
      case 'Cairo':
        icon = Icons.landscape;
        break;
      default:
        icon = Icons.place;
    }

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: color.withOpacity(0.2),
          fontSize: 80,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        (size.width - iconPainter.width) / 2,
        size.height * 0.6,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant DestinationImagePainter oldDelegate) {
    return oldDelegate.name != name || oldDelegate.color != color;
  }
}

class Destination {
  final String name;
  final String country;
  final Offset position;
  final Color color;
  final double rating;

  Destination({
    required this.name,
    required this.country,
    required this.position,
    required this.color,
    required this.rating,
  });
}