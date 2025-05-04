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
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const StoryRingDemo(),
    );
  }
}

class StoryRingDemo extends StatefulWidget {
  const StoryRingDemo({Key? key}) : super(key: key);

  @override
  State<StoryRingDemo> createState() => _StoryRingDemoState();
}

class _StoryRingDemoState extends State<StoryRingDemo> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _demoController;

  // Selected story index
  int _selectedStoryIndex = -1;

  // Demo step
  int _demoStep = 0;

  // Story data
  final List<StoryData> _stories = [
    StoryData(
      username: 'Your Story',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      hasUnseenStories: true,
      isAddStory: true,
      storyCount: 0,
    ),
    StoryData(
      username: 'emma_smith',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      hasUnseenStories: true,
      isAddStory: false,
      storyCount: 3,
    ),
    StoryData(
      username: 'john_doe',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      hasUnseenStories: true,
      isAddStory: false,
      storyCount: 2,
    ),
    StoryData(
      username: 'travel_guy',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
      hasUnseenStories: true,
      isAddStory: false,
      storyCount: 5,
    ),
    StoryData(
      username: 'foodie_gal',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      hasUnseenStories: false,
      isAddStory: false,
      storyCount: 1,
      viewedStories: [0],
    ),
    StoryData(
      username: 'fitness_pro',
      avatarUrl: 'https://i.pravatar.cc/150?img=6',
      hasUnseenStories: true,
      isAddStory: false,
      storyCount: 4,
    ),
    StoryData(
      username: 'art_lover',
      avatarUrl: 'https://i.pravatar.cc/150?img=7',
      hasUnseenStories: false,
      isAddStory: false,
      storyCount: 2,
      viewedStories: [0, 1],
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize rotation controller for gradient animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Initialize pulse controller for tap animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize demo controller for automated demo
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
      setState(() {
        _demoStep = 1;
      });
    } else if (progress >= 0.1 && progress < 0.2 && _demoStep == 1) {
      _selectStory(1);
      setState(() {
        _demoStep = 2;
      });
    } else if (progress >= 0.2 && progress < 0.3 && _demoStep == 2) {
      _viewStory(1);
      setState(() {
        _demoStep = 3;
      });
    } else if (progress >= 0.3 && progress < 0.4 && _demoStep == 3) {
      _selectStory(-1);
      setState(() {
        _demoStep = 4;
      });
    } else if (progress >= 0.4 && progress < 0.5 && _demoStep == 4) {
      _selectStory(2);
      setState(() {
        _demoStep = 5;
      });
    } else if (progress >= 0.5 && progress < 0.6 && _demoStep == 5) {
      _viewStory(2);
      setState(() {
        _demoStep = 6;
      });
    } else if (progress >= 0.6 && progress < 0.7 && _demoStep == 6) {
      _selectStory(-1);
      setState(() {
        _demoStep = 7;
      });
    } else if (progress >= 0.7 && progress < 0.8 && _demoStep == 7) {
      _selectStory(3);
      setState(() {
        _demoStep = 8;
      });
    } else if (progress >= 0.8 && progress < 0.9 && _demoStep == 8) {
      _viewStory(3);
      setState(() {
        _demoStep = 9;
      });
    } else if (progress >= 0.9 && _demoStep == 9) {
      _selectStory(-1);
      setState(() {
        _demoStep = 0;
        _demoController.reset();
        _demoController.forward();
      });
    }
  }

  void _selectStory(int index) {
    setState(() {
      _selectedStoryIndex = index;
    });

    if (index != -1) {
      _pulseController.forward(from: 0);
    }
  }

  void _viewStory(int index) {
    setState(() {
      _stories[index].hasUnseenStories = false;
      if (_stories[index].viewedStories == null) {
        _stories[index].viewedStories = [];
      }
      for (int i = 0; i < _stories[index].storyCount; i++) {
        if (!_stories[index].viewedStories!.contains(i)) {
          _stories[index].viewedStories!.add(i);
        }
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Text(
              'Instagram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_box_outlined, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.send_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stories section
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _stories.length,
              itemBuilder: (context, index) {
                return _buildStoryItem(_stories[index], index);
              },
            ),
          ),

          // Feed section
          Expanded(
            child: _selectedStoryIndex != -1
                ? _buildStoryView(_stories[_selectedStoryIndex])
                : _buildFeed(),
          ),

          // Bottom navigation
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.video_library_outlined),
                  onPressed: () {},
                ),
                const CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(StoryData story, int index) {
    final isSelected = _selectedStoryIndex == index;

    return GestureDetector(
      onTap: () {
        if (story.isAddStory) {
          // Handle add story tap
        } else {
          _selectStory(isSelected ? -1 : index);
        }
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = isSelected
                    ? 1.0 + (_pulseController.value * 0.1)
                    : 1.0;

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 70,
                    height: 70,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      children: [
                        // Story ring
                        if (story.hasUnseenStories && !story.isAddStory)
                          AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: StoryRingPainter(
                                  rotation: _rotationController.value,
                                  storyCount: story.storyCount,
                                  viewedStories: story.viewedStories,
                                ),
                                child: Container(
                                  width: 64,
                                  height: 64,
                                ),
                              );
                            },
                          )
                        else if (!story.isAddStory)
                          CustomPaint(
                            painter: ViewedStoryRingPainter(
                              storyCount: story.storyCount,
                              viewedStories: story.viewedStories,
                            ),
                            child: Container(
                              width: 64,
                              height: 64,
                            ),
                          ),

                        // Profile image
                        Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(story.avatarUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        // Add story button
                        if (story.isAddStory)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              story.username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryView(StoryData story) {
    return Stack(
      children: [
        // Story content
        Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder for story content
                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple.shade400,
                        Colors.orange.shade400,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      story.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Story header
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(story.avatarUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  story.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '3h',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    _selectStory(-1);
                  },
                ),
              ],
            ),
          ),
        ),

        // Story progress indicator
        Positioned(
          top: 8,
          left: 8,
          right: 8,
          child: Row(
            children: List.generate(
              story.storyCount,
                  (i) => Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i == 0
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Story reply
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Send message',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send_outlined, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeed() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildFeedItem(index);
      },
    );
  }

  Widget _buildFeedItem(int index) {
    final userIndex = (index + 2) % _stories.length;
    final story = _stories[userIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(story.avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                story.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Post image
        AspectRatio(
          aspectRatio: 1.0,
          child: Image.network(
            'https://picsum.photos/seed/${index + 10}/500/500',
            fit: BoxFit.cover,
          ),
        ),

        // Post actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Likes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${1000 + index * 500} likes',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: story.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: ' Having a great day! #instagram #stories',
                ),
              ],
            ),
          ),
        ),

        // View comments
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'View all ${50 + index * 20} comments',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),

        // Time
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            '${index + 1} HOURS AGO',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

