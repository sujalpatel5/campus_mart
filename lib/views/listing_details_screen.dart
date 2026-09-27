import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/wishlist_controller.dart';
import '../models/listing_model.dart';
import '../providers/wishlist_provider.dart';

class ListingDetailsScreen extends ConsumerWidget {
  final ListingModel listing;

  const ListingDetailsScreen({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    final wishlist = user == null
        ? null
        : ref.watch(wishlistProvider(user.uid));

    bool isWishlisted = false;

    if (wishlist != null) {
      wishlist.when(
        data: (items) {
          isWishlisted = items.any(
                (item) => item.listingId == listing.id,
          );
        },
        loading: () {},
        error: (_, __) {},
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Listing Details'),
        actions: [
          IconButton(
            onPressed: user == null
                ? null
                : () async {
              try {
                if (isWishlisted) {
                  await WishlistController()
                      .removeFromWishlist(listing.id);
                } else {
                  await WishlistController()
                      .addToWishlist(listing.id);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              }
            },
            icon: Icon(
              isWishlisted
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: const Color(0xFF38BDF8),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (listing.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  listing.imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      height: 220,
                      color: const Color(0xFF1F2937),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFF94A3B8),
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            Text(
              listing.title,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '₹${listing.price.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Color(0xFF38BDF8),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              listing.description,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            _detail(
              'Category',
              listing.category,
            ),
            _detail(
              'Condition',
              listing.condition,
            ),
            _detail(
              'Status',
              listing.status,
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFFF8FAFC),
              ),
            ),
          ),
        ],
      ),
    );
  }
}