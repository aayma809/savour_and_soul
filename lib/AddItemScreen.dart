import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _stockController = TextEditingController();

  // Matches the category chips shown in your menu screen
  final List<String> _categories = const [
    'Starters',
    'Mains',
    'Desserts',
    'Beverages',
  ];
  String _selectedCategory = 'Starters';

  bool _isAvailable = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'category': _selectedCategory,
        'imageUrls': _imageUrlController.text.trim().isNotEmpty
            ? [_imageUrlController.text.trim()]
            : [],
        'stock': int.parse(_stockController.text.trim()),
        'isAvailable': _isAvailable,
        'isFavorite': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding item: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F1EA,
      ), // matches your app's cream background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F1EA),
        elevation: 0,
        title: const Text(
          'Add New Item',
          style: TextStyle(
            color: Color(0xFF2E4A3F), // matches your app's dark green
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2E4A3F)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildLabel('Item Name'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('e.g. Heirloom Burrata Salad'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              _buildLabel('Description'),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: _inputDecoration(
                  'e.g. Creamy artisan burrata, vine-ripened tomatoes...',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              _buildLabel('Price (Rs.)'),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: _inputDecoration('e.g. 5000'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v.trim()) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildLabel('Category'),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: _inputDecoration(''),
                items: _categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              _buildLabel('Stock Quantity'),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('e.g. 20'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (int.tryParse(v.trim()) == null) {
                    return 'Enter a valid whole number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildLabel('Image URL'),
              TextFormField(
                controller: _imageUrlController,
                decoration: _inputDecoration('https://...'),
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Available',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                activeColor: const Color(0xFF2E4A3F),
                value: _isAvailable,
                onChanged: (value) => setState(() => _isAvailable = value),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E4A3F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isSaving ? null : _saveItem,
                  child: _isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Add Item',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E4A3F),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
