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
        fontFamily: 'Inter',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1D21),
      ),
      home: const CollapsibleSidebarDemo(),
    );
  }
}

class CollapsibleSidebarDemo extends StatefulWidget {
  const CollapsibleSidebarDemo({Key? key}) : super(key: key);

  @override
  State<CollapsibleSidebarDemo> createState() => _CollapsibleSidebarDemoState();
}

class _CollapsibleSidebarDemoState extends State<CollapsibleSidebarDemo> with TickerProviderStateMixin {
  // Menu items
  final List<SidebarItem> _menuItems = [
    SidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard', badge: 3),
    SidebarItem(icon: Icons.analytics_rounded, label: 'Analytics'),
    SidebarItem(icon: Icons.folder_rounded, label: 'Projects'),
    SidebarItem(icon: Icons.calendar_today_rounded, label: 'Calendar'),
    SidebarItem(icon: Icons.message_rounded, label: 'Messages', badge: 5),
    SidebarItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  // State variables
  bool _isExpanded = true;
  int _selectedIndex = 0;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  // Auto-demo timer
  Timer? _demoTimer;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Width animation for the sidebar
    _widthAnimation = Tween<double>(
      begin: 70,
      end: 250,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start with expanded sidebar
    _animationController.forward();

    // Auto-demo for the YouTube short
    _runAutoDemo();
  }

  void _runAutoDemo() {
    // Schedule demo actions
    _demoTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (timer.tick == 3) {
        _toggleSidebar();
      } else if (timer.tick == 5) {
        _selectMenuItem(1);
      } else if (timer.tick == 7) {
        _selectMenuItem(4);
      } else if (timer.tick == 9) {
        _toggleSidebar();
      } else if (timer.tick == 11) {
        _selectMenuItem(2);
      } else if (timer.tick == 13) {
        _selectMenuItem(0);
      } else if (timer.tick == 15) {
        _toggleSidebar();
      } else if (timer.tick == 17) {
        _toggleSidebar();
      } else if (timer.tick == 25) {
        // Reset demo
        timer.cancel();
        _runAutoDemo();
      }
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectMenuItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _demoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Animated sidebar
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: _widthAnimation.value,
                  height: double.infinity,
                  color: const Color(0xFF10131A),
                  child: Column(
                    children: [
                      // App logo
                      SizedBox(
                        height: 70,
                        child: Center(
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.code_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      // Toggle button
                      GestureDetector(
                        onTap: _toggleSidebar,
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Icon(
                            _isExpanded
                                ? Icons.keyboard_double_arrow_left_rounded
                                : Icons.keyboard_double_arrow_right_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Menu items - COMPLETELY REDESIGNED TO AVOID OVERFLOW
                      Expanded(
                        child: ListView.builder(
                          itemCount: _menuItems.length,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemBuilder: (context, index) {
                            final item = _menuItems[index];
                            final isSelected = _selectedIndex == index;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                onTap: () => _selectMenuItem(index),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF6366F1).withOpacity(0.15)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF6366F1)
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _isExpanded
                                      ? Stack(
                                    children: [
                                      // Icon
                                      Positioned(
                                        left: 12,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: Icon(
                                            item.icon,
                                            color: isSelected
                                                ? const Color(0xFF6366F1)
                                                : Colors.white.withOpacity(0.7),
                                            size: 22,
                                          ),
                                        ),
                                      ),

                                      // Label
                                      Positioned(
                                        left: 46,
                                        top: 0,
                                        bottom: 0,
                                        right: item.badge != null ? 40 : 12,
                                        child: Center(
                                          child: Text(
                                            item.label,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.white.withOpacity(0.7),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),

                                      // Badge
                                      if (item.badge != null)
                                        Positioned(
                                          right: 12,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF6366F1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                item.badge.toString(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                      : Center(
                                    child: Icon(
                                      item.icon,
                                      color: isSelected
                                          ? const Color(0xFF6366F1)
                                          : Colors.white.withOpacity(0.7),
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // User profile
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Main content area - ULTRA MINIMAL
            Expanded(
              child: Container(
                color: const Color(0xFF1A1D21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _menuItems[_selectedIndex].label,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Content area - ULTRA MINIMAL CARDS
                    Expanded(
                      child: GridView.count(
                        padding: const EdgeInsets.all(16),
                        crossAxisCount: 1,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                        children: [
                          _buildUltraSimpleCard(
                            icon: Icons.trending_up_rounded,
                            title: "Revenue",
                            value: "\$24,345",
                          ),
                          _buildUltraSimpleCard(
                            icon: Icons.people_rounded,
                            title: "Users",
                            value: "1,293",
                          ),
                          _buildUltraSimpleCard(
                            icon: Icons.attach_money_rounded,
                            title: "Conversion",
                            value: "12.3%",
                          ),
                          _buildUltraSimpleCard(
                            icon: Icons.bar_chart_rounded,
                            title: "Sessions",
                            value: "4,721",
                          ),
                        ],
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

  // Ultra simple card with fixed height to prevent overflow
  Widget _buildUltraSimpleCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF10131A),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6366F1),
              size: 16,
            ),
          ),

          const Spacer(),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class SidebarItem {
  final IconData icon;
  final String label;
  final int? badge;

  SidebarItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}