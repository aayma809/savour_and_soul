import 'package:flutter/material.dart';
import 'package:savour_and_soul/checkoutscreen.dart';

class _MenuItem {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final String? badge;
  final String category;

  const _MenuItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    this.badge,
  });
}

// Formats a raw number as "Rs. 9,450" style currency.
String _formatPrice(num value) {
  final String digits = value.toStringAsFixed(0);
  final StringBuffer grouped = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    final int posFromEnd = digits.length - i;
    grouped.write(digits[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) {
      grouped.write(',');
    }
  }
  return 'Rs. $grouped';
}

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

  // 'All' plus the sections we render, in display order.
  final List<String> _categories = [
    'All',
    'Starters',
    'Mains',
    'Desserts',
    'Beverages',
  ];

  final TextEditingController _searchController = TextEditingController();

  // Cart state: item title -> quantity. Lives on the screen so it persists
  // across category switches and scrolling.
  final Map<String, int> _cart = {};

  // ---------------------------------------------------------------------
  // MENU DATA
  // ---------------------------------------------------------------------
  final List<_MenuItem> _menuItems = const [
    // Starters ------------------------------------------------------
    _MenuItem(
      category: 'Starters',
      imageUrl:
          'https://houseofnasheats.com/wp-content/uploads/2021/06/Heirloom-Tomato-Salad-6.jpg',
      title: 'Heirloom Burrata Salad',
      description:
          'Creamy artisan burrata, vine-ripened tomatoes, torn basil, aged balsamic...',
      price: 5000,
    ),
    _MenuItem(
      category: 'Starters',
      imageUrl:
          'https://images.unsplash.com/photo-1575840925760-d98bb91c7f7b?auto=format&fit=crop&w=1200&q=85',
      title: 'Charred Octopus Carpaccio',
      description:
          'Thinly sliced octopus, chili oil, pickled fennel, citrus gremolata...',
      price: 4600,
    ),

    // Mains -----------------------------------------------------------
    _MenuItem(
      category: 'Mains',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThz3LHQ92kQ6x3vns1uaTJEe2ZsC-Ah6WcaSWgwvwqHQ&s=10',
      title: 'Wood-Fired Branzino',
      description:
          'Whole Mediterranean sea bass, blistered cherry tomatoes, caper...',
      price: 9450,
      badge: "Chef's Special",
    ),
    _MenuItem(
      category: 'Mains',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzvZayg1TQVpIkXBvKv3WPI7jLkvpSry83WluDLM1xLA&s=10',
      title: 'Truffle Mushroom Risotto',
      description:
          'Arborio rice, wild foraged mushrooms, parmigiano-reggiano, and shaved...',
      price: 7200,
    ),

    // Desserts --------------------------------------------------------
    _MenuItem(
      category: 'Desserts',
      imageUrl:
          'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=800&q=80',
      title: 'Valrhona Chocolate Fondant',
      description:
          'Molten dark chocolate cake, vanilla bean gelato, gold leaf, hazelnut...',
      price: 3800,
    ),
    _MenuItem(
      category: 'Desserts',
      imageUrl:
          'https://images.unsplash.com/photo-1567327613485-fbc7bf196198?w=800&q=80',
      title: 'Basque Burnt Cheesecake',
      description:
          'Caramelized crust, silky center, macerated berries, mint...',
      price: 3400,
      badge: "Chef's Special",
    ),

    // Beverages ---------------------------------------------------------
    _MenuItem(
      category: 'Beverages',
      imageUrl:
          'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=800&q=80',
      title: 'Sicilian Blood Orange Spritz',
      description:
          'Blood orange, prosecco, elderflower tonic, fresh rosemary...',
      price: 2200,
    ),
    _MenuItem(
      category: 'Beverages',
      imageUrl:
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=800&q=80',
      title: 'Single-Origin Cold Brew',
      description: 'Slow-steeped Ethiopian beans, oat milk foam, cacao dust...',
      price: 1400,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------------
  // CART HELPERS
  // -----------------------------------------------------------------
  int get _cartItemCount => _cart.values.fold(0, (sum, qty) => sum + qty);

  double get _cartTotal {
    double total = 0;
    for (final entry in _cart.entries) {
      final item = _menuItems.firstWhere((i) => i.title == entry.key);
      total += item.price * entry.value;
    }
    return total;
  }

  void _addToCart(_MenuItem item) {
    setState(() {
      _cart.update(item.title, (qty) => qty + 1, ifAbsent: () => 1);
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 900),
          behavior: SnackBarBehavior.floating,
          backgroundColor: deepGreen,
          margin: const EdgeInsets.only(bottom: 90, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text('${item.title} added to cart'),
        ),
      );
  }

  void _incrementItem(_MenuItem item) {
    setState(() {
      _cart.update(item.title, (qty) => qty + 1, ifAbsent: () => 1);
    });
  }

  void _decrementItem(_MenuItem item) {
    setState(() {
      final current = _cart[item.title] ?? 0;
      if (current <= 1) {
        _cart.remove(item.title);
      } else {
        _cart[item.title] = current - 1;
      }
    });
  }

  void _openCartSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final entries = _cart.entries.toList();
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: bgCream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: fieldBorder,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const Text(
                    'Your Order',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: deepGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (entries.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Your cart is empty.',
                        style: TextStyle(color: subtitleText, fontSize: 14),
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.45,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: entries.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final title = entries[index].key;
                          final qty = entries[index].value;
                          final item = _menuItems.firstWhere(
                            (i) => i.title == title,
                          );
                          return Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.imageUrl,
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.5,
                                        color: darkText,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatPrice(item.price),
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: subtitleText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildQuantityStepper(
                                qty: qty,
                                onDecrement: () {
                                  _decrementItem(item);
                                  setSheetState(() {});
                                },
                                onIncrement: () {
                                  _incrementItem(item);
                                  setSheetState(() {});
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 18),
                  if (entries.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: darkText,
                          ),
                        ),
                        Text(
                          _formatPrice(_cartTotal),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: deepGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(this.context).push(
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(
                                items: entries.map((entry) {
                                  final item = _menuItems.firstWhere(
                                    (menuItem) => menuItem.title == entry.key,
                                  );
                                  return CheckoutItem(
                                    title: item.title,
                                    imageUrl: item.imageUrl,
                                    price: item.price,
                                    quantity: entry.value,
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deepGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Groups items by category, preserving the order defined in _categories.
  Map<String, List<_MenuItem>> get _groupedItems {
    final Map<String, List<_MenuItem>> grouped = {};
    for (final category in _categories.skip(1)) {
      grouped[category] = _menuItems
          .where((item) => item.category == category)
          .toList();
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabel = _categories[_selectedCategory];
    final grouped = _groupedItems;

    // Which sections to render: all of them for "All", or just the one picked.
    final sectionsToShow = selectedLabel == 'All'
        ? grouped.keys.toList()
        : [selectedLabel];

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
            for (final section in sectionsToShow) ...[
              _buildSectionHeader(section),
              const SizedBox(height: 14),
              for (final item in grouped[section] ?? []) ...[
                _buildMenuCard(item),
                const SizedBox(height: 22),
              ],
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: _cartItemCount == 0
              ? const SizedBox(width: double.infinity, height: 0)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: _buildCartBar(),
                ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // BOTTOM CART BAR
  // ---------------------------------------------------------------------
  Widget _buildCartBar() {
    return GestureDetector(
      onTap: _openCartSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: deepGreen,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$_cartItemCount',
                    style: const TextStyle(
                      color: deepGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _cartItemCount == 1 ? '1 item' : '$_cartItemCount items',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  _formatPrice(_cartTotal),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
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
        Row(
          children: [
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
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _cartItemCount == 0 ? null : _openCartSheet,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
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
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: darkText,
                      size: 19,
                    ),
                  ),
                  if (_cartItemCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: terracotta,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$_cartItemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
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
  // SECTION HEADER (Starters / Mains / Desserts / Beverages)
  // ---------------------------------------------------------------------
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: deepGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 1, color: fieldBorder)),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // QUANTITY STEPPER (used on cards and in the cart sheet)
  // ---------------------------------------------------------------------
  Widget _buildQuantityStepper({
    required int qty,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: deepGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.remove, color: Colors.white, size: 16),
            ),
          ),
          SizedBox(
            width: 20,
            child: Text(
              '$qty',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // MENU CARD
  // ---------------------------------------------------------------------
  Widget _buildMenuCard(_MenuItem item) {
    bool isFavorited = false;
    final imageUrl = item.imageUrl;
    final title = item.title;
    final description = item.description;
    final badge = item.badge;

    return StatefulBuilder(
      builder: (context, setCardState) {
        final int qty = _cart[item.title] ?? 0;
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
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE8E1D6),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.restaurant,
                          color: deepGreen,
                          size: 36,
                        ),
                      ),
                    ),
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
                  _formatPrice(item.price),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                qty == 0
                    ? GestureDetector(
                        onTap: () {
                          _addToCart(item);
                          setCardState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: deepGreen,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: deepGreen.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Add to Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _buildQuantityStepper(
                        qty: qty,
                        onDecrement: () {
                          _decrementItem(item);
                          setCardState(() {});
                        },
                        onIncrement: () {
                          _incrementItem(item);
                          setCardState(() {});
                        },
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}
