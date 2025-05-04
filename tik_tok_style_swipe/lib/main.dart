import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const TikTokCloneScreen(),
    );
  }
}

class TikTokCloneScreen extends StatefulWidget {
  const TikTokCloneScreen({Key? key}) : super(key: key);

  @override
  State<TikTokCloneScreen> createState() => _TikTokCloneScreenState();
}

class _TikTokCloneScreenState extends State<TikTokCloneScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isPlaying = true;

  // Demo videos data
  final List<VideoData> _videos = [
    VideoData(
      username: '@traveler',
      description: 'Exploring the beautiful beaches of Bali! 🏝️ #travel #bali',
      songName: 'Summer Vibes - Beach Tunes',
      likes: '245.6K',
      comments: '1.2K',
      shares: '18.5K',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      isFollowing: true,
      gradientColors: [Colors.blue, Colors.purple],
    ),
    VideoData(
      username: '@foodie',
      description: 'Making the perfect pasta carbonara 🍝 #food #recipe',
      songName: 'Italian Cooking - Chef\'s Playlist',
      likes: '89.3K',
      comments: '3.4K',
      shares: '5.2K',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      isFollowing: false,
      gradientColors: [Colors.orange, Colors.red],
    ),
    VideoData(
      username: '@dancer',
      description: 'New dance challenge! Try it yourself 💃 #dance #viral',
      songName: 'Beat Drop - DJ Mix',
      likes: '1.2M',
      comments: '24.5K',
      shares: '156.7K',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      isFollowing: true,
      gradientColors: [Colors.pink, Colors.deepPurple],
    ),
    VideoData(
      username: '@comedian',
      description: 'When your alarm goes off on Monday morning 😂 #funny #relatable',
      songName: 'Laugh Track - Comedy Central',
      likes: '567.8K',
      comments: '12.3K',
      shares: '45.6K',
      userAvatar: 'https://i.pravatar.cc/150?img=4',
      isFollowing: false,
      gradientColors: [Colors.green, Colors.teal],
    ),
  ];

  // Demo step for YouTube short
  int _demoStep = 0;

  @override
  void initState() {
    super.initState();
    _startDemoSequence();
  }

  void _startDemoSequence() {
    // Demo timeline for a 30-second YouTube short
    Future.delayed(const Duration(seconds: 2), () {
      // Scroll to next video
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      Future.delayed(const Duration(seconds: 5), () {
        // Toggle play/pause
        setState(() {
          _isPlaying = false;
          _demoStep = 1;
        });

        Future.delayed(const Duration(seconds: 2), () {
          // Resume playing
          setState(() {
            _isPlaying = true;
          });

          Future.delayed(const Duration(seconds: 2), () {
            // Show like animation
            setState(() {
              _demoStep = 2;
            });

            Future.delayed(const Duration(seconds: 2), () {
              // Scroll to next video
              _pageController.animateToPage(
                2,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );

              Future.delayed(const Duration(seconds: 5), () {
                // Show comment section
                setState(() {
                  _demoStep = 3;
                });

                Future.delayed(const Duration(seconds: 3), () {
                  // Hide comment section and scroll to next video
                  setState(() {
                    _demoStep = 0;
                  });

                  _pageController.animateToPage(
                    3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );

                  Future.delayed(const Duration(seconds: 5), () {
                    // Show share options
                    setState(() {
                      _demoStep = 4;
                    });

                    Future.delayed(const Duration(seconds: 3), () {
                      // Reset demo
                      setState(() {
                        _demoStep = 0;
                      });

                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTabButton('Following', _currentPage == 0),
            const SizedBox(width: 20),
            _buildTabButton('For You', _currentPage != 0),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Video feed
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                _isPlaying = true;
              });
            },
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              return _buildVideoPage(_videos[index], index);
            },
          ),

          // Bottom navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home, 'Home', true),
                  _buildNavItem(Icons.explore, 'Discover', false),
                  _buildAddVideoButton(),
                  _buildNavItem(Icons.inbox_outlined, 'Inbox', false),
                  _buildNavItem(Icons.person_outline, 'Me', false),
                ],
              ),
            ),
          ),

          // Comment section overlay
          if (_demoStep == 3)
            _buildCommentSection(),

          // Share options overlay
          if (_demoStep == 4)
            _buildShareOptions(),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool isActive) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildVideoPage(VideoData video, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video placeholder with gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: video.gradientColors,
            ),
          ),
          child: Center(
            child: _isPlaying && _currentPage == index
                ? const Icon(Icons.play_circle_outline, size: 80, color: Colors.white38)
                : const Icon(Icons.pause_circle_outline, size: 80, color: Colors.white38),
          ),
        ),

        // Video overlay for tap to play/pause
        GestureDetector(
          onTap: () {
            setState(() {
              _isPlaying = !_isPlaying;
            });
          },
          onDoubleTap: () {
            if (_demoStep != 2) {
              setState(() {
                _demoStep = 2;
                Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    _demoStep = 0;
                  });
                });
              });
            }
          },
          child: Container(
            color: Colors.transparent,
          ),
        ),

        // Video info overlay
        Positioned(
          left: 0,
          right: 80,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username
                Text(
                  video.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  video.description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                // Song info
                Row(
                  children: [
                    const Icon(Icons.music_note, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        video.songName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Right side action buttons
        Positioned(
          right: 10,
          bottom: 100,
          child: Column(
            children: [
              // Profile picture
              _buildProfileButton(video),
              const SizedBox(height: 20),
              // Like button
              _buildActionButton(
                Icons.favorite,
                video.likes,
                _demoStep == 2,
                Colors.red,
              ),
              const SizedBox(height: 20),
              // Comment button
              _buildActionButton(
                Icons.comment,
                video.comments,
                false,
                null,
              ),
              const SizedBox(height: 20),
              // Share button
              _buildActionButton(
                Icons.reply,
                video.shares,
                false,
                null,
                isFlipped: true,
              ),
              const SizedBox(height: 20),
              // Spinning record
              _buildSpinningRecord(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileButton(VideoData video) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(video.userAvatar),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: -5,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              size: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon,
      String count,
      bool isAnimating,
      Color? activeColor, {
        bool isFlipped = false,
      }) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Transform(
            alignment: Alignment.center,
            transform: isFlipped
                ? Matrix4.rotationY(math.pi)
                : Matrix4.identity(),
            child: Icon(
              icon,
              color: isAnimating ? activeColor : Colors.white,
              size: isAnimating ? 36 : 30,
            ),
          ),
        ),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isAnimating ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSpinningRecord() {
    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 4,
        ),
      ),
      child: AnimatedRotation(
        turns: _isPlaying ? 1.0 : 0.0,
        duration: const Duration(seconds: 3),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/150?img=5'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildAddVideoButton() {
    return Container(
      width: 48,
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.pink],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Container(
          width: 42,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Comment section header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_videos[_currentPage].comments})',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),

          // Comment list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildCommentItem(index);
              },
            ),
          ),

          // Comment input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white12),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${5 + _currentPage}'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Add comment...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.send,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(int index) {
    final comments = [
      'This is amazing! 😍',
      'I tried this and it worked perfectly!',
      'Can you do a tutorial on this?',
      'You\'re so talented! 👏',
      'Following for more content like this',
    ];

    final usernames = [
      '@user123',
      '@trendsetter',
      '@newbie42',
      '@superfan',
      '@creative_mind',
    ];

    final times = [
      '2h',
      '5h',
      '1d',
      '3d',
      '1w',
    ];

    final likes = [
      '1.2K',
      '458',
      '2.5K',
      '89',
      '3.1K',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${10 + index}'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usernames[index],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  comments[index],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      times[index],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Reply',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.favorite_outline, size: 16),
              const SizedBox(height: 2),
              Text(
                likes[index],
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptions() {
    final shareOptions = [
      {'icon': Icons.message, 'label': 'Messages'},
      {'icon': Icons.group, 'label': 'Groups'},
      {'icon': Icons.wallet, 'label': 'WhatsApp'},
      {'icon': Icons.facebook, 'label': 'Facebook'},
      {'icon': Icons.copy, 'label': 'Copy Link'},
      {'icon': Icons.bookmark_border, 'label': 'Save'},
      {'icon': Icons.ios_share, 'label': 'Share'},
      {'icon': Icons.report_outlined, 'label': 'Report'},
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Share to
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Share to',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Share options grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: shareOptions.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        shareOptions[index]['icon'] as IconData,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      shareOptions[index]['label'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Cancel button
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoData {
  final String username;
  final String description;
  final String songName;
  final String likes;
  final String comments;
  final String shares;
  final String userAvatar;
  final bool isFollowing;
  final List<Color> gradientColors;

  VideoData({
    required this.username,
    required this.description,
    required this.songName,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.userAvatar,
    required this.isFollowing,
    required this.gradientColors,
  });
}