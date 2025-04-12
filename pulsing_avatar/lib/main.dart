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
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const PulsingAvatarDemo(),
    );
  }
}

class PulsingAvatarDemo extends StatefulWidget {
  const PulsingAvatarDemo({Key? key}) : super(key: key);

  @override
  State<PulsingAvatarDemo> createState() => _PulsingAvatarDemoState();
}

class _PulsingAvatarDemoState extends State<PulsingAvatarDemo> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  // Profile stats
  int _followers = 1452;
  int _following = 348;
  int _posts = 127;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Auto-demo for the YouTube short
    _runAutoDemo();
  }

  void _runAutoDemo() async {
    // Wait for initial render
    await Future.delayed(const Duration(milliseconds: 1000));

    // Trigger follow action
    _toggleFollow();

    // Wait and show profile tap animation
    await Future.delayed(const Duration(milliseconds: 2000));
    _scaleController.forward().then((_) => _scaleController.reverse());

    // Wait and unfollow
    await Future.delayed(const Duration(milliseconds: 2000));
    _toggleFollow();
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing) {
        _followers++;
      } else {
        _followers--;
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color(0xFF212529),
                    ),
                    const Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212529),
                      ),
                    ),
                    Icon(
                      Icons.more_vert_rounded,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Profile avatar with pulsing border
              GestureDetector(
                onTap: () {
                  _scaleController.forward().then((_) => _scaleController.reverse());
                },
                child: AnimatedBuilder(
                  animation: Listenable.merge([_pulseController, _rotationController, _scaleController]),
                  builder: (context, child) {
                    final pulseValue = 0.5 + (_pulseController.value * 0.5);
                    final scaleValue = 1.0 + (_scaleController.value * 0.1);

                    return Transform.scale(
                      scale: scaleValue,
                      child: SizedBox(
                        width: 140,
                        height: 140,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Rotating gradient border
                            Transform.rotate(
                              angle: _rotationController.value * 2 * math.pi,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6C63FF),
                                      Color(0xFF5E72EB),
                                      Color(0xFFFF9190),
                                      Color(0xFFFFC2A1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            ),

                            // Pulsing outer glow
                            Container(
                              width: 130 * pulseValue,
                              height: 130 * pulseValue,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6C63FF).withOpacity(0.3 * _pulseController.value),
                                    blurRadius: 20,
                                    spreadRadius: 5 * _pulseController.value,
                                  ),
                                ],
                              ),
                            ),

                            // White background
                            Container(
                              width: 125,
                              height: 125,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),

                            // Profile image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=256&q=80',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Online indicator
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF4CAF50),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Username and bio
              const Text(
                "Jessica Parker",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF212529),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "Photographer & Visual Designer",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 25),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatColumn(_posts, "Posts"),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                  ),
                  _buildStatColumn(_followers, "Followers"),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                  ),
                  _buildStatColumn(_following, "Following"),
                ],
              ),

              const SizedBox(height: 25),

              // Follow button
              GestureDetector(
                onTap: _toggleFollow,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 180,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _isFollowing ? Colors.white : const Color(0xFF6C63FF),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: _isFollowing ? const Color(0xFF6C63FF) : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: _isFollowing
                        ? []
                        : [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _isFollowing ? "Following" : "Follow",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isFollowing ? const Color(0xFF6C63FF) : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Footer text for YouTube
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Subscribe for more Flutter tutorials",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(int count, String label) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}