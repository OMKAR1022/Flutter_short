import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

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
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const BounceNavBarDemo(),
    );
  }
}

class BounceNavBarDemo extends StatefulWidget {
  const BounceNavBarDemo({Key? key}) : super(key: key);

  @override
  State<BounceNavBarDemo> createState() => _BounceNavBarDemoState();
}

class _BounceNavBarDemoState extends State<BounceNavBarDemo> with TickerProviderStateMixin {
  // Navigation items
  final List<NavItem> _items = [
    NavItem(icon: Icons.home_rounded, label: 'Home'),
    NavItem(icon: Icons.search_rounded, label: 'Search'),
    NavItem(icon: Icons.favorite_rounded, label: 'Favorites'),
    NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  int _selectedIndex = 0;

  // Animation controllers
  late AnimationController _bounceController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Auto-demo for the YouTube short
    _runAutoDemo();
  }

  void _runAutoDemo() async {
    // Wait for initial render
    await Future.delayed(const Duration(milliseconds: 1000));

    // Cycle through nav items
    for (int i = 1; i < _items.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1200));
      _onItemTapped(i);
    }

    // Return to home
    await Future.delayed(const Duration(milliseconds: 1200));
    _onItemTapped(0);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Trigger animations
    _bounceController.reset();
    _bounceController.forward();

    _scaleController.reset();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for transparent nav bar
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: CustomPaint(
                    painter: DotPatternPainter(
                      dotColor: Colors.black.withOpacity(0.03),
                      dotSize: 2,
                      spacing: 20,
                    ),
                    child: Container(),
                  ),
                );
              },
            ),
          ),

          // App bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "BOUNCE NAV",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Page content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Current page icon with scale animation
                AnimatedBuilder(
                  animation: Listenable.merge([_scaleController, _bounceController]),
                  builder: (context, child) {
                    final scale = 1.0 + _scaleController.value * 0.3;
                    final bounce = -5 * math.sin(_bounceController.value * math.pi);

                    return Transform.translate(
                      offset: Offset(0, bounce),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background pattern
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: CustomPaint(
                                    painter: DotPatternPainter(
                                      dotColor: Colors.black.withOpacity(0.05),
                                      dotSize: 2,
                                      spacing: 15,
                                    ),
                                  ),
                                ),
                              ),

                              // Icon
                              Icon(
                                _items[_selectedIndex].icon,
                                size: 80,
                                color: Colors.black,
                              ),

                              // Decorative corner dots
                              Positioned(
                                top: 20,
                                left: 20,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                right: 20,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Current page label
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    key: ValueKey<int>(_selectedIndex),
                    children: [
                      Text(
                        _items[_selectedIndex].label.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Description text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Page ${_selectedIndex + 1} of ${_items.length}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.6),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Footer text for YouTube
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Subscribe for more Flutter tutorials",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Custom bottom navigation bar
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 90,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_items.length, (index) {
                final isSelected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: AnimatedBuilder(
                    animation: _bounceController,
                    builder: (context, child) {
                      double bounce = 0.0;

                      if (isSelected) {
                        // Create bounce effect using a sine wave
                        bounce = -15 * math.sin(_bounceController.value * math.pi);
                      }

                      return Transform.translate(
                        offset: Offset(0, bounce),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon with background
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isSelected ? 50 : 40,
                            height: isSelected ? 50 : 40,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                                  : [],
                            ),
                            child: Center(
                              child: Icon(
                                _items[index].icon,
                                color: isSelected ? Colors.black : Colors.white.withOpacity(0.7),
                                size: isSelected ? 24 : 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Label
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                              fontSize: isSelected ? 12 : 10,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                            child: Text(_items[index].label),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for dot pattern
class DotPatternPainter extends CustomPainter {
  final Color dotColor;
  final double dotSize;
  final double spacing;

  DotPatternPainter({
    required this.dotColor,
    required this.dotSize,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotPatternPainter oldDelegate) =>
      oldDelegate.dotColor != dotColor ||
          oldDelegate.dotSize != dotSize ||
          oldDelegate.spacing != spacing;
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({
    required this.icon,
    required this.label,
  });
}