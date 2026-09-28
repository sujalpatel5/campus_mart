import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/listing_controller.dart';
import '../providers/auth_provider.dart';
import '../services/image_service.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() =>
      _CreateListingScreenState();
}

class _CreateListingScreenState
    extends ConsumerState<CreateListingScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final ImageService _imageService = ImageService();

  XFile? selectedImage;

  String? selectedCategory;
  String? selectedCondition;

  final categories = [
    'Books & Notes',
    'Electronics',
    'Furniture',
    'Clothing',
    'Bikes & Cycles',
    'Sports & Fitness',
    'Stationery',
    'Other',
  ];

  final conditions = [
    'New',
    'Like New',
    'Good',
    'Fair',
  ];

  @override
  void initState() {
    super.initState();

    final user = ref.read(authStateProvider).value;

    nameController.text =
    user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : user?.email?.split('@').first ?? '';
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future<void> createListing() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        selectedCategory == null ||
        selectedCondition == null ||
        selectedImage == null ||
        nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields and select an image',
          ),
        ),
      );
      return;
    }

    try {
      ref
          .read(loadingProvider.notifier)
          .setLoading(true);

      final imageUrl =
      await _imageService.uploadImage(selectedImage!);

      await ListingController().createListing(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.parse(
          priceController.text.trim(),
        ),
        category: selectedCategory!,
        condition: selectedCondition!,
        imageUrl: imageUrl,
        sellerName: nameController.text.trim(),
        sellerPhone: phoneController.text.trim(),
        location: locationController.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Listing submitted for approval',
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    } finally {
      ref
          .read(loadingProvider.notifier)
          .setLoading(false);
    }
  }

  InputDecoration fieldDecoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF38BDF8),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF94A3B8),
      ),
      filled: true,
      fillColor: const Color(0xFF1F2937),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF334155),
        ),
      ),
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
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Create Listing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Item Details',
              style: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF334155),
                  ),
                ),
                child: selectedImage == null
                    ? const Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Color(0xFF38BDF8),
                      size: 50,
                    ),
                    SizedBox(height: 12),
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
                      ),
                    ),
                  ],
                )
                    : ClipRRect(
                  borderRadius:
                  BorderRadius.circular(16),
                  child: Image(
                    image: NetworkImage(
                      selectedImage!.path,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: titleController,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: fieldDecoration(
                'Item Name',
                Icons.shopping_bag_outlined,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: fieldDecoration(
                'Description',
                Icons.description_outlined,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: fieldDecoration(
                'Price',
                Icons.currency_rupee,
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              dropdownColor: const Color(0xFF1F2937),
              decoration: fieldDecoration(
                'Category',
                Icons.category_outlined,
              ),
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              items: categories.map(
                    (category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedCondition,
              dropdownColor: const Color(0xFF1F2937),
              decoration: fieldDecoration(
                'Condition',
                Icons.star_border,
              ),
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              items: conditions.map(
                    (condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCondition = value;
                });
              },
            ),

            const SizedBox(height: 32),

            const Text(
              'Seller Details',
              style: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: fieldDecoration(
                'Name',
                Icons.person_outline,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: fieldDecoration(
                'Mobile Number',
                Icons.phone_outlined,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: locationController,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
              decoration: fieldDecoration(
                'Location',
                Icons.location_on_outlined,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : createListing,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF38BDF8),
                  foregroundColor:
                  const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF0F172A),
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

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}