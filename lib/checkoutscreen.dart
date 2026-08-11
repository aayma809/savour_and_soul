import 'package:flutter/material.dart';

class CheckoutItem {
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  const CheckoutItem({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}

class CheckoutScreen extends StatefulWidget {
  final List<CheckoutItem> items;

  const CheckoutScreen({super.key, required this.items});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const Color _green = Color(0xFF2F5645);
  static const Color _cream = Color(0xFFF7F3EE);
  static const Color _ink = Color(0xFF1C1C1A);
  static const Color _muted = Color(0xFF7C7C73);
  static const Color _border = Color(0xFFE1DDD3);
  static const Color _terracotta = Color(0xFFB5622E);

  int _deliveryOption = 0;
  int _paymentOption = 0;
  bool _promoApplied = false;

  final TextEditingController _promoController = TextEditingController();

  double get _subtotal {
    return widget.items.fold(
      0,
      (total, item) => total + item.price * item.quantity,
    );
  }

  double get _deliveryFee {
    return _deliveryOption == 0 ? 350 : 0;
  }

  double get _discount {
    return _promoApplied ? _subtotal * 0.10 : 0;
  }

  double get _total {
    return _subtotal + _deliveryFee - _discount;
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  String _price(num value) {
    final digits = value.toStringAsFixed(0);
    final chars = <String>[];

    for (var i = 0; i < digits.length; i++) {
      chars.add(digits[i]);

      final remaining = digits.length - i - 1;

      if (remaining > 0 && remaining % 3 == 0) {
        chars.add(',');
      }
    }

    return 'Rs. ${chars.join()}';
  }

  void _applyPromo() {
    if (_promoController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _promoApplied = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('10% welcome offer applied.')));
  }

  void _placeOrder() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 30, 28, 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2EEE6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: _green,
                    size: 38,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Order confirmed!',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: _green,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Your table is being prepared with care. '
                  'We’ll let you know when it’s on its way.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, height: 1.45),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'BACK TO MENU',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: _ink,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        color: _green,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.lock_outline_rounded,
                    color: _green,
                    size: 20,
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  _sectionTitle('Delivering to'),

                  const SizedBox(height: 12),

                  _card(
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: _green.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.home_outlined, color: _green),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'HOME',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.7,
                                  color: _green,
                                ),
                              ),

                              SizedBox(height: 3),

                              Text(
                                '850 Market Street, Floor 12\n'
                                'San Francisco, CA 94104',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  height: 1.35,
                                  color: _muted,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(Icons.chevron_right_rounded, color: _muted),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  _sectionTitle('Delivery time'),

                  const SizedBox(height: 12),

                  _choiceCard(
                    index: 0,
                    current: _deliveryOption,
                    onTap: () {
                      setState(() {
                        _deliveryOption = 0;
                      });
                    },
                    icon: Icons.delivery_dining_outlined,
                    title: 'Standard delivery',
                    subtitle: '30–40 min',
                    trailing: _price(350),
                  ),

                  const SizedBox(height: 10),

                  _choiceCard(
                    index: 1,
                    current: _deliveryOption,
                    onTap: () {
                      setState(() {
                        _deliveryOption = 1;
                      });
                    },
                    icon: Icons.schedule_outlined,
                    title: 'Schedule for later',
                    subtitle: 'Choose a convenient time',
                    trailing: 'Free',
                  ),

                  const SizedBox(height: 26),

                  _sectionTitle('Your order'),

                  const SizedBox(height: 12),

                  _card(
                    child: Column(
                      children: [
                        for (var i = 0; i < widget.items.length; i++) ...[
                          _orderLine(widget.items[i]),

                          if (i != widget.items.length - 1)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Divider(height: 1, color: _border),
                            ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  _sectionTitle('Promo code'),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _promoApplied ? _green : _border,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),

                        const Icon(
                          Icons.local_offer_outlined,
                          color: _muted,
                          size: 20,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: TextField(
                            controller: _promoController,
                            enabled: !_promoApplied,
                            decoration: const InputDecoration(
                              hintText: 'Enter promo code',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),

                        TextButton(
                          onPressed: _promoApplied ? null : _applyPromo,
                          child: Text(
                            _promoApplied ? 'APPLIED' : 'APPLY',
                            style: const TextStyle(
                              color: _green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  _sectionTitle('Payment method'),

                  const SizedBox(height: 12),

                  _choiceCard(
                    index: 0,
                    current: _paymentOption,
                    onTap: () {
                      setState(() {
                        _paymentOption = 0;
                      });
                    },
                    icon: Icons.credit_card_rounded,
                    title: 'Visa •••• 4242',
                    subtitle: 'Expires 08/28',
                    trailing: 'Change',
                  ),

                  const SizedBox(height: 10),

                  _choiceCard(
                    index: 1,
                    current: _paymentOption,
                    onTap: () {
                      setState(() {
                        _paymentOption = 1;
                      });
                    },
                    icon: Icons.payments_outlined,
                    title: 'Cash on delivery',
                    subtitle: 'Pay when your order arrives',
                    trailing: '',
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),

            // Bottom summary
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: _border)),
              ),
              child: Column(
                children: [
                  _summaryRow('Subtotal', _price(_subtotal)),

                  const SizedBox(height: 6),

                  _summaryRow(
                    'Delivery',
                    _deliveryFee == 0 ? 'Free' : _price(_deliveryFee),
                  ),

                  if (_promoApplied) ...[
                    const SizedBox(height: 6),

                    _summaryRow(
                      'Welcome offer',
                      '-${_price(_discount)}',
                      valueColor: _terracotta,
                    ),
                  ],

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, color: _border),
                  ),

                  _summaryRow('Total', _price(_total), bold: true),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'PLACE ORDER  •  ${_price(_total)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 21,
        fontWeight: FontWeight.bold,
        color: _green,
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: child,
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: bold ? _ink : _muted,
            fontSize: bold ? 16 : 13.5,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color: valueColor ?? (bold ? _green : _ink),
            fontSize: bold ? 19 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _orderLine(CheckoutItem item) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            item.imageUrl,
            width: 54,
            height: 54,
            fit: BoxFit.cover,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Container(
                    width: 54,
                    height: 54,
                    color: _cream,
                    child: const Icon(Icons.restaurant, color: _green),
                  );
                },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _ink,
                  fontSize: 14.5,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '${item.quantity} × ${_price(item.price)}',
                style: const TextStyle(color: _muted, fontSize: 13),
              ),
            ],
          ),
        ),

        Text(
          _price(item.price * item.quantity),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: _ink,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _choiceCard({
    required int index,
    required int current,
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    required String trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: _card(
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: index == current ? _green.withOpacity(0.1) : _cream,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: index == current ? _green : _muted,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _ink,
                      fontSize: 14.5,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(color: _muted, fontSize: 12.5),
                  ),
                ],
              ),
            ),

            if (trailing.isNotEmpty)
              Text(
                trailing,
                style: const TextStyle(
                  color: _green,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),

            const SizedBox(width: 8),

            Icon(
              index == current
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: index == current ? _terracotta : _muted,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }
}
