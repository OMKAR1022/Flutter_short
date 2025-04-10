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
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const FilterChipsDemo(),
    );
  }
}

class FilterChipsDemo extends StatefulWidget {
  const FilterChipsDemo({Key? key}) : super(key: key);

  @override
  State<FilterChipsDemo> createState() => _FilterChipsDemoState();
}

class _FilterChipsDemoState extends State<FilterChipsDemo> with TickerProviderStateMixin {
  // Categories for filter chips
  final List<FilterCategory> _categories = [
    FilterCategory(
      name: 'Color',
      options: [
        FilterOption(label: 'Blue', color: const Color(0xFFAED9E0)),
        FilterOption(label: 'Pink', color: const Color(0xFFFBC5C5)),
        FilterOption(label: 'Green', color: const Color(0xFFB5E8C7)),
        FilterOption(label: 'Yellow', color: const Color(0xFFFFF3B0)),
        FilterOption(label: 'Purple', color: const Color(0xFFE0C3FC)),
      ],
    ),
    FilterCategory(
      name: 'Size',
      options: [
        FilterOption(label: 'XS', color: const Color(0xFFFBC5C5)),
        FilterOption(label: 'S', color: const Color(0xFFFBC5C5)),
        FilterOption(label: 'M', color: const Color(0xFFFBC5C5)),
        FilterOption(label: 'L', color: const Color(0xFFFBC5C5)),
        FilterOption(label: 'XL', color: const Color(0xFFFBC5C5)),
      ],
    ),
    FilterCategory(
      name: 'Price',
      options: [
        FilterOption(label: 'Under \$25', color: const Color(0xFFB5E8C7)),
        FilterOption(label: '\$25 - \$50', color: const Color(0xFFB5E8C7)),
        FilterOption(label: '\$50 - \$100', color: const Color(0xFFB5E8C7)),
        FilterOption(label: 'Over \$100', color: const Color(0xFFB5E8C7)),
      ],
    ),
  ];

  // Track selected options
  final Set<FilterOption> _selectedOptions = {};

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _pulseController;

  // Track which category is currently visible
  int _currentCategoryIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Start fade-in animation
    _fadeController.forward();

    // Auto-demo for the YouTube short
    _runAutoDemo();
  }

  void _runAutoDemo() async {
    // Wait for initial render
    await Future.delayed(const Duration(milliseconds: 1000));

    // Select some options from first category
    _toggleOption(_categories[0].options[1]); // Pink
    await Future.delayed(const Duration(milliseconds: 800));
    _toggleOption(_categories[0].options[2]); // Green
    await Future.delayed(const Duration(milliseconds: 800));

    // Switch to second category
    setState(() {
      _currentCategoryIndex = 1;
    });
    _fadeController.reset();
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));

    // Select an option from second category
    _toggleOption(_categories[1].options[2]); // M
    await Future.delayed(const Duration(milliseconds: 800));

    // Switch to third category
    setState(() {
      _currentCategoryIndex = 2;
    });
    _fadeController.reset();
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));

    // Select an option from third category
    _toggleOption(_categories[2].options[1]); // $25-$50
    await Future.delayed(const Duration(milliseconds: 800));

    // Show results count animation
  }

  void _toggleOption(FilterOption option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
    });
  }

  void _switchCategory(int index) {
    if (_currentCategoryIndex != index) {
      setState(() {
        _currentCategoryIndex = index;
      });
      _fadeController.reset();
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_list_rounded,
                    size: 28,
                    color: Color(0xFF6C757D),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Filter Products",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF495057),
                    ),
                  ),
                  const Spacer(),
                  // Results count
                  if (_selectedOptions.isNotEmpty)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_pulseController.value * 0.05),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0C3FC),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE0C3FC).withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2 * _pulseController.value,
                                ),
                              ],
                            ),
                            child: Text(
                              "${_selectedOptions.length} Selected",
                              style: const TextStyle(
                                color: Color(0xFF495057),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

            // Category tabs
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _currentCategoryIndex == index;

                  return GestureDetector(
                    onTap: () => _switchCategory(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF495057)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF495057)
                              : const Color(0xFFCED4DA),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF6C757D),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Filter chips with fade-in animation
            Expanded(
              child: AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeController.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _fadeController.value)),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category title
                      Text(
                        _categories[_currentCategoryIndex].name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF495057),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Filter chips
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _categories[_currentCategoryIndex].options.map((option) {
                          final isSelected = _selectedOptions.contains(option);

                          return PastelFilterChip(
                            label: option.label,
                            color: option.color,
                            isSelected: isSelected,
                            onTap: () => _toggleOption(option),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 30),

                      // Results preview
                      if (_selectedOptions.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Selected Filters",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF495057),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _selectedOptions.map((option) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: option.color.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        option.label,
                                        style: const TextStyle(
                                          color: Color(0xFF495057),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Color(0xFF495057),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Apply button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF495057),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Apply Filters",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Footer text for YouTube
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Subscribe for more Flutter tutorials",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PastelFilterChip extends StatefulWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const PastelFilterChip({
    Key? key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PastelFilterChip> createState() => _PastelFilterChipState();
}

class _PastelFilterChipState extends State<PastelFilterChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) => _controller.reverse());
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.color
                : widget.color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? widget.color.withOpacity(0.8)
                  : widget.color.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
              BoxShadow(
                color: widget.color.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: const Color(0xFF495057),
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              if (widget.isSelected) ...[
                const SizedBox(width: 6),
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      size: 12,
                      color: Color(0xFF495057),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FilterCategory {
  final String name;
  final List<FilterOption> options;

  FilterCategory({
    required this.name,
    required this.options,
  });
}

class FilterOption {
  final String label;
  final Color color;

  FilterOption({
    required this.label,
    required this.color,
  });
}