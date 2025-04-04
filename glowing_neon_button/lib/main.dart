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
      title: 'Neon Button Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        fontFamily: 'Montserrat',
      ),
      home: const NeonButtonDemo(),
    );
  }
}

class NeonButtonDemo extends StatefulWidget {
  const NeonButtonDemo({Key? key}) : super(key: key);

  @override
  State<NeonButtonDemo> createState() => _NeonButtonDemoState();
}

class _NeonButtonDemoState extends State<NeonButtonDemo> with SingleTickerProviderStateMixin {
  final List<Color> neonColors = [
    Colors.cyan,
    Colors.purple,
    Colors.pink,
    Colors.green,
    Colors.orange,
  ];

  final List<String> buttonTexts = [
    "GLOW",
    "NEON",
    "FLUTTER",
    "SHINE",
    "PULSE"
  ];

  final List<String> tipTexts = [
    "Tip: Use BoxShadow for glow effects",
    "Tip: AnimationController manages animations",
    "Tip: GestureDetector adds interactivity",
    "Tip: Custom painting creates unique UI",
    "Tip: StatefulWidget tracks button state"
  ];

  int currentIndex = 0;
  int tapCount = 0;
  late AnimationController _pageController;
  late Animation<double> _pageAnimation;
  late Timer _autoChangeTimer;
  bool _showTip = false;

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pageAnimation = CurvedAnimation(
      parent: _pageController,
      curve: Curves.easeInOut,
    );

    // Auto-change timer for the demo
    _autoChangeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _nextColor();
    });

    // Show tip after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showTip = true;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoChangeTimer.cancel();
    super.dispose();
  }

  void _nextColor() {
    setState(() {
      currentIndex = (currentIndex + 1) % neonColors.length;
      _showTip = true;
    });
    _pageController.reset();
    _pageController.forward();
  }

  void _incrementCounter() {
    setState(() {
      tapCount++;
      // Hide tip when button is pressed
      _showTip = false;
      // Show it again after a delay
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _showTip = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              neonColors[currentIndex].withOpacity(0.15),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title with neon effect
              Text(
                "NEON BUTTONS",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: neonColors[currentIndex].withOpacity(0.8),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                "Flutter UI Challenge",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 60),

              // Main neon button
              AnimatedBuilder(
                  animation: _pageAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.9 + (_pageAnimation.value * 0.1),
                      child: NeonButton(
                        text: buttonTexts[currentIndex],
                        color: neonColors[currentIndex],
                        onPressed: () {
                          _incrementCounter();
                        },
                      ),
                    );
                  }
              ),

              const SizedBox(height: 40),

              // Tap counter with neon effect
              AnimatedOpacity(
                opacity: tapCount > 0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.5),
                    boxShadow: [
                      BoxShadow(
                        color: neonColors[currentIndex].withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    "Button pressed: $tapCount times",
                    style: TextStyle(
                      fontSize: 16,
                      color: neonColors[currentIndex],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Educational tip with animation
              AnimatedOpacity(
                opacity: _showTip ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.7),
                    border: Border.all(
                      color: neonColors[currentIndex].withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tipTexts[currentIndex],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Row of small neon buttons with different colors
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: neonColors.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                          });
                          _pageController.reset();
                          _pageController.forward();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(
                              color: neonColors[index],
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: neonColors[index].withOpacity(currentIndex == index ? 0.6 : 0.2),
                                blurRadius: currentIndex == index ? 12 : 5,
                                spreadRadius: currentIndex == index ? 2 : 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Footer text
              Text(
                "Subscribe for more Flutter tutorials",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NeonButton extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const NeonButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _glowAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                // Inner glow
                BoxShadow(
                  color: widget.color.withOpacity(0.5),
                  blurRadius: 10 * _glowAnimation.value,
                  spreadRadius: 1,
                ),
                // Outer glow
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 20 * _glowAnimation.value,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: null, // We're handling the tap with GestureDetector
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.6),
                foregroundColor: widget.color,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: widget.color,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: widget.color.withOpacity(_isPressed ? 1.0 : 0.9),
                  shadows: [
                    Shadow(
                      color: widget.color.withOpacity(0.8),
                      blurRadius: 12 * _glowAnimation.value,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}