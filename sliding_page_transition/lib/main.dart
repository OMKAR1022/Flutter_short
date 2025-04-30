import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
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
        fontFamily: 'Inter',
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),
      home: const GlassyTransitionDemo(),
    );
  }
}

class GlassyTransitionDemo extends StatefulWidget {
  const GlassyTransitionDemo({Key? key}) : super(key: key);

  @override
  State<GlassyTransitionDemo> createState() => _GlassyTransitionDemoState();
}

class _GlassyTransitionDemoState extends State<GlassyTransitionDemo> {
  // Demo state
  int _currentPageIndex = 0;
  bool _isTransitioning = false;
  int _demoStep = 0;

  // Demo timer
  Timer? _demoTimer;

  // Page data
  final List<PageData> _pages = [
    PageData(
      title: 'Discover',
      subtitle: 'Explore new experiences',
      color: const Color(0xFF6366F1),
      icon: Icons.explore,
      gradientColors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
    ),
    PageData(
      title: 'Connect',
      subtitle: 'Meet like-minded people',
      color: const Color(0xFFEC4899),
      icon: Icons.people,
      gradientColors: [const Color(0xFFEC4899), const Color(0xFFF472B6)],
    ),
    PageData(
      title: 'Create',
      subtitle: 'Share your inspiration',
      color: const Color(0xFF10B981),
      icon: Icons.create,
      gradientColors: [const Color(0xFF10B981), const Color(0xFF34D399)],
    ),
    PageData(
      title: 'Achieve',
      subtitle: 'Reach your goals',
      color: const Color(0xFFF59E0B),
      icon: Icons.emoji_events,
      gradientColors: [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Start demo sequence
    _startDemoSequence();
  }

  void _startDemoSequence() {
    _demoTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      // Demo timeline for a 30-second YouTube short
      switch (timer.tick) {
        case 3: // First transition
          _navigateToNextPage();
          break;
        case 7: // Second transition
          _navigateToNextPage();
          break;
        case 11: // Third transition
          _navigateToNextPage();
          break;
        case 15: // Back to first page
          _navigateToNextPage();
          break;
        case 19: // Show swipe instruction
          setState(() {
            _demoStep = 1;
          });
          break;
        case 22: // Swipe to next page
          _navigateToNextPage();
          break;
        case 26: // Reset demo
          _resetDemo();
          break;
      }
    });
  }

  void _navigateToNextPage() {
    if (_isTransitioning) return;

    setState(() {
      _isTransitioning = true;
    });

    final nextPageIndex = (_currentPageIndex + 1) % _pages.length;

    Navigator.of(context).push(
      GlassySlidePageRoute(
        builder: (context) => PageScreen(
          page: _pages[nextPageIndex],
          onNavigate: _handleNavigation,
        ),
        settings: const RouteSettings(name: '/next'),
      ),
    );

    setState(() {
      _currentPageIndex = nextPageIndex;
      _isTransitioning = false;
    });
  }

  void _handleNavigation() {
    _navigateToNextPage();
  }

  void _resetDemo() {
    setState(() {
      _currentPageIndex = 0;
      _demoStep = 0;
    });

    // Pop to first page
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageScreen(
      page: _pages[_currentPageIndex],
      onNavigate: _handleNavigation,
      showSwipeInstruction: _demoStep == 1,
    );
  }
}

class PageScreen extends StatelessWidget {
  final PageData page;
  final VoidCallback onNavigate;
  final bool showSwipeInstruction;

  const PageScreen({
    Key? key,
    required this.page,
    required this.onNavigate,
    this.showSwipeInstruction = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            onNavigate();
          }
        },
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: page.gradientColors,
                ),
              ),
            ),

            // Background pattern
            CustomPaint(
              painter: GlassyPatternPainter(color: page.color),
              size: MediaQuery.of(context).size,
            ),

            // Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlassyContainer(
                          child: IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                        GlassyContainer(
                          child: IconButton(
                            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        GlassyContainer(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Icon(
                            page.icon,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),

                        // Title
                        Text(
                          page.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          page.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Button
                        GlassyContainer(
                          onTap: onNavigate,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom navigation dots
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        final isActive = index == _getPageIndex(context);
                        return Container(
                          width: isActive ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // Swipe instruction
            if (showSwipeInstruction)
              Positioned(
                right: 24,
                bottom: 100,
                child: GlassyContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.swipe_left,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Swipe left to continue',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  int _getPageIndex(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route?.settings.name == '/next') {
      // This is a next page
      return (page.id + 1) % 4;
    }
    return page.id;
  }
}

class GlassySlidePageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  GlassySlidePageRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      // Blur effect animation
      var blurAnimation = Tween<double>(begin: 0, end: 5)
          .chain(CurveTween(curve: Curves.easeOut))
          .animate(animation);

      return SlideTransition(
        position: offsetAnimation,
        child: AnimatedBuilder(
          animation: blurAnimation,
          builder: (context, child) {
            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurAnimation.value,
                sigmaY: blurAnimation.value,
              ),
              child: child,
            );
          },
          child: child,
        ),
      );
    },
  );
}

class GlassyContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  const GlassyContainer({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(8),
    this.margin = EdgeInsets.zero,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.05),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class GlassyPatternPainter extends CustomPainter {
  final Color color;

  GlassyPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern

    // Draw circles
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 20 + random.nextDouble() * 80;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 10; i++) {
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final x2 = random.nextDouble() * size.width;
      final y2 = random.nextDouble() * size.height;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PageData {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final List<Color> gradientColors;
  final int id;

  static int _counter = 0;

  PageData({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.gradientColors,
  }) : id = _counter++;
}