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
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const NetflixCloneScreen(),
    );
  }
}

class NetflixCloneScreen extends StatefulWidget {
  const NetflixCloneScreen({Key? key}) : super(key: key);

  @override
  State<NetflixCloneScreen> createState() => _NetflixCloneScreenState();
}

class _NetflixCloneScreenState extends State<NetflixCloneScreen> with TickerProviderStateMixin {
  // Selected movie index for each category
  Map<String, int> _selectedMovieIndices = {};

  // Animation controllers
  late AnimationController _demoController;

  // Demo step
  int _demoStep = 0;

  // Categories and movies data
  final List<CategoryData> _categories = [
    CategoryData(
      title: 'Trending Now',
      movies: [
        MovieData(
          title: 'Stranger Things',
          posterColor: Colors.red.shade900,
          year: '2022',
          ageRating: '16+',
          duration: '50m',
          matchPercentage: 98,
          genres: ['Sci-Fi', 'Horror', 'Drama'],
          description: 'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.',
        ),
        MovieData(
          title: 'The Witcher',
          posterColor: Colors.amber.shade900,
          year: '2021',
          ageRating: '18+',
          duration: '1h',
          matchPercentage: 95,
          genres: ['Fantasy', 'Action', 'Adventure'],
          description: 'Geralt of Rivia, a solitary monster hunter, struggles to find his place in a world where people often prove more wicked than beasts.',
        ),
        MovieData(
          title: 'Money Heist',
          posterColor: Colors.red.shade800,
          year: '2021',
          ageRating: '16+',
          duration: '45m',
          matchPercentage: 92,
          genres: ['Crime', 'Drama', 'Thriller'],
          description: 'Eight thieves take hostages and lock themselves in the Royal Mint of Spain as a criminal mastermind manipulates the police to carry out his plan.',
        ),
        MovieData(
          title: 'Squid Game',
          posterColor: Colors.green.shade900,
          year: '2021',
          ageRating: '18+',
          duration: '55m',
          matchPercentage: 97,
          genres: ['Thriller', 'Drama', 'Mystery'],
          description: 'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games. Inside, a tempting prize awaits — with deadly high stakes.',
        ),
        MovieData(
          title: 'Dark',
          posterColor: Colors.blueGrey.shade900,
          year: '2020',
          ageRating: '16+',
          duration: '1h',
          matchPercentage: 94,
          genres: ['Sci-Fi', 'Thriller', 'Mystery'],
          description: 'A missing child sets four families on a frantic hunt for answers as they unearth a mind-bending mystery that spans three generations.',
        ),
      ],
    ),
    CategoryData(
      title: 'Popular on Netflix',
      movies: [
        MovieData(
          title: 'The Queen\'s Gambit',
          posterColor: Colors.brown.shade800,
          year: '2020',
          ageRating: '16+',
          duration: '55m',
          matchPercentage: 96,
          genres: ['Drama', 'Historical'],
          description: 'In a 1950s orphanage, a young girl reveals an astonishing talent for chess and begins an unlikely journey to stardom while grappling with addiction.',
        ),
        MovieData(
          title: 'Bridgerton',
          posterColor: Colors.purple.shade900,
          year: '2022',
          ageRating: '16+',
          duration: '50m',
          matchPercentage: 93,
          genres: ['Romance', 'Drama', 'Historical'],
          description: 'The eight close-knit siblings of the Bridgerton family look for love and happiness in London high society.',
        ),
        MovieData(
          title: 'The Crown',
          posterColor: Colors.amber.shade800,
          year: '2022',
          ageRating: '16+',
          duration: '58m',
          matchPercentage: 95,
          genres: ['Drama', 'Historical', 'Biography'],
          description: 'This drama follows the political rivalries and romance of Queen Elizabeth II\'s reign and the events that shaped the second half of the 20th century.',
        ),
        MovieData(
          title: 'Ozark',
          posterColor: Colors.blue.shade900,
          year: '2022',
          ageRating: '18+',
          duration: '1h',
          matchPercentage: 94,
          genres: ['Crime', 'Drama', 'Thriller'],
          description: 'A financial adviser drags his family from Chicago to the Missouri Ozarks, where he must launder money to appease a drug boss.',
        ),
        MovieData(
          title: 'Peaky Blinders',
          posterColor: Colors.grey.shade900,
          year: '2022',
          ageRating: '18+',
          duration: '55m',
          matchPercentage: 97,
          genres: ['Crime', 'Drama'],
          description: 'A notorious gang in 1919 Birmingham, England, is led by the fierce Tommy Shelby, a crime boss set on moving up in the world no matter the cost.',
        ),
      ],
    ),
    CategoryData(
      title: 'New Releases',
      movies: [
        MovieData(
          title: 'Wednesday',
          posterColor: Colors.black,
          year: '2022',
          ageRating: '14+',
          duration: '45m',
          matchPercentage: 96,
          genres: ['Comedy', 'Fantasy', 'Mystery'],
          description: 'Smart, sarcastic and a little dead inside, Wednesday Addams investigates a murder spree while making new friends — and foes — at Nevermore Academy.',
        ),
        MovieData(
          title: '1899',
          posterColor: Colors.indigo.shade900,
          year: '2022',
          ageRating: '16+',
          duration: '55m',
          matchPercentage: 92,
          genres: ['Mystery', 'Horror', 'Sci-Fi'],
          description: 'Immigrants on a steamship traveling from London to New York get caught up in a mysterious riddle after finding a second vessel adrift on the open sea.',
        ),
        MovieData(
          title: 'The Sandman',
          posterColor: Colors.deepPurple.shade900,
          year: '2022',
          ageRating: '16+',
          duration: '50m',
          matchPercentage: 93,
          genres: ['Fantasy', 'Drama', 'Mystery'],
          description: 'After years of imprisonment, Morpheus — the King of Dreams — embarks on a journey across worlds to find what was stolen from him and restore his power.',
        ),
        MovieData(
          title: 'Dahmer',
          posterColor: Colors.brown.shade900,
          year: '2022',
          ageRating: '18+',
          duration: '50m',
          matchPercentage: 91,
          genres: ['Crime', 'Drama', 'Biography'],
          description: 'Across more than a decade, 17 teen boys and young men were murdered by convicted killer Jeffrey Dahmer. How did he evade arrest for so long?',
        ),
        MovieData(
          title: 'The Midnight Club',
          posterColor: Colors.teal.shade900,
          year: '2022',
          ageRating: '16+',
          duration: '50m',
          matchPercentage: 90,
          genres: ['Horror', 'Mystery', 'Drama'],
          description: 'At a hospice for terminally ill young adults, eight patients come together every night at midnight to tell each other stories — and make a pact.',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();

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
      _selectMovie('Trending Now', 0);
      setState(() {
        _demoStep = 2;
      });
    } else if (progress >= 0.2 && progress < 0.3 && _demoStep == 2) {
      _selectMovie('Trending Now', -1);
      setState(() {
        _demoStep = 3;
      });
    } else if (progress >= 0.3 && progress < 0.4 && _demoStep == 3) {
      _selectMovie('Popular on Netflix', 1);
      setState(() {
        _demoStep = 4;
      });
    } else if (progress >= 0.4 && progress < 0.5 && _demoStep == 4) {
      _selectMovie('Popular on Netflix', -1);
      setState(() {
        _demoStep = 5;
      });
    } else if (progress >= 0.5 && progress < 0.6 && _demoStep == 5) {
      _selectMovie('New Releases', 2);
      setState(() {
        _demoStep = 6;
      });
    } else if (progress >= 0.6 && progress < 0.7 && _demoStep == 6) {
      _selectMovie('New Releases', -1);
      setState(() {
        _demoStep = 7;
      });
    } else if (progress >= 0.7 && progress < 0.8 && _demoStep == 7) {
      _selectMovie('Trending Now', 3);
      setState(() {
        _demoStep = 8;
      });
    } else if (progress >= 0.8 && progress < 0.9 && _demoStep == 8) {
      _selectMovie('Trending Now', -1);
      setState(() {
        _demoStep = 9;
      });
    } else if (progress >= 0.9 && _demoStep == 9) {
      setState(() {
        _demoStep = 0;
        _demoController.reset();
        _demoController.forward();
      });
    }
  }

  void _selectMovie(String category, int index) {
    setState(() {
      if (index == -1) {
        _selectedMovieIndices.remove(category);
      } else {
        _selectedMovieIndices[category] = index;
      }
    });
  }

  @override
  void dispose() {
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
                  Colors.black,
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ],
              ),
            ),
          ),

          // Content
          CustomScrollView(
            slivers: [
              // App bar
              SliverAppBar(
                backgroundColor: Colors.black.withOpacity(0.5),
                floating: true,
                pinned: true,
                title: Row(
                  children: [
                    _buildNetflixLogo(),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.cast),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red.shade900,),
                        child: const Center(
                          child: Text(
                            'N',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                    ),
                  ],
                ),
              ),

              // Navigation tabs
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavTab('TV Shows', false),
                      _buildNavTab('Movies', false),
                      _buildNavTab('Categories', false),
                      _buildNavTab('Home', true),
                    ],
                  ),
                ),
              ),

              // Featured content
              SliverToBoxAdapter(
                child: _buildFeaturedContent(),
              ),

              // Categories
              ..._categories.map((category) {
                return SliverToBoxAdapter(
                  child: _buildMovieCategory(category),
                );
              }).toList(),

              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetflixLogo() {
    return const Text(
      'NETFLIX',
      style: TextStyle(
        color: Color(0xFFE50914),
        fontWeight: FontWeight.bold,
        fontSize: 26,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildNavTab(String title, bool isSelected) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildFeaturedContent() {
    return Stack(
      children: [
        // Featured image
        Container(
          height: 500,
          width: double.infinity,
          child: CustomPaint(
            painter: MoviePosterPainter(
              title: 'Stranger Things',
              color: Colors.red.shade900,
            ),
            size: const Size(double.infinity, 500),
          ),
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.8),
                Colors.black,
              ],
              stops: const [0.0, 0.6, 0.8, 1.0],
            ),
          ),
        ),

        // Featured content info
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Column(
            children: [
              // Title logo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'STRANGER THINGS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    letterSpacing: 2,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Info row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('2022'),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      '16+',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('4 Seasons'),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      'HD',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    icon: Icons.play_arrow,
                    label: 'Play',
                    isPrimary: true,
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: Icons.add,
                    label: 'My List',
                    isPrimary: false,
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: Icons.info_outline,
                    label: 'Info',
                    isPrimary: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return Column(
      children: [
        Container(
          width: isPrimary ? 100 : 60,
          height: 40,
          decoration: BoxDecoration(
            color: isPrimary ? Colors.white : Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.black : Colors.white,
                size: isPrimary ? 24 : 20,
              ),
              if (isPrimary) const SizedBox(width: 8),
              if (isPrimary)
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        if (!isPrimary)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMovieCategory(CategoryData category) {
    final selectedIndex = _selectedMovieIndices[category.title];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
          child: Text(
            category.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: selectedIndex != null ? 340 : 160,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: category.movies.length,
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              return _buildMovieCard(
                category.title,
                category.movies[index],
                index,
                isSelected,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(
      String category,
      MovieData movie,
      int index,
      bool isSelected,
      ) {
    return GestureDetector(
      onTap: () {
        _selectMovie(category, isSelected ? -1 : index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: isSelected ? 0 : 8,
        ),
        width: isSelected ? 300 : 110,
        height: isSelected ? 340 : 160,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Movie poster
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isSelected ? 8 : 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isSelected ? 8 : 4),
                      child: CustomPaint(
                        painter: MoviePosterPainter(
                          title: movie.title,
                          color: movie.posterColor,
                        ),
                        size: Size(isSelected ? 300 : 110, isSelected ? 340 : 160),
                      ),
                    ),
                  ),

                  // Gradient overlay
                  if (isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.9),
                            ],
                            stops: const [0.0, 0.6, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ),

                  // Movie info overlay
                  if (isSelected)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Info row
                            Row(
                              children: [
                                Text(
                                  '${movie.matchPercentage}% Match',
                                  style: TextStyle(
                                    color: Colors.green[400],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  movie.year,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    movie.ageRating,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  movie.duration,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Genres
                            Wrap(
                              spacing: 8,
                              children: movie.genres.map((genre) {
                                return Text(
                                  genre,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 8),

                            // Description
                            Text(
                              movie.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Action buttons
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              spacing: 16,
                              runSpacing: 10,
                              children: [
                                _buildCardActionButton(
                                  icon: Icons.play_arrow,
                                  label: 'Play',
                                ),
                                _buildCardActionButton(
                                  icon: Icons.add,
                                  label: 'My List',
                                ),
                                _buildCardActionButton(
                                  icon: Icons.thumb_up_outlined,
                                  label: 'Rate',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Title for non-selected cards
            if (!isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardActionButton({
    required IconData icon,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class CategoryData {
  final String title;
  final List<MovieData> movies;

  CategoryData({
    required this.title,
    required this.movies,
  });
}

class MovieData {
  final String title;
  final Color posterColor;
  final String year;
  final String ageRating;
  final String duration;
  final int matchPercentage;
  final List<String> genres;
  final String description;

  MovieData({
    required this.title,
    required this.posterColor,
    required this.year,
    required this.ageRating,
    required this.duration,
    required this.matchPercentage,
    required this.genres,
    required this.description,
  });
}

class MoviePosterPainter extends CustomPainter {
  final String title;
  final Color color;

  MoviePosterPainter({
    required this.title,
    required this.color,
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

    // Add Netflix "N" logo
    final Paint logoPaint = Paint()
      ..color = const Color(0xFFE50914)
      ..style = PaintingStyle.fill;

    final double logoSize = size.width * 0.2;
    final double logoX = (size.width - logoSize) / 2;

    final double logoY = (size.height - logoSize) / 2;

    // Draw a simplified "N" logo
    final Path path = Path()
      ..moveTo(logoX, logoY)
      ..lineTo(logoX, logoY + logoSize)
      ..lineTo(logoX + logoSize * 0.7, logoY + logoSize * 0.3)
      ..lineTo(logoX + logoSize * 0.7, logoY + logoSize)
      ..lineTo(logoX + logoSize, logoY + logoSize)
      ..lineTo(logoX + logoSize, logoY)
      ..lineTo(logoX + logoSize * 0.3, logoY + logoSize * 0.7)
      ..lineTo(logoX + logoSize * 0.3, logoY)
      ..close();

    canvas.drawPath(path, logoPaint);

    // Add title text at the bottom
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: size.width * 0.08,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: title,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width * 0.9,
    );

    final xCenter = (size.width - textPainter.width) / 2;
    final yPosition = size.height - textPainter.height - 10;

    textPainter.paint(canvas, Offset(xCenter, yPosition));
  }

  @override
  bool shouldRepaint(covariant MoviePosterPainter oldDelegate) {
    return oldDelegate.title != title || oldDelegate.color != color;
  }
}