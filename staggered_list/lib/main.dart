import 'package:flutter/material.dart';
import 'dart:async';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E72E4),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF5E72E4)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const StaggeredShoppingListDemo(),
    );
  }
}

class StaggeredShoppingListDemo extends StatefulWidget {
  const StaggeredShoppingListDemo({Key? key}) : super(key: key);

  @override
  State<StaggeredShoppingListDemo> createState() => _StaggeredShoppingListDemoState();
}

class _StaggeredShoppingListDemoState extends State<StaggeredShoppingListDemo> with TickerProviderStateMixin {
  // Animation controller
  late AnimationController _staggeredController;

  // List of products
  final List<Product> _products = [];

  // Demo state
  bool _isLoading = true;
  int _demoStep = 0;
  int _selectedIndex = -1;

  // Demo timer
  Timer? _demoTimer;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _staggeredController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Generate product data
    _generateProducts();

    // Start demo sequence
    _startDemoSequence();
  }

  void _generateProducts() {
    final List<String> productNames = [
      'Minimalist Sneakers',
      'Classic Watch',
      'Wireless Earbuds',
      'Slim Fit T-Shirt',
      'Leather Wallet',
      'Sunglasses',
      'Backpack',
      'Smart Water Bottle',
    ];

    final List<String> brands = [
      'Nordic',
      'Essence',
      'Aura',
      'Zenith',
      'Lumen',
      'Vertex',
      'Meridian',
      'Pulse',
    ];

    final random = math.Random();

    for (int i = 0; i < productNames.length; i++) {
      _products.add(
        Product(
          id: i,
          name: productNames[i],
          brand: brands[i],
          price: 29.99 + (random.nextDouble() * 70),
          rating: 3.5 + (random.nextDouble() * 1.5),
          reviewCount: 10 + random.nextInt(490),
          imageIndex: i % 8,
          isFavorite: random.nextBool(),
        ),
      );
    }
  }

  void _startDemoSequence() {
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });

      // Start staggered animation
      _staggeredController.forward();

      // Start demo timer
      _demoTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        // Demo timeline for a 30-second YouTube short
        switch (timer.tick) {
          case 3: // Select first item
            _selectItem(0);
            break;
          case 6: // Deselect and scroll
            _deselectItem();
            break;
          case 8: // Select another item
            _selectItem(2);
            break;
          case 11: // Toggle favorite
            _toggleFavorite(2);
            break;
          case 14: // Deselect and scroll more
            _deselectItem();
            break;
          case 16: // Select another item
            _selectItem(5);
            break;
          case 19: // Toggle favorite
            _toggleFavorite(5);
            break;
          case 22: // Deselect all
            _deselectItem();
            break;
          case 24: // Reset animation
            _resetAnimation();
            break;
          case 28: // Reset demo
            _resetDemo();
            break;
        }
      });
    });
  }

  void _selectItem(int index) {
    setState(() {
      _selectedIndex = index;
      _demoStep = 1;
    });
  }

  void _deselectItem() {
    setState(() {
      _selectedIndex = -1;
      _demoStep = 0;
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      _products[index].isFavorite = !_products[index].isFavorite;
      _demoStep = 2;
    });
  }

  void _resetAnimation() {
    _staggeredController.reset();
    _staggeredController.forward();
  }

  void _resetDemo() {
    setState(() {
      _selectedIndex = -1;
      _demoStep = 0;

      // Reset favorites
      for (int i = 0; i < _products.length; i++) {
        _products[i].isFavorite = math.Random().nextBool();
      }
    });

    _resetAnimation();
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    _demoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading ? _buildLoadingView() : _buildProductList(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF5E72E4),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading products...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category tabs
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('All', isSelected: true),
                _buildCategoryChip('Clothing'),
                _buildCategoryChip('Accessories'),
                _buildCategoryChip('Electronics'),
                _buildCategoryChip('Footwear'),
              ],
            ),
          ),
        ),

        // Instruction text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            _getInstructionText(),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),

        // Product list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              // Calculate delay for staggered animation
              final delay = index * 0.2;

              // Create staggered animation
              final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _staggeredController,
                  curve: Interval(
                    delay.clamp(0.0, 0.9),
                    (delay + 0.1).clamp(0.0, 1.0),
                    curve: Curves.easeOut,
                  ),
                ),
              );

              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: animation.value,
                    child: Transform.translate(
                      offset: Offset(0, 50 * (1 - animation.value)),
                      child: child,
                    ),
                  );
                },
                child: _buildProductCard(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: isSelected ? const Color(0xFF5E72E4) : Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final product = _products[index];
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (_selectedIndex == index) {
          _deselectItem();
        } else {
          _selectItem(index);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: isSelected
              ? Border.all(color: const Color(0xFF5E72E4), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image and favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _buildProductImage(product.imageIndex),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(index),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        product.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: product.isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    product.brand,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Product name
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < product.rating.floor()
                              ? Icons.star
                              : i < product.rating
                              ? Icons.star_half
                              : Icons.star_border,
                          color: const Color(0xFFFFC107),
                          size: 16,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price and add to cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF5E72E4),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5E72E4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(int index) {
    // Use a placeholder image with different colors based on index
    final List<Color> colors = [
      const Color(0xFFE3F2FD),
      const Color(0xFFE8F5E9),
      const Color(0xFFFFF3E0),
      const Color(0xFFE8EAF6),
      const Color(0xFFF3E5F5),
      const Color(0xFFE0F2F1),
      const Color(0xFFFBE9E7),
      const Color(0xFFF5F5F5),
    ];

    final List<IconData> icons = [
      Icons.directions_run,
      Icons.watch,
      Icons.headphones,
      Icons.style,
      Icons.account_balance_wallet,
      Icons.bubble_chart_outlined,
      Icons.backpack,
      Icons.local_drink,
    ];

    return Container(
      color: colors[index % colors.length],
      child: Center(
        child: Icon(
          icons[index % icons.length],
          size: 64,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  String _getInstructionText() {
    if (_demoStep == 0) {
      return 'Tap on a product to select it';
    } else if (_demoStep == 1) {
      return 'Tap the heart icon to add to favorites';
    } else {
      return 'Product added to favorites!';
    }
  }
}

class Product {
  final int id;
  final String name;
  final String brand;
  final double price;
  final double rating;
  final int reviewCount;
  final int imageIndex;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageIndex,
    required this.isFavorite,
  });
}