import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/listing_controller.dart';
import '../services/image_service.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() =>
      _CreateListingScreenState();
}

class _CreateListingScreenState
    extends State<CreateListingScreen> {
  final ListingController _listingController =
  ListingController();

  final ImageService _imageService = ImageService();

  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController =
  TextEditingController();

  final TextEditingController _descriptionController =
  TextEditingController();

  final TextEditingController _priceController =
  TextEditingController();

  final TextEditingController _sellerNameController =
  TextEditingController();

  final TextEditingController _sellerPhoneController =
  TextEditingController();

  final TextEditingController _locationController =
  TextEditingController();

  XFile? _selectedImage;

  String _selectedCategory = 'Electronics';

  String _selectedCondition = 'Like New';

  bool _isLoading = false;

  final List<String> _categories = [
    'Electronics',
    'Books',
    'Furniture',
    'Clothing',
    'Vehicles',
    'Sports',
    'Notes',
    'Accessories',
    'Other',
  ];

  final List<String> _conditions = [
    'New',
    'Like New',
    'Good',
    'Fair',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _sellerNameController.dispose();
    _sellerPhoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) {
      return;
    }

    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> createListing() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _sellerNameController.text.trim().isEmpty ||
        _sellerPhoneController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields.'),
        ),
      );
      return;
    }

    final price = double.tryParse(
      _priceController.text.trim(),
    );

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid price.'),
        ),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final imageUrl =
      await _imageService.uploadImage(
        _selectedImage!,
      );

      await _listingController.createListing(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        category: _selectedCategory,
        condition: _selectedCondition,
        imageUrl: imageUrl,
        sellerName: _sellerNameController.text.trim(),
        sellerPhone: _sellerPhoneController.text.trim(),
        location: _locationController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Listing submitted for approval.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  InputDecoration inputDecoration(
      String hint,
      IconData icon,
      ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF94A3B8),
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF38BDF8),
      ),
      filled: true,
      fillColor: const Color(0xFF1F2937),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF334155),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF38BDF8),
        ),
      ),
    );
  }

  Widget buildImageBox() {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: 205,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF334155),
          ),
        ),
        child: _selectedImage == null
            ? Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Color(0xFF38BDF8),
              size: 48,
            ),
            SizedBox(height: 10),
            Text(
              'Add Item Image',
              style: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Tap to choose from gallery',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
              ),
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(_selectedImage!.path),
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    onPressed: pickImage,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text(
          'Create Listing',
          style: TextStyle(
            color: Color(0xFFF8FAFC),
            fontSize: 21,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFF8FAFC),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          30,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Item Details',
              style: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            buildImageBox(),
            const SizedBox(height: 18),
            TextField(
              controller: _titleController,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: inputDecoration(
                'Item Name',
                Icons.shopping_bag_outlined,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: inputDecoration(
                'Description',
                Icons.description_outlined,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _priceController,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: inputDecoration(
                'Price',
                Icons.currency_rupee,
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              dropdownColor:
              const Color(0xFF1F2937),
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: inputDecoration(
                'Category',
                Icons.category_outlined,
              ),
              items: _categories.map(
                    (category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                },
              ).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              dropdownColor:
              const Color(0xFF1F2937),
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: inputDecoration(
                'Condition',
                Icons.star_border,
              ),
              items: _conditions.map(
                    (condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition),
                  );
                },
              ).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedCondition = value;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Seller Details',
              style: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _sellerNameController,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: inputDecoration(
                'Seller Name',
                Icons.person_outline,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _sellerPhoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: inputDecoration(
                'Phone Number',
                Icons.phone_outlined,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _locationController,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: inputDecoration(
                'Location',
                Icons.location_on_outlined,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                _isLoading ? null : createListing,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF38BDF8),
                  foregroundColor:
                  const Color(0xFF0F172A),
                  disabledBackgroundColor:
                  const Color(0xFF334155),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color:
                    Color(0xFF0F172A),
                  ),
                )
                    : const Text(
                  'Submit Listing',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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