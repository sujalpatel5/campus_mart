import 'package:flutter/material.dart';

import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class EditListingScreen extends StatefulWidget {
  final ListingModel listing;

  const EditListingScreen({
    super.key,
    required this.listing,
  });

  @override
  State<EditListingScreen> createState() =>
      _EditListingScreenState();
}

class _EditListingScreenState
    extends State<EditListingScreen> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController categoryController;
  late final TextEditingController conditionController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.listing.title);

    descriptionController =
        TextEditingController(text: widget.listing.description);

    priceController = TextEditingController(
      text: widget.listing.price.toStringAsFixed(0),
    );

    categoryController =
        TextEditingController(text: widget.listing.category);

    conditionController =
        TextEditingController(text: widget.listing.condition);
  }

  Future<void> updateListing() async {
    final price = double.tryParse(
      priceController.text.trim(),
    );

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid price'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final updatedListing = ListingModel(
        id: widget.listing.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        price: price,
        category: categoryController.text.trim(),
        condition: conditionController.text.trim(),
        imageUrl: widget.listing.imageUrl,
        sellerId: widget.listing.sellerId,
        createdAt: widget.listing.createdAt,
        status: 'pending',
      );

      await FirestoreService().updateListing(
        updatedListing,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Listing updated and sent for approval',
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    categoryController.dispose();
    conditionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Edit Listing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (widget.listing.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.listing.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'Books, Electronics, Furniture',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: conditionController,
              decoration: const InputDecoration(
                labelText: 'Condition',
                hintText: 'New, Like New, Good',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : updateListing,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Update Listing'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}