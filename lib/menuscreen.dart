import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const Color deepGreen = Color(0xFF2F5645);
  static const Color darkText = Color(0xFF1C1C1A);
  static const Color subtitleText = Color(0xFF8A8A82);
  static const Color bgCream = Color(0xFFF7F3EE);
  static const Color fieldBorder = Color(0xFFE1DDD3);
  static const Color terracotta = Color(0xFFB5622E);

  int _selectedCategory = 0;
  final List<String> _categories = ['All', 'Starters', 'Mains', 'Desserts'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),
            _buildHeader(),
            const SizedBox(height: 18),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildCategoryChips(),
            const SizedBox(height: 22),
            _buildMenuCard(
              imageUrl:
                  'https://houseofnasheats.com/wp-content/uploads/2021/06/Heirloom-Tomato-Salad-6.jpg',
              title: 'Heirloom Burrata Salad',
              description:
                  'Creamy artisan burrata, vine-ripened tomatoes, torn basil, aged balsamic...',
              price: 'Rs. 5,000',
              badge: null,
            ),
            const SizedBox(height: 22),
            _buildMenuCard(
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThz3LHQ92kQ6x3vns1uaTJEe2ZsC-Ah6WcaSWgwvwqHQ&s=10',
              title: 'Wood-Fired Branzino',
              description:
                  'Whole Mediterranean sea bass, blistered cherry tomatoes, caper...',
              price: 'Rs. 9,450',
              badge: "Chef's Special",
            ),
            const SizedBox(height: 22),
            _buildMenuCard(
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzvZayg1TQVpIkXBvKv3WPI7jLkvpSry83WluDLM1xLA&s=10',
              title: 'Truffle Mushroom Risotto',
              description:
                  'Arborio rice, wild foraged mushrooms, parmigiano-reggiano, and shaved...',
              price: 'Rs. 7,200',
              badge: null,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // HEADER: Title + filter icon
  // ---------------------------------------------------------------------
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'The Menu',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: deepGreen,
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.tune, color: darkText, size: 20),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // SEARCH BAR
  // ---------------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fieldBorder, width: 1.2),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14.5, color: darkText),
        decoration: const InputDecoration(
          hintText: 'Search culinary delights...',
          hintStyle: TextStyle(color: subtitleText, fontSize: 14.5),
          prefixIcon: Icon(Icons.search, color: subtitleText, size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // CATEGORY CHIPS
  // ---------------------------------------------------------------------
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final bool isSelected = index == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? deepGreen : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? deepGreen : fieldBorder,
                  width: 1.2,
                ),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : darkText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------
  // MENU CARD
  // ---------------------------------------------------------------------
  Widget _buildMenuCard({
    required String imageUrl,
    required String title,
    required String description,
    required String price,
    String? badge,
  }) {
    bool isFavorited = false;

    return StatefulBuilder(
      builder: (context, setCardState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                  if (badge != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: terracotta,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        setCardState(() => isFavorited = !isFavorited);
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.redAccent : darkText,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: deepGreen,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: subtitleText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: add item to cart/order
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: deepGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
