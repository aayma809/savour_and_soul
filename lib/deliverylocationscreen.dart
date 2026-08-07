import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// Reuses the same palette as loginscreen.dart / signupscreen.dart
// ─────────────────────────────────────────────────────────────
class _AppColors {
  static const background = Color(0xFFFAF3EE);
  static const cardBackground = Color(0xFFFDF9F6);
  static const darkGreen = Color(0xFF2F4B3C);
  static const brown = Color(0xFF8B4226);
  static const textDark = Color(0xFF1F1F1F);
  static const textGrey = Color(0xFF9A9A9A);
  static const borderGrey = Color(0xFFE3DDD6);
  static const chipGrey = Color(0xFFEDEAE5);
}

// ─────────────────────────────────────────────────────────────
// Simple address model — swap for your real data source
// (e.g. fetched from Firestore per user) later.
// ─────────────────────────────────────────────────────────────
class SavedAddress {
  final String id;
  final String label;
  final IconData icon;
  final List<String> lines;

  const SavedAddress({
    required this.id,
    required this.label,
    required this.icon,
    required this.lines,
  });
}

class DeliveryLocationScreen extends StatefulWidget {
  const DeliveryLocationScreen({super.key});

  @override
  State<DeliveryLocationScreen> createState() => _DeliveryLocationScreenState();
}

class _DeliveryLocationScreenState extends State<DeliveryLocationScreen> {
  final _searchController = TextEditingController();

  // TODO: replace with addresses loaded from your backend / local storage.
  final List<SavedAddress> _addresses = const [
    SavedAddress(
      id: 'home',
      label: 'HOME',
      icon: Icons.home_outlined,
      lines: ['42 Cypress Avenue', 'Apt 3B', 'San Francisco, CA 94109'],
    ),
    SavedAddress(
      id: 'work',
      label: 'WORK',
      icon: Icons.work_outline,
      lines: ['850 Market Street', 'Floor 12', 'San Francisco, CA 94104'],
    ),
  ];

  String _selectedId = 'home';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _useCurrentLocation() {
    // TODO: hook up geolocator / location package here, reverse-geocode,
    // then either select a matching saved address or set a "current location"
    // pin as the selection.
  }

  void _editAddress(SavedAddress address) {
    // TODO: navigate to an edit-address form pre-filled with `address`.
  }

  void _deleteAddress(SavedAddress address) {
    setState(() {
      _addresses.removeWhere((a) => a.id == address.id);
      if (_selectedId == address.id && _addresses.isNotEmpty) {
        _selectedId = _addresses.first.id;
      }
    });
  }

  void _addNewAddress() {
    // TODO: navigate to an "add address" form, then insert result into
    // _addresses and setState.
  }

  void _confirmLocation() {
    // TODO: persist _selectedId as the active delivery address, then
    // Navigator.pop(context, _selectedId) or navigate to the next screen.
    Navigator.pop(context, _selectedId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Close button ──
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: _AppColors.textDark,
                        size: 26,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Title ──
                    const Text(
                      'Set Delivery\nLocation',
                      style: TextStyle(
                        fontFamily: 'Georgia', // swap for Playfair Display
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                        height: 1.15,
                        color: _AppColors.darkGreen,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Find the perfect spot to receive your artisanal '
                      'Mediterranean spread.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: _AppColors.textDark.withOpacity(0.75),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Search field ──
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: _AppColors.borderGrey),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          fontSize: 15,
                          color: _AppColors.textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search for your address...',
                          hintStyle: const TextStyle(
                            color: _AppColors.textGrey,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: _AppColors.textGrey,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Use current location ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _useCurrentLocation,
                        icon: const Icon(
                          Icons.my_location,
                          size: 18,
                          color: _AppColors.darkGreen,
                        ),
                        label: const Text(
                          'USE CURRENT LOCATION',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0.6,
                            color: _AppColors.textDark,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _AppColors.chipGrey,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Saved Addresses header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saved Addresses',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: _AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: _addNewAddress,
                          child: const Text(
                            'ADD NEW',
                            style: TextStyle(
                              color: _AppColors.darkGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ── Address cards ──
                    ..._addresses.map(
                      (address) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _AddressCard(
                          address: address,
                          selected: address.id == _selectedId,
                          onSelect: () =>
                              setState(() => _selectedId = address.id),
                          onEdit: () => _editAddress(address),
                          onDelete: () => _deleteAddress(address),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Confirm button (pinned at bottom) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addresses.isEmpty ? null : _confirmLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _AppColors.brown,
                    disabledBackgroundColor: _AppColors.brown.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'CONFIRM LOCATION',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
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

// ─────────────────────────────────────────────────────────────
// Single saved-address card
// ─────────────────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  final SavedAddress address;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.selected,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? _AppColors.brown : _AppColors.borderGrey,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selected
                            ? _AppColors.brown.withOpacity(0.12)
                            : _AppColors.chipGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        address.icon,
                        size: 18,
                        color: selected
                            ? _AppColors.brown
                            : _AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      address.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                        color: _AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected ? _AppColors.brown : _AppColors.textGrey,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 14),
            for (final line in address.lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  line,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: _AppColors.textDark.withOpacity(0.85),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            const Divider(color: _AppColors.borderGrey, height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 19,
                    color: _AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 18),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.delete_outline,
                    size: 19,
                    color: _AppColors.textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
