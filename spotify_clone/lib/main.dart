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
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1DB954), // Spotify green
        scaffoldBackgroundColor: const Color(0xFF121212), // Spotify dark background
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const SpotifyPlayerScreen(),
    );
  }
}

class SpotifyPlayerScreen extends StatefulWidget {
  const SpotifyPlayerScreen({Key? key}) : super(key: key);

  @override
  State<SpotifyPlayerScreen> createState() => _SpotifyPlayerScreenState();
}

class _SpotifyPlayerScreenState extends State<SpotifyPlayerScreen> with TickerProviderStateMixin {
  // Player state
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _volume = 0.7;
  bool _isShuffle = false;
  int _repeatMode = 0; // 0: off, 1: repeat all, 2: repeat one

  // Animation controllers
  late AnimationController _playbackController;
  late AnimationController _albumRotationController;
  late AnimationController _demoController;

  // Demo step
  int _demoStep = 0;

  // Song data
  final List<SongData> _songs = [
    SongData(
      title: "Blinding Lights",
      artist: "The Weeknd",
      album: "After Hours",
      duration: const Duration(minutes: 3, seconds: 22),
      albumColor: Colors.red,
    ),
    SongData(
      title: "As It Was",
      artist: "Harry Styles",
      album: "Harry's House",
      duration: const Duration(minutes: 2, seconds: 47),
      albumColor: Colors.blue,
    ),
    SongData(
      title: "Heat Waves",
      artist: "Glass Animals",
      album: "Dreamland",
      duration: const Duration(minutes: 3, seconds: 59),
      albumColor: Colors.orange,
    ),
  ];

  int _currentSongIndex = 0;

  SongData get _currentSong => _songs[_currentSongIndex];

  @override
  void initState() {
    super.initState();

    // Initialize playback controller for progress bar animation
    _playbackController = AnimationController(
      vsync: this,
      duration: _currentSong.duration,
    );

    _playbackController.addListener(() {
      setState(() {
        _currentPosition = _playbackController.value;
      });
    });

    // Initialize album rotation controller
    _albumRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
      // Start playing
      _togglePlay();
      setState(() {
        _demoStep = 1;
      });
    } else if (progress >= 0.1 && progress < 0.2 && _demoStep == 1) {
      // Adjust volume
      setState(() {
        _volume = 0.4;
        _demoStep = 2;
      });
    } else if (progress >= 0.2 && progress < 0.3 && _demoStep == 2) {
      // Adjust volume back
      setState(() {
        _volume = 0.8;
        _demoStep = 3;
      });
    } else if (progress >= 0.3 && progress < 0.4 && _demoStep == 3) {
      // Skip to next song
      _nextSong();
      setState(() {
        _demoStep = 4;
      });
    } else if (progress >= 0.4 && progress < 0.5 && _demoStep == 4) {
      // Toggle shuffle
      _toggleShuffle();
      setState(() {
        _demoStep = 5;
      });
    } else if (progress >= 0.5 && progress < 0.6 && _demoStep == 5) {
      // Toggle repeat
      _toggleRepeat();
      setState(() {
        _demoStep = 6;
      });
    } else if (progress >= 0.6 && progress < 0.7 && _demoStep == 6) {
      // Skip to previous song
      _previousSong();
      setState(() {
        _demoStep = 7;
      });
    } else if (progress >= 0.7 && progress < 0.8 && _demoStep == 7) {
      // Drag progress bar
      setState(() {
        _currentPosition = 0.7;
        _playbackController.value = 0.7;
        _demoStep = 8;
      });
    } else if (progress >= 0.8 && progress < 0.9 && _demoStep == 8) {
      // Pause playback
      if (_isPlaying) _togglePlay();
      setState(() {
        _demoStep = 9;
      });
    } else if (progress >= 0.9 && _demoStep == 9) {
      // Restart demo
      setState(() {
        _currentPosition = 0.0;
        _playbackController.value = 0.0;
        _currentSongIndex = 0;
        _isPlaying = false;
        _isShuffle = false;
        _repeatMode = 0;
        _volume = 0.7;
        _demoStep = 0;
        _demoController.reset();
        _demoController.forward();
      });
    }
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;

