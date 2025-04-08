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
        fontFamily: 'Righteous',
        scaffoldBackgroundColor: const Color(0xFFFDF6E3),
      ),
      home: const RetroTextFieldDemo(),
    );
  }
}

class RetroTextFieldDemo extends StatefulWidget {
  const RetroTextFieldDemo({Key? key}) : super(key: key);

  @override
  State<RetroTextFieldDemo> createState() => _RetroTextFieldDemoState();
}

class _RetroTextFieldDemoState extends State<RetroTextFieldDemo> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;

  // Controllers for animations
  late AnimationController _rippleController;
  late AnimationController _colorController;
  late AnimationController _bounceController;

  // Ripple effect position
  Offset _ripplePosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    // Listen for focus changes
    _focusNode.addListener(_handleFocusChange);

    // Initialize animation controllers
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Auto-focus for demo purposes
    Future.delayed(const Duration(seconds: 1), () {
      _focusNode.requestFocus();
      _ripplePosition = const Offset(150, 30);
      _rippleController.forward(from: 0.0);

      // Auto-type for demo purposes
      _autoTypeText("RETRO VIBES");
    });
  }

  void _autoTypeText(String text) async {
    for (int i = 0; i < text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150), () {
        _textController.text = text.substring(0, i + 1);
        _bounceController.forward(from: 0.0);
      });
    }
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (_isFocused) {
        _rippleController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _rippleController.dispose();
    _colorController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Retro background pattern
          image: DecorationImage(
            image: NetworkImage('https://www.transparenttextures.com/patterns/retina-wood.png'),
            repeat: ImageRepeat.repeat,
            opacity: 0.1,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Retro title
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        const Color(0xFFFF5252),
                        const Color(0xFFFF7B00),
                        const Color(0xFFFFD600),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    "RETRO TEXT FIELD",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Subtitle
                Text(
                  "WITH FLOATING LABEL & RIPPLE",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 60),

                // Custom text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GestureDetector(
                    onTapDown: (details) {
                      _ripplePosition = details.localPosition;
                      if (!_isFocused) {
                        _focusNode.requestFocus();
                      }
                    },
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_rippleController, _colorController, _bounceController]),
                      builder: (context, child) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Text field container
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _isFocused
                                        ? const Color(0xFFFF5252).withOpacity(0.3)
                                        : Colors.grey.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: _isFocused
                                      ? Color.lerp(
                                    const Color(0xFFFF5252),
                                    const Color(0xFFFF7B00),
                                    _colorController.value,
                                  )!
                                      : Colors.grey.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: CustomPaint(
                                painter: RetroPatternPainter(
                                  color: _isFocused
                                      ? Color.lerp(
                                    const Color(0xFFFF5252),
                                    const Color(0xFFFF7B00),
                                    _colorController.value,
                                  )!.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.05),
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: _textController,
                                    focusNode: _focusNode,
                                    cursorColor: const Color(0xFFFF5252),
                                    cursorWidth: 2,
                                    cursorRadius: const Radius.circular(4),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      // We'll handle the label separately
                                      hintText: '',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        // Trigger bounce animation on each keystroke
                                        _bounceController.forward(from: 0.0);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // Ripple effect
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CustomPaint(
                                  painter: RipplePainter(
                                    position: _ripplePosition,
                                    progress: _rippleController.value,
                                    color: Color.lerp(
                                      const Color(0xFFFF5252),
                                      const Color(0xFFFF7B00),
                                      _colorController.value,
                                    )!,
                                  ),
                                ),
                              ),
                            ),

                            // Floating label
                            Positioned(
                              left: 20,
                              top: _isFocused || _textController.text.isNotEmpty
                                  ? -12
                                  : 20,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _isFocused ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "YOUR MESSAGE",
                                  style: TextStyle(
                                    fontSize: _isFocused || _textController.text.isNotEmpty ? 12 : 16,
                                    fontWeight: FontWeight.w500,
                                    color: _isFocused
                                        ? Color.lerp(
                                      const Color(0xFFFF5252),
                                      const Color(0xFFFF7B00),
                                      _colorController.value,
                                    )
                                        : Colors.grey[500],
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),

                            // Bouncing character indicator
                            if (_textController.text.isNotEmpty)
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Transform.translate(
                                  offset: Offset(0, -5 * _bounceController.value * (1 - _bounceController.value) * 4),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Color.lerp(
                                        const Color(0xFFFF5252),
                                        const Color(0xFFFF7B00),
                                        _colorController.value,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      _textController.text.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Retro buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRetroButton(
                      label: "CLEAR",
                      icon: Icons.refresh,
                      color: const Color(0xFF00BCD4),
                      onTap: () {
                        _textController.clear();
                        _focusNode.requestFocus();
                        _ripplePosition = const Offset(150, 30);
                        _rippleController.forward(from: 0.0);
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildRetroButton(
                      label: "SUBMIT",
                      icon: Icons.send,
                      color: const Color(0xFFFF5252),
                      onTap: () {
                        // Show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Message sent: ${_textController.text}",
                              style: const TextStyle(fontFamily: 'Righteous'),
                            ),
                            backgroundColor: const Color(0xFFFF5252),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Footer text for YouTube
                const Text(
                  "Subscribe for more Flutter tutorials",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetroButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 0,
              spreadRadius: 0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RetroPatternPainter extends CustomPainter {
  final Color color;

  RetroPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw zigzag pattern
    final path = Path();

    // Top zigzag
    double x = 0;
    while (x < size.width) {
      path.moveTo(x, 0);
      path.lineTo(x + 5, 5);
      path.lineTo(x + 10, 0);
      x += 10;
    }

    // Bottom zigzag
    x = 0;
    while (x < size.width) {
      path.moveTo(x, size.height);
      path.lineTo(x + 5, size.height - 5);
      path.lineTo(x + 10, size.height);
      x += 10;
    }

    // Draw dots pattern
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 3; j++) {
        canvas.drawCircle(
          Offset(
            size.width * (i / 10) + 10,
            size.height * (j + 1) / 4,
          ),
          1,
          Paint()..color = color,
        );
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(RetroPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class RipplePainter extends CustomPainter {
  final Offset position;
  final double progress;
  final Color color;

  RipplePainter({
    required this.position,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3 * (1 - progress))
      ..style = PaintingStyle.fill;

    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height);
    final radius = maxRadius * progress;

    canvas.drawCircle(position, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.position != position ||
        oldDelegate.color != color;
  }
}