class StoryRingPainter extends CustomPainter {
  final double rotation;
  final int storyCount;
  final List<int>? viewedStories;

  StoryRingPainter({
    required this.rotation,
    required this.storyCount,
    this.viewedStories,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create gradient shader
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      transform: GradientRotation(2 * math.pi * rotation),
      colors: const [
        Color(0xFFFCAF45), // Instagram yellow
        Color(0xFFE95950), // Instagram red
        Color(0xFFBC2A8D), // Instagram purple
        Color(0xFF5851DB), // Instagram blue
        Color(0xFFFCAF45), // Instagram yellow again to complete the loop
      ],
    ).createShader(rect);

    // Draw story segments
    if (storyCount > 1) {
      final segmentAngle = 2 * math.pi / storyCount;
      final segmentGap = 0.02; // Gap between segments in radians

      for (int i = 0; i < storyCount; i++) {
        final isViewed = viewedStories?.contains(i) ?? false;

        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0
          ..strokeCap = StrokeCap.round;

        if (isViewed) {
          paint.color = Colors.grey.shade400;
        } else {
          paint.shader = gradient;
        }

        final startAngle = i * segmentAngle + segmentGap / 2;
        final sweepAngle = segmentAngle - segmentGap;

        canvas.drawArc(
          rect,
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }
    } else {
      // Single story, draw full circle
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..shader = gradient;

      canvas.drawCircle(center, radius - 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StoryRingPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.storyCount != storyCount ||
        oldDelegate.viewedStories != viewedStories;
  }
}

class ViewedStoryRingPainter extends CustomPainter {
  final int storyCount;
  final List<int>? viewedStories;

  ViewedStoryRingPainter({
    required this.storyCount,
    this.viewedStories,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create paint for viewed stories
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.grey.shade400;

    // Draw story segments
    if (storyCount > 1) {
      final segmentAngle = 2 * math.pi / storyCount;
      final segmentGap = 0.02; // Gap between segments in radians

      for (int i = 0; i < storyCount; i++) {
        final startAngle = i * segmentAngle + segmentGap / 2;
        final sweepAngle = segmentAngle - segmentGap;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius - 1.5),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }
    } else {
      // Single story, draw full circle
      canvas.drawCircle(center, radius - 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ViewedStoryRingPainter oldDelegate) {
    return oldDelegate.storyCount != storyCount ||
        oldDelegate.viewedStories != viewedStories;
  }
}

class StoryData {
  final String username;
  final String avatarUrl;
  bool hasUnseenStories;
  final bool isAddStory;
  final int storyCount;
  List<int>? viewedStories;

  StoryData({
    required this.username,
    required this.avatarUrl,
    required this.hasUnseenStories,
    required this.isAddStory,
    required this.storyCount,
    this.viewedStories,
  });
}