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
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRH_US_kJlhVhLsYcx_cbv32kNDeWct1xQkle1wkOfWhg&s=10',
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
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTk_vrSdLekX22d-prQOr9Gc7WfNDaKe_FyI6IahBzHOw&s=10',
      title: 'Valrhona Chocolate Fondant',
      description:
          'Molten dark chocolate cake, vanilla bean gelato, gold leaf, hazelnut...',
      price: 3800,
    ),
    _MenuItem(
      category: 'Desserts',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcsNsPRIqiGeGAViak2_FzUT_6tvolP7yrfwlipplvdw&s=10',
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
          'data:image/jpeg;base64,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',
      title: 'Sicilian Blood Orange Spritz',
      description:
          'Blood orange, prosecco, elderflower tonic, fresh rosemary...',
      price: 2200,
    ),
    _MenuItem(
      category: 'Beverages',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa3q5_w49DRRyim85fvXaEwRFgjj_WPE34fgc7oM06Vg&s=10',
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