      if (_isPlaying) {
        _playbackController.forward();
        _albumRotationController.repeat();
      } else {
        _playbackController.stop();
        _albumRotationController.stop();
      }
    });
  }

  void _nextSong() {
    setState(() {
      _currentSongIndex = (_currentSongIndex + 1) % _songs.length;
      _currentPosition = 0.0;
      _playbackController.duration = _currentSong.duration;
      _playbackController.reset();

      if (_isPlaying) {
        _playbackController.forward();
      }
    });
  }

  void _previousSong() {
    setState(() {
      _currentSongIndex = (_currentSongIndex - 1 + _songs.length) % _songs.length;
      _currentPosition = 0.0;
      _playbackController.duration = _currentSong.duration;
      _playbackController.reset();

      if (_isPlaying) {
        _playbackController.forward();
      }
    });
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }

  void _toggleRepeat() {
    setState(() {
      _repeatMode = (_repeatMode + 1) % 3;
    });
  }

  void _seekTo(double value) {
    setState(() {
      _currentPosition = value;
      _playbackController.value = value;
    });
  }

  void _updateVolume(double value) {
    setState(() {
      _volume = value;
    });
  }

  @override
  void dispose() {
    _playbackController.dispose();
    _albumRotationController.dispose();
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _currentSong.albumColor.withOpacity(0.6),
                  const Color(0xFF121212),
                ],
                stops: const [0.0, 0.4],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // App bar
                _buildAppBar(),

                // Album art and song info
                Expanded(
                  child: _buildAlbumAndInfo(),
                ),

                // Playback controls
                _buildPlaybackControls(),

                // Bottom navigation
                _buildBottomNavigation(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: () {},
          ),
          const Expanded(
            child: Center(
              child: Text(
                'NOW PLAYING',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumAndInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Album art
          Expanded(
            flex: 3,
            child: Center(
              child: AnimatedBuilder(
                animation: _albumRotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _isPlaying ? _albumRotationController.value * 2 * math.pi : 0,
                    child: child,
                  );
                },
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomPaint(
                      painter: AlbumArtPainter(
                        color: _currentSong.albumColor,
                        title: _currentSong.title,
                        artist: _currentSong.artist,
                      ),
                      size: const Size(280, 280),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Song info
          Column(
            children: [
              Text(
                _currentSong.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _currentSong.artist,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls() {
    final duration = _currentSong.duration;
    final position = Duration(
      milliseconds: (duration.inMilliseconds * _currentPosition).round(),
    );

    final remainingTime = duration - position;

    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes);
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return '$minutes:$seconds';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Progress bar
          Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                  activeTrackColor: Theme.of(context).primaryColor,
                  inactiveTrackColor: Colors.white.withOpacity(0.2),
                  thumbColor: Colors.white,
                  overlayColor: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
                child: Slider(
                  value: _currentPosition,
                  onChanged: _seekTo,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDuration(position),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '-${formatDuration(remainingTime)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  _isShuffle ? Icons.shuffle : Icons.shuffle,
                  color: _isShuffle ? Theme.of(context).primaryColor : Colors.white.withOpacity(0.7),
                ),
                onPressed: _toggleShuffle,
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 32),
                onPressed: _previousSong,
              ),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                    color: Colors.black,
                  ),
                  onPressed: _togglePlay,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 32),
                onPressed: _nextSong,
              ),
              IconButton(
                icon: Icon(
                  _repeatMode == 0 ? Icons.repeat : _repeatMode == 1 ? Icons.repeat : Icons.repeat_one,
                  color: _repeatMode == 0 ? Colors.white.withOpacity(0.7) : Theme.of(context).primaryColor,
                ),
                onPressed: _toggleRepeat,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Volume control
          Row(
            children: [
              const Icon(Icons.volume_down, size: 20),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 4,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 10,
                    ),
                    activeTrackColor: Colors.white.withOpacity(0.7),
                    inactiveTrackColor: Colors.white.withOpacity(0.2),
                    thumbColor: Colors.white,
                    overlayColor: Colors.white.withOpacity(0.1),
                  ),
                  child: Slider(
                    value: _volume,
                    onChanged: _updateVolume,
                  ),
                ),
              ),
              const Icon(Icons.volume_up, size: 20),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Home', false),
          _buildNavItem(Icons.search, 'Search', false),
          _buildNavItem(Icons.library_music, 'Your Library', false),
          _buildNavItem(Icons.music_note, 'Premium', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? Theme.of(context).primaryColor : Colors.white.withOpacity(0.7),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Theme.of(context).primaryColor : Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class SongData {
  final String title;
  final String artist;
  final String album;
  final Duration duration;
  final Color albumColor;

  SongData({
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.albumColor,
  });
}

class AlbumArtPainter extends CustomPainter {
  final Color color;
  final String title;
  final String artist;

  AlbumArtPainter({
    required this.color,
    required this.title,
    required this.artist,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final Paint backgroundPaint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Add some visual interest with gradient overlay
    final Paint gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.black.withOpacity(0.7),
          Colors.transparent,
          Colors.black.withOpacity(0.5),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), gradientPaint);

    // Add a vinyl record effect
    final Paint recordPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double recordSize = size.width * 0.8;
    final double recordX = (size.width - recordSize) / 2;
    final double recordY = (size.height - recordSize) / 2;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      recordSize / 2,
      recordPaint,
    );

    // Add vinyl grooves
    final Paint groovePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double radius = recordSize / 2 - 10; radius > recordSize / 6; radius -= 5) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius,
        groovePaint,
      );
    }

    // Add center hole
    final Paint holePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      recordSize / 16,
      holePaint,
    );

    // Add title text at the bottom
    final titleStyle = TextStyle(
      color: Colors.white,
      fontSize: size.width * 0.08,
      fontWeight: FontWeight.bold,
    );

    final titleSpan = TextSpan(
      text: title,
      style: titleStyle,
    );

    final titlePainter = TextPainter(
      text: titleSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    titlePainter.layout(
      minWidth: 0,
      maxWidth: size.width * 0.9,
    );

    final xCenter = (size.width - titlePainter.width) / 2;
    final yPosition = size.height - titlePainter.height - 40;

    titlePainter.paint(canvas, Offset(xCenter, yPosition));

    // Add artist text below title
    final artistStyle = TextStyle(
      color: Colors.white.withOpacity(0.7),
      fontSize: size.width * 0.05,
    );

    final artistSpan = TextSpan(
      text: artist,
      style: artistStyle,
    );

    final artistPainter = TextPainter(
      text: artistSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    artistPainter.layout(
      minWidth: 0,
      maxWidth: size.width * 0.9,
    );

    final artistX = (size.width - artistPainter.width) / 2;
    final artistY = yPosition + titlePainter.height + 5;

    artistPainter.paint(canvas, Offset(artistX, artistY));
  }

  @override
  bool shouldRepaint(covariant AlbumArtPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.title != title ||
        oldDelegate.artist != artist;
  }
}