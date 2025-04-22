import 'package:flutter/material.dart';
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
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F9F0),
      ),
      home: const NatureFabDemo(),
    );
  }
}

class NatureFabDemo extends StatefulWidget {
  const NatureFabDemo({Key? key}) : super(key: key);

  @override
  State<NatureFabDemo> createState() => _NatureFabDemoState();
}

class _NatureFabDemoState extends State<NatureFabDemo> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  // State variables
  bool _isExpanded = false;
  int _demoStep = 0;

  // Mini FAB items
  final List<FabItem> _items = [
    FabItem(icon: Icons.eco, label: 'Plant', color: const Color(0xFF66BB6A)),
    FabItem(icon: Icons.water_drop, label: 'Water', color: const Color(0xFF26A69A)),
    FabItem(icon: Icons.wb_sunny, label: 'Light', color: const Color(0xFF9CCC65)),
  ];

  // Auto-demo timer
  Timer? _demoTimer;

  @override
  void initState() {
    super.initState();

    // Scale animation controller
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Rotate animation controller
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    ));

    // Elevation animation
    _elevationAnimation = Tween<double>(
      begin: 6.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));

    // Start the demo
    _runDemo();
  }

  void _runDemo() {
    _demoTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        // Demo timeline
        switch (timer.tick) {
          case 2: // Initial FAB pulse
            _pulseMainButton();
            break;
          case 4: // Expand FAB
            _toggleFab();
            break;
          case 7: // Select first mini FAB
            _selectItem(0);
            break;
          case 10: // Close FAB
            _toggleFab();
            break;
          case 13: // Pulse again
            _pulseMainButton();
            break;
          case 15: // Expand again
            _toggleFab();
            break;
          case 18: // Select second mini FAB
            _selectItem(1);
            break;
          case 21: // Select third mini FAB
            _selectItem(2);
            break;
          case 24: // Close FAB
            _toggleFab();
            break;
          case 28: // Reset demo
            _demoStep = 0;
            timer.cancel();
            _runDemo();
            break;
        }
      });
    });
  }

  void _pulseMainButton() {
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      _scaleController.reverse();
    });
  }

  void _toggleFab() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _scaleController.forward();
        _rotateController.forward();
      } else {
        _scaleController.reverse();
        _rotateController.reverse();
      }
    });
  }

  void _selectItem(int index) {
    setState(() {
      _demoStep = index + 1;
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotateController.dispose();
    _demoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nature Care',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: NaturePatternPainter(),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Plant status card
                Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.spa,
                                color: Color(0xFF2E7D32),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Monstera Deliciosa',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildStatusRow(
                          icon: Icons.water_drop,
                          label: 'Water',
                          value: _demoStep == 2 ? '100%' : '45%',
                          color: const Color(0xFF26A69A),
                          progress: _demoStep == 2 ? 1.0 : 0.45,
                        ),
                        const SizedBox(height: 12),
                        _buildStatusRow(
                          icon: Icons.wb_sunny,
                          label: 'Light',
                          value: _demoStep == 3 ? '100%' : '60%',
                          color: const Color(0xFF9CCC65),
                          progress: _demoStep == 3 ? 1.0 : 0.6,
                        ),
                        const SizedBox(height: 12),
                        _buildStatusRow(
                          icon: Icons.eco,
                          label: 'Health',
                          value: _demoStep == 1 ? '100%' : '75%',
                          color: const Color(0xFF66BB6A),
                          progress: _demoStep == 1 ? 1.0 : 0.75,
                        ),
                      ],
                    ),
                  ),
                ),

                // Demo instruction
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _isExpanded
                        ? 'Select an action for your plant'
                        : 'Tap the + button to care for your plant',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Mini FABs - FIXED POSITIONING
          ..._buildFixedMiniButtons(),

          // Main FAB
          Positioned(
            right: 16,
            bottom: 16,
            child: AnimatedBuilder(
              animation: _elevationAnimation,
              builder: (context, child) {
                return FloatingActionButton(
                  onPressed: _toggleFab,
                  backgroundColor: const Color(0xFF4CAF50),
                  elevation: _elevationAnimation.value,
                  child: AnimatedRotation(
                    turns: _rotateController.value * 0.125,
                    duration: const Duration(milliseconds: 300), // Added the required duration parameter
                    child: Icon(
                      _isExpanded ? Icons.close : Icons.add,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // FIXED: Completely redesigned mini buttons to avoid overlap
  List<Widget> _buildFixedMiniButtons() {
    if (!_isExpanded) return [];

    List<Widget> buttons = [];

    // Calculate positions for each mini FAB
    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      // Position each button at a fixed distance above the main FAB
      final double bottomPosition = 24.0 + ((i + 1) * 70.0);

      buttons.add(
        Positioned(
          right: 24,
          bottom: bottomPosition,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(right: 8),
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: item.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Mini FAB
                SizedBox(
                  width: 48,
                  height: 48,
                  child: FloatingActionButton(
                    onPressed: () => _selectItem(i),
                    backgroundColor: item.color,
                    elevation: 4,
                    heroTag: 'miniFab$i',
                    mini: true,
                    child: Icon(item.icon, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  Widget _buildStatusRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required double progress,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

// Custom painter for the nature-inspired background pattern
class NaturePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8F5E9).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = const Color(0xFFC8E6C9).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Draw leaf patterns
    for (int i = 0; i < 20; i++) {
      final x = (i * 50) % size.width;
      final y = ((i * 70) % size.height);

      final path = Path();
      path.moveTo(x, y);
      path.quadraticBezierTo(x + 15, y - 20, x + 30, y);
      path.quadraticBezierTo(x + 15, y + 20, x, y);
      canvas.drawPath(path, paint);
    }

    // Draw dots
    for (int i = 0; i < 100; i++) {
      final x = (i * 37) % size.width;
      final y = ((i * 53) % size.height);
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FabItem {
  final IconData icon;
  final String label;
  final Color color;

  FabItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